#!/usr/bin/env bash

ROOT_DIR="${BASE_DIR:-$(cd -- "$(dirname -- "$0")/.." && pwd)}"
SYSCTL_TEMPLATE="$ROOT_DIR/templates/sysctl.conf.tpl"
TARGET_SYSCTL_FILE="/etc/sysctl.d/99-outsider-net-tune.conf"
SYSCTL_BIN="/usr/sbin/sysctl"
[[ -x "$SYSCTL_BIN" ]] || SYSCTL_BIN="$(command -v sysctl || true)"

sysctl_preview() {
  echo "推荐 TCP 优化参数（预览）："
  cat "$SYSCTL_TEMPLATE"
}

sysctl_apply() {
  need_root || return 1
  backup_configs
  cp "$SYSCTL_TEMPLATE" "$TARGET_SYSCTL_FILE"
  "$SYSCTL_BIN" --system >/dev/null 2>&1 || {
    echo "sysctl 应用时出现问题，请检查配置。"
    return 1
  }
  echo "已应用优化参数到: $TARGET_SYSCTL_FILE"
}
