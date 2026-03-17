#!/usr/bin/env bash
set -euo pipefail

REPO_ZIP_URL="https://github.com/outsider55/outsider-net-tune/archive/refs/heads/main.zip"
INSTALL_BASE="${INSTALL_BASE:-$HOME/.outsider-net-tune}"
TMP_ZIP="/tmp/outsider-net-tune-main.zip"
TMP_DIR="/tmp/outsider-net-tune-main"

mkdir -p "$INSTALL_BASE"
rm -rf "$TMP_DIR" "$TMP_ZIP"

echo "下载 outsider-net-tune..."
curl -fsSL -o "$TMP_ZIP" "$REPO_ZIP_URL"

unzip -qo "$TMP_ZIP" -d /tmp
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
