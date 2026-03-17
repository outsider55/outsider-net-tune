#!/usr/bin/env bash

status_dashboard() {
  section "outsider-net-tune 状态总览"

  local cc qdisc fastopen dns_mode ipv4_pref
  cc=$(/usr/sbin/sysctl -n net.ipv4.tcp_congestion_control 2>/dev/null || echo unknown)
  qdisc=$(/usr/sbin/sysctl -n net.core.default_qdisc 2>/dev/null || echo unknown)
  fastopen=$(/usr/sbin/sysctl -n net.ipv4.tcp_fastopen 2>/dev/null || echo unknown)

  if grep -q '^precedence ::ffff:0:0/96  100' /etc/gai.conf 2>/dev/null; then
    ipv4_pref='已启用'
  else
    ipv4_pref='默认/IPv6'
  fi

  if grep -q '^DNS=1.1.1.1 8.8.8.8' /etc/systemd/resolved.conf 2>/dev/null; then
    dns_mode='国外模式'
  elif grep -q '^DNS=223.5.5.5 119.29.29.29' /etc/systemd/resolved.conf 2>/dev/null; then
    dns_mode='国内模式'
  else
    dns_mode='系统默认'
  fi

  summary_line '拥塞控制' "$cc"
  summary_line '队列算法' "$qdisc"
  summary_line 'TCP Fast Open' "$fastopen"
  summary_line 'IPv4 优先' "$ipv4_pref"
  summary_line 'DNS 模式' "$dns_mode"
  echo

  section "扩展工具状态"
  for cmd in microsocks cloudflared xray sing-box snell-server; do
    if command -v "$cmd" >/dev/null 2>&1; then
      summary_line "$cmd" "已安装"
    else
      summary_line "$cmd" "未安装"
    fi
  done

  echo
  section "服务状态"
  for svc in outsider-microsocks.service outsider-xray.service outsider-singbox.service outsider-snell.service; do
    if systemctl list-unit-files | grep -q "^${svc}"; then
      state=$(systemctl is-active "$svc" 2>/dev/null || true)
      summary_line "$svc" "${state:-unknown}"
    else
      summary_line "$svc" "未创建"
    fi
  done
}
