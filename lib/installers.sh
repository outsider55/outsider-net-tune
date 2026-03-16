#!/usr/bin/env bash

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH:-}"
MICROSOCKS_SERVICE="/etc/systemd/system/outsider-microsocks.service"

get_arch() {
  case "$(uname -m)" in
    x86_64|amd64) echo "64" ;;
    aarch64|arm64) echo "arm64-v8a" ;;
    armv7l|armv7) echo "arm32-v7a" ;;
    *) echo "64" ;;
  esac
}

install_microsocks() {
  need_root || return 1
  if command -v microsocks >/dev/null 2>&1; then
    echo "microsocks 已安装: $(command -v microsocks)"
    return 0
  fi
  echo "开始安装 microsocks..."
  if command -v apt >/dev/null 2>&1; then
    apt update -y && apt install -y microsocks
  else
    echo "暂不支持当前系统的一键安装 microsocks"
    return 1
  fi
  command -v microsocks >/dev/null 2>&1 && echo "microsocks 安装成功" || { echo "microsocks 安装失败"; return 1; }
}

deploy_microsocks() {
  need_root || return 1
  install_microsocks || return 1
  local port user pass bind_ip
  read -rp "请输入监听端口 [1080]: " port
  port="${port:-1080}"
  read -rp "请输入用户名（留空则无认证）: " user
  if [[ -n "$user" ]]; then read -rsp "请输入密码: " pass; echo; else pass=""; fi
  read -rp "请输入绑定地址 [0.0.0.0]: " bind_ip
  bind_ip="${bind_ip:-0.0.0.0}"
  backup_configs || true
  cat > "$MICROSOCKS_SERVICE" <<EOF
[Unit]
Description=outsider-net-tune microsocks service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/microsocks -i ${bind_ip} -p ${port} ${user:+-u ${user}} ${pass:+-P ${pass}}
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF
  systemctl daemon-reload
  systemctl enable --now outsider-microsocks.service
  systemctl --no-pager --full status outsider-microsocks.service | sed -n '1,12p'
  echo
  echo "SOCKS5 已部署完成"
  echo "地址: ${bind_ip}:${port}"
  [[ -n "$user" ]] && echo "认证: ${user} / ${pass}"
}

show_microsocks_service() {
  if systemctl list-unit-files | grep -q '^outsider-microsocks.service'; then
    systemctl --no-pager --full status outsider-microsocks.service | sed -n '1,20p'
  else
    echo "未检测到 outsider-microsocks.service"
  fi
}

install_cloudflared() {
  need_root || return 1
  if command -v cloudflared >/dev/null 2>&1; then
    echo "cloudflared 已安装: $(command -v cloudflared)"
    return 0
  fi
  echo "开始安装 cloudflared..."
  local tmpdeb="/tmp/cloudflared-linux-amd64.deb"
  curl -fsSL -o "$tmpdeb" https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb || { echo "下载 cloudflared 失败"; return 1; }
  dpkg -i "$tmpdeb" || apt-get install -f -y
  rm -f "$tmpdeb"
  command -v cloudflared >/dev/null 2>&1 && { echo "cloudflared 安装成功"; echo "下一步可执行: cloudflared tunnel login"; } || { echo "cloudflared 安装失败"; return 1; }
}

cloudflared_quickstart() {
  install_cloudflared || return 1
  cat <<'EOF'

Cloudflare Tunnel 快速开始：
1. 登录 Cloudflare：
   cloudflared tunnel login
2. 创建 Tunnel：
   cloudflared tunnel create outsider-net-tune
3. 为本地服务创建路由（示例 8080）：
   cloudflared tunnel route dns outsider-net-tune sub.example.com
4. 启动转发：
   cloudflared tunnel --url http://localhost:8080 run outsider-net-tune
如果你只是想临时暴露一个本地端口，也可以：
   cloudflared tunnel --url http://localhost:8080
EOF
}

