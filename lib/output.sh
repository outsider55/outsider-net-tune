#!/usr/bin/env bash

section() {
  echo
  echo "========================================"
  echo " $*"
  echo "========================================"
}

summary_line() {
  local k="$1"; shift
  printf '%-18s %s\n' "$k" "$*"
}

show_post_opt_summary() {
  section "优化结果摘要"
  local cc qdisc fastopen
  cc=$(/usr/sbin/sysctl -n net.ipv4.tcp_congestion_control 2>/dev/null || echo unknown)
  qdisc=$(/usr/sbin/sysctl -n net.core.default_qdisc 2>/dev/null || echo unknown)
  fastopen=$(/usr/sbin/sysctl -n net.ipv4.tcp_fastopen 2>/dev/null || echo unknown)
  summary_line "拥塞控制" "$cc"
  summary_line "队列算法" "$qdisc"
  summary_line "TCP Fast Open" "$fastopen"
  summary_line "备份目录" "${HOME}/.outsider-net-tune/backups"
}

show_connection_summary() {
  local title="$1"
  shift
  section "$title"
  while [[ $# -gt 1 ]]; do
    summary_line "$1" "$2"
    shift 2
  done
}

show_next_steps() {
  section "下一步建议"
  for line in "$@"; do
    echo "- $line"
  done
}
