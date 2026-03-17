#!/usr/bin/env bash
set -euo pipefail

TARGET_CMD="X"
BOOTSTRAP_URL="https://raw.githubusercontent.com/outsider55/outsider-net-tune/main/bootstrap.sh"
INSTALL_BASE="${INSTALL_BASE:-$HOME/.outsider-net-tune}"
SHELL_RC="$HOME/.bashrc"
[[ -n "${ZSH_VERSION:-}" ]] && SHELL_RC="$HOME/.zshrc"

# 覆盖旧别名
sed -i "/alias ont=/d;/alias X=/d" "$SHELL_RC" 2>/dev/null || true
echo "alias ${TARGET_CMD}='bash ${INSTALL_BASE}/app/main.sh'" >> "$SHELL_RC"

echo "已安装快捷命令: ${TARGET_CMD}"
echo "请执行: source $SHELL_RC"
echo "以后直接输入: ${TARGET_CMD}"
