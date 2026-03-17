#!/usr/bin/env bash

ROOT_DIR="${BASE_DIR:-$(cd -- "$(dirname -- "$0")/.." && pwd)}"
TARGET_SYSCTL_FILE="/etc/sysctl.d/99-outsider-net-tune.conf"

apply_mode_template() {
  local template="$1"
  need_root || return 1
  backup_configs || return 1
  cp "$template" "$TARGET_SYSCTL_FILE"
  /usr/sbin/sysctl --system >/dev/null 2>&1 || {
    echo "应用模式参数失败，请检查 sysctl 配置"
    return 1
  }
}

mode_direct() {
  echo "[直连模式] 开始执行"
  echo "- 应用直连优化模板"
  apply_mode_template "$ROOT_DIR/templates/sysctl-direct.conf.tpl" || return 1
  echo "- 输出诊断结果"
  diagnose_all
  echo "[直连模式] 执行完成"
}

mode_landing() {
  echo "[落地模式] 开始执行"
  echo "- 应用落地优化模板"
  apply_mode_template "$ROOT_DIR/templates/sysctl-landing.conf.tpl" || return 1
  echo "- 输出诊断结果"
  diagnose_all
  echo "[落地模式] 执行完成"
}

mode_relay() {
  echo "[中转 / Realm 模式] 开始执行"
  echo "- 应用中转优化模板"
  apply_mode_template "$ROOT_DIR/templates/sysctl-relay.conf.tpl" || return 1
  echo "- 输出诊断结果"
  diagnose_all
  echo "[中转 / Realm 模式] 执行完成"
}

mode_auto_all() {
  echo "[一键自动优化] 开始执行"
  echo "步骤 1/4: 备份当前配置"
  backup_configs || return 1

  echo "步骤 2/4: 尝试启用 BBR"
  bbr_enable || true

  echo "步骤 3/4: 自动选择优化模板"
  local mem_mb
  mem_mb=$(awk '/MemTotal/ {print int($2/1024)}' /proc/meminfo 2>/dev/null || echo 0)
  if [[ "$mem_mb" -ge 2048 ]]; then
    echo "- 检测到内存 >= 2GB，应用落地模式模板"
    apply_mode_template "$ROOT_DIR/templates/sysctl-landing.conf.tpl" || return 1
  else
    echo "- 检测到小内存机器，应用直连模式模板"
    apply_mode_template "$ROOT_DIR/templates/sysctl-direct.conf.tpl" || return 1
  fi

  echo "步骤 4/4: 输出最终诊断"
  echo "- 默认保持当前 IPv4/IPv6 策略不变"
  diagnose_all
  echo "[一键自动优化] 执行完成"
}
