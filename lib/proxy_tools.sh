#!/usr/bin/env bash

check_cmd() {
  command -v "$1" >/dev/null 2>&1
}

snell_status() {
  echo "=== Snell 状态 ==="
  if check_cmd snell-server; then
    echo "已安装 snell-server: $(command -v snell-server)"
  else
    echo "未安装 snell-server"
    echo "后续可补：一键下载 + systemd 管理"
  fi
}

xray_status() {
  echo "=== Xray 状态 ==="
  if check_cmd xray; then
    echo "已安装 xray: $(command -v xray)"
  else
    echo "未安装 xray"
    echo "后续可补：一键安装 Xray / Reality 配置生成"
  fi
}

singbox_status() {
  echo "=== sing-box 状态 ==="
  if check_cmd sing-box; then
    echo "已安装 sing-box: $(command -v sing-box)"
  else
    echo "未安装 sing-box"
    echo "后续可补：一键安装 sing-box / 配置生成"
  fi
}

cloudflared_status() {
  echo "=== Cloudflare Tunnel 状态 ==="
  if check_cmd cloudflared; then
    echo "已安装 cloudflared: $(command -v cloudflared)"
  else
    echo "未安装 cloudflared"
    echo "后续可补：一键安装 cloudflared / tunnel 登录与配置引导"
  fi
}

socks5_status() {
  echo "=== SOCKS5 代理环境 ==="
  if check_cmd microsocks; then
    echo "已安装 microsocks: $(command -v microsocks)"
  else
    echo "未检测到 microsocks"
    echo "后续可补：一键部署 SOCKS5"
  fi
}

proxy_tools_overview() {
  snell_status
  echo
  xray_status
  echo
  singbox_status
  echo
  cloudflared_status
  echo
  socks5_status
}
