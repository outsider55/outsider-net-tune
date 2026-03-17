#!/usr/bin/env bash
set -euo pipefail

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH:-}"
REPO_TGZ_URL="https://github.com/outsider55/outsider-net-tune/archive/refs/heads/main.tar.gz"
INSTALL_BASE="${INSTALL_BASE:-$HOME/.outsider-net-tune}"
TMP_TGZ="/tmp/outsider-net-tune-main.tar.gz"
TMP_DIR="/tmp/outsider-net-tune-main"

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

install_base_deps() {
  local missing=()
  need_cmd tar || missing+=(tar)
  need_cmd unzip || missing+=(unzip)
  need_cmd ca-certificates || true

  if [ ${#missing[@]} -eq 0 ]; then
    return 0
  fi

  echo "检测到缺少基础依赖: ${missing[*]}"

  if need_cmd apt-get; then
    apt-get update -y
    DEBIAN_FRONTEND=noninteractive apt-get install -y "${missing[@]}" ca-certificates
  elif need_cmd dnf; then
    dnf install -y "${missing[@]}" ca-certificates
  elif need_cmd yum; then
    yum install -y "${missing[@]}" ca-certificates
  elif need_cmd apk; then
    apk add --no-cache "${missing[@]}" ca-certificates
  else
    echo "无法自动安装依赖，请手动安装: ${missing[*]}"
    exit 1
  fi
}

mkdir -p "$INSTALL_BASE"
rm -rf "$TMP_DIR" "$TMP_TGZ"

install_base_deps

echo "下载 outsider-net-tune..."
curl -fsSL -o "$TMP_TGZ" "$REPO_TGZ_URL"

tar -xzf "$TMP_TGZ" -C /tmp
rm -rf "$INSTALL_BASE/app"
mkdir -p "$INSTALL_BASE"
mv "$TMP_DIR" "$INSTALL_BASE/app"
chmod +x "$INSTALL_BASE/app"/*.sh "$INSTALL_BASE/app"/lib/*.sh 2>/dev/null || true

# 默认顺手安装快捷命令，不再额外打扰用户
if [ -f "$INSTALL_BASE/app/install-alias.sh" ]; then
  bash "$INSTALL_BASE/app/install-alias.sh" >/tmp/outsider-net-tune-alias.log 2>&1 || true
fi

echo
echo "安装完成"
echo "目录: $INSTALL_BASE/app"
echo
echo "运行方式:"
echo "  bash $INSTALL_BASE/app/main.sh"
echo "或直接输入:"
echo "  x"
echo "  X"
if grep -q 'source ~/.bashrc' /tmp/outsider-net-tune-alias.log 2>/dev/null; then
  echo
  echo "提示：当前环境可能需要先执行 source ~/.bashrc 才能直接识别 x 命令"
fi
