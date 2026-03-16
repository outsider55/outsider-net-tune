#!/usr/bin/env bash

RESOLVED_CONF="/etc/systemd/resolved.conf"

show_dns_status() {
  echo "=== 当前 DNS 配置 ==="
  grep -E '^(DNS|FallbackDNS|DNSStubListener)=' "$RESOLVED_CONF" 2>/dev/null || echo "resolved.conf 未配置自定义 DNS"
  echo
  echo "=== resolv.conf ==="
  cat /etc/resolv.conf 2>/dev/null || true
}

apply_dns_mode() {
  local mode="$1"
  need_root || return 1
  backup_configs || return 1
  mkdir -p /etc/systemd
  touch "$RESOLVED_CONF"
  sed -i '/^DNS=/d;/^FallbackDNS=/d' "$RESOLVED_CONF"

  case "$mode" in
    abroad)
      {
        echo 'DNS=1.1.1.1 8.8.8.8'
        echo 'FallbackDNS=9.9.9.9 1.0.0.1'
      } >> "$RESOLVED_CONF"
      echo "已设置为国外 DNS 模式"
      ;;
    cn)
      {
        echo 'DNS=223.5.5.5 119.29.29.29'
        echo 'FallbackDNS=180.76.76.76 114.114.114.114'
      } >> "$RESOLVED_CONF"
      echo "已设置为国内 DNS 模式"
      ;;
    restore)
      echo "已移除自定义 DNS，恢复系统默认 DNS 行为"
      ;;
    *)
      echo "未知 DNS 模式: $mode"
      return 1
      ;;
  esac

  systemctl restart systemd-resolved 2>/dev/null || true
}
