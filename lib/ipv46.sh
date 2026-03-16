#!/usr/bin/env bash

GAI_CONF="/etc/gai.conf"

ensure_gai_conf() {
  [[ -f "$GAI_CONF" ]] || touch "$GAI_CONF"
}

ipv4_prefer() {
  need_root || return 1
  backup_configs
  ensure_gai_conf
  sed -i '/^precedence ::ffff:0:0\/96 /d' "$GAI_CONF"
  echo 'precedence ::ffff:0:0/96  100' >> "$GAI_CONF"
  echo '已设置为 IPv4 优先'
}

ipv6_prefer() {
  need_root || return 1
  backup_configs
  ensure_gai_conf
  sed -i '/^precedence ::ffff:0:0\/96 /d' "$GAI_CONF"
  echo '已恢复 IPv6 / 系统默认优先策略（移除 IPv4 优先项）'
}
