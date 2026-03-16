#!/usr/bin/env bash

BACKUP_DIR="${HOME}/.outsider-net-tune/backups"
STATE_DIR="${HOME}/.outsider-net-tune/state"
SYSCTL_BIN="/usr/sbin/sysctl"
[[ -x "$SYSCTL_BIN" ]] || SYSCTL_BIN="$(command -v sysctl || true)"
mkdir -p "$BACKUP_DIR" "$STATE_DIR"

log() {
  printf '[%s] %s\n' "$(date '+%F %T')" "$*"
}

log_warn() {
  printf '[%s] [WARN] %s\n' "$(date '+%F %T')" "$*"
}

need_root() {
  if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    echo "请使用 root 运行此命令"
    return 1
  fi
}

latest_backup_dir() {
  ls -1dt "$BACKUP_DIR"/* 2>/dev/null | head -1
}

list_backups() {
  echo "=== 备份列表 ==="
  ls -1dt "$BACKUP_DIR"/* 2>/dev/null || echo "暂无备份"
}

backup_configs() {
  need_root || return 1
  local ts target
  ts="$(date '+%Y%m%d-%H%M%S')"
  target="$BACKUP_DIR/$ts"
  mkdir -p "$target"

  [[ -f /etc/sysctl.conf ]] && cp /etc/sysctl.conf "$target/sysctl.conf" || true
  [[ -f /etc/gai.conf ]] && cp /etc/gai.conf "$target/gai.conf" || true
  [[ -f /etc/systemd/resolved.conf ]] && cp /etc/systemd/resolved.conf "$target/resolved.conf" || true
  [[ -f /etc/sysctl.d/99-outsider-net-tune.conf ]] && cp /etc/sysctl.d/99-outsider-net-tune.conf "$target/99-outsider-net-tune.conf" || true
  [[ -f /etc/sysctl.d/98-outsider-bbr.conf ]] && cp /etc/sysctl.d/98-outsider-bbr.conf "$target/98-outsider-bbr.conf" || true

  printf '%s\n' "$target" > "$STATE_DIR/last_backup"
  log "配置已备份到: $target"
}

rollback_configs() {
  need_root || return 1
  local target
  if [[ -n "${1:-}" ]]; then
    target="$1"
  elif [[ -f "$STATE_DIR/last_backup" ]]; then
    target="$(cat "$STATE_DIR/last_backup")"
  else
    target="$(latest_backup_dir)"
  fi

  if [[ -z "$target" || ! -d "$target" ]]; then
    echo "未找到可用备份目录"
    return 1
  fi

  [[ -f "$target/sysctl.conf" ]] && cp "$target/sysctl.conf" /etc/sysctl.conf
  [[ -f "$target/gai.conf" ]] && cp "$target/gai.conf" /etc/gai.conf
  [[ -f "$target/resolved.conf" ]] && cp "$target/resolved.conf" /etc/systemd/resolved.conf

  if [[ -f "$target/99-outsider-net-tune.conf" ]]; then
    cp "$target/99-outsider-net-tune.conf" /etc/sysctl.d/99-outsider-net-tune.conf
  else
    rm -f /etc/sysctl.d/99-outsider-net-tune.conf
  fi

  if [[ -f "$target/98-outsider-bbr.conf" ]]; then
    cp "$target/98-outsider-bbr.conf" /etc/sysctl.d/98-outsider-bbr.conf
  else
    rm -f /etc/sysctl.d/98-outsider-bbr.conf
  fi

  "$SYSCTL_BIN" --system >/dev/null 2>&1 || log_warn "sysctl 重新加载时有告警，请手动检查"
  systemctl restart systemd-resolved 2>/dev/null || true
  log "已从备份恢复: $target"
}
