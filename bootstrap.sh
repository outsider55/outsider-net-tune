#!/usr/bin/env bash
set -euo pipefail

REPO_TGZ_URL="https://github.com/outsider55/outsider-net-tune/archive/refs/heads/main.tar.gz"
INSTALL_BASE="${INSTALL_BASE:-$HOME/.outsider-net-tune}"
TMP_TGZ="/tmp/outsider-net-tune-main.tar.gz"
TMP_DIR="/tmp/outsider-net-tune-main"

mkdir -p "$INSTALL_BASE"
rm -rf "$TMP_DIR" "$TMP_TGZ"

echo "下载 outsider-net-tune..."
curl -fsSL -o "$TMP_TGZ" "$REPO_TGZ_URL"

tar -xzf "$TMP_TGZ" -C /tmp
rm -rf "$INSTALL_BASE/app"
mkdir -p "$INSTALL_BASE"
mv "$TMP_DIR" "$INSTALL_BASE/app"
chmod +x "$INSTALL_BASE/app"/*.sh "$INSTALL_BASE/app"/lib/*.sh 2>/dev/null || true

echo
echo "安装完成"
echo "目录: $INSTALL_BASE/app"
echo
echo "运行方式:"
echo "  bash $INSTALL_BASE/app/main.sh"
echo
echo "如果你想安装快捷命令："
echo "  bash $INSTALL_BASE/app/install-alias.sh"