show_cloudflared_status() {
  if command -v cloudflared >/dev/null 2>&1; then
    echo "cloudflared 已安装: $(command -v cloudflared)"
    cloudflared --version | head -1
  else
    echo "未检测到 cloudflared"
  fi
}

install_xray() {
  need_root || return 1
  if command -v xray >/dev/null 2>&1; then echo "xray 已安装: $(command -v xray)"; return 0; fi
  local arch url zip tmpdir
  arch="$(get_arch)"
  case "$arch" in
    64) url="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip" ;;
    arm64-v8a) url="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-arm64-v8a.zip" ;;
    arm32-v7a) url="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-arm32-v7a.zip" ;;
    *) url="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip" ;;
  esac
  zip="/tmp/xray.zip"; tmpdir="/tmp/xray-install"
  rm -rf "$tmpdir" && mkdir -p "$tmpdir"
  echo "开始安装 Xray..."
  curl -fsSL -o "$zip" "$url" || { echo "下载 Xray 失败"; return 1; }
  unzip -qo "$zip" -d "$tmpdir"
  install -m 755 "$tmpdir/xray" /usr/local/bin/xray
  mkdir -p /usr/local/share/xray /usr/local/etc/xray
  [[ -f "$tmpdir/geosite.dat" ]] && install -m 644 "$tmpdir/geosite.dat" /usr/local/share/xray/geosite.dat
  [[ -f "$tmpdir/geoip.dat" ]] && install -m 644 "$tmpdir/geoip.dat" /usr/local/share/xray/geoip.dat
  if [[ ! -f /usr/local/etc/xray/config.json ]]; then
    cat > /usr/local/etc/xray/config.json <<'EOF'
{
  "log": {"loglevel": "warning"},
  "inbounds": [],
  "outbounds": [{"protocol": "freedom", "settings": {}}]
}
EOF
  fi
  echo "Xray 安装成功"
  echo "配置目录: /usr/local/etc/xray"
}

install_singbox() {
  need_root || return 1
  if command -v sing-box >/dev/null 2>&1; then echo "sing-box 已安装: $(command -v sing-box)"; return 0; fi
  local api_url asset_url tgz tmpdir bin pattern
  case "$(uname -m)" in
    x86_64|amd64) pattern='linux-amd64.*\.tar\.gz' ;;
    aarch64|arm64) pattern='linux-arm64.*\.tar\.gz' ;;
    *) echo "当前架构暂未适配 sing-box 一键安装"; return 1 ;;
  esac
  api_url='https://api.github.com/repos/SagerNet/sing-box/releases/latest'
  asset_url=$(curl -fsSL "$api_url" | python3 -c "import sys,json,re; data=json.load(sys.stdin); patt=re.compile('$pattern'); urls=[a['browser_download_url'] for a in data.get('assets',[]) if patt.search(a['name'])]; print(urls[0] if urls else '')")
  [[ -n "$asset_url" ]] || { echo "未找到合适的 sing-box 安装包"; return 1; }
  tgz="/tmp/sing-box.tgz"; tmpdir="/tmp/singbox-install"
  rm -rf "$tmpdir" && mkdir -p "$tmpdir"
  echo "开始安装 sing-box..."
  curl -fsSL -o "$tgz" "$asset_url" || { echo "下载 sing-box 失败"; return 1; }
  tar -xzf "$tgz" -C "$tmpdir"
  bin=$(find "$tmpdir" -type f -name 'sing-box' | head -1)
  [[ -n "$bin" ]] || { echo "未找到 sing-box 二进制"; return 1; }
  install -m 755 "$bin" /usr/local/bin/sing-box
  mkdir -p /usr/local/etc/sing-box
  echo "sing-box 安装成功"
  echo "配置目录: /usr/local/etc/sing-box"
}

install_xray_placeholder() { install_xray; }
install_snell_placeholder() { echo "Snell 一键安装逻辑将在后续版本实现。"; }
install_singbox_placeholder() { install_singbox; }
