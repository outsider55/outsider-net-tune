#!/usr/bin/env bash

SYSCTL_BIN="/usr/sbin/sysctl"
[[ -x "$SYSCTL_BIN" ]] || SYSCTL_BIN="$(command -v sysctl || true)"
MODPROBE_BIN="/usr/sbin/modprobe"
[[ -x "$MODPROBE_BIN" ]] || MODPROBE_BIN="$(command -v modprobe || true)"

bbr_status() {
  echo "当前拥塞控制:"
  "$SYSCTL_BIN" net.ipv4.tcp_congestion_control 2>/dev/null || echo "无法读取"
  echo
  echo "可用拥塞控制算法:"
  "$SYSCTL_BIN" net.ipv4.tcp_available_congestion_control 2>/dev/null || echo "无法读取"
  echo
  echo "队列算法:"
  "$SYSCTL_BIN" net.core.default_qdisc 2>/dev/null || echo "无法读取"
}

bbr_enable() {
  need_root || return 1
  backup_configs

  if [[ -n "$MODPROBE_BIN" ]]; then
    "$MODPROBE_BIN" tcp_bbr 2>/dev/null || true
  fi

  local current available
  current=$("$SYSCTL_BIN" -n net.ipv4.tcp_congestion_control 2>/dev/null || echo '')
  available=$("$SYSCTL_BIN" -n net.ipv4.tcp_available_congestion_control 2>/dev/null || echo '')

  if echo "$available" | grep -qw bbr; then
    mkdir -p /etc/sysctl.d
    cat >/etc/sysctl.d/98-outsider-bbr.conf <<'EOF'
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF
    "$SYSCTL_BIN" --system >/dev/null 2>&1 || true
    echo "已尝试启用 BBR"
    bbr_status
  else
    echo "当前内核似乎不支持 BBR，需后续补内核安装逻辑。"
    echo "当前拥塞控制: ${current:-unknown}"
  fi
}
