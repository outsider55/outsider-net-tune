#!/usr/bin/env bash

SYSCTL_BIN="/usr/sbin/sysctl"
[[ -x "$SYSCTL_BIN" ]] || SYSCTL_BIN="$(command -v sysctl || true)"

get_ip() {
  local url="$1"
  curl -fsS --max-time 6 "$url" 2>/dev/null || true
}

diagnose_all() {
  echo "=== 系统信息 ==="
  uname -a || true
  echo
  echo "=== 出口 IPv4 ==="
  get_ip https://api.ipify.org || echo "获取失败"
  echo
  echo "=== 出口 IPv6 ==="
  ip6=$(get_ip https://api64.ipify.org)
  if [[ -n "$ip6" ]]; then echo "$ip6"; else echo "获取失败或无 IPv6"; fi
  echo
  echo "=== DNS ==="
  cat /etc/resolv.conf 2>/dev/null || true
  echo
  echo "=== 当前 TCP 关键参数 ==="
  "$SYSCTL_BIN" net.ipv4.tcp_congestion_control 2>/dev/null || true
  "$SYSCTL_BIN" net.core.default_qdisc 2>/dev/null || true
  "$SYSCTL_BIN" net.ipv4.tcp_fastopen 2>/dev/null || true
}
