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
  apply_mode_template "$ROOT_DIR/templates/sysctl-direct.conf.tpl" || return 1
  diagnose_all
  echo "[直连模式] 执行完成"
}

mode_landing() {
  echo "[落地模式] 开始执行"
  apply_mode_template "$ROOT_DIR/templates/sysctl-landing.conf.tpl" || return 1
  diagnose_all
  echo "[落地模式] 执行完成"
}

mode_relay() {
  echo "[中转 / Realm 模式] 开始执行"
  apply_mode_template "$ROOT_DIR/templates/sysctl-relay.conf.tpl" || return 1
  diagnose_all
  echo "[中转 / Realm 模式] 执行完成"
}

mode_auto_all() {
  echo "[一键自动优化] 开始执行"
  backup_configs || return 1
  bbr_enable || true
  apply_mode_template "$ROOT_DIR/templates/sysctl-direct.conf.tpl" || return 1
  echo "默认保持当前 IPv4/IPv6 策略不变"
  diagnose_all
  echo "[一键自动优化] 执行完成"
}
