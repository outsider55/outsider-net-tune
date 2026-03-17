#!/usr/bin/env bash
set -euo pipefail

TARGET_CMD="ont"
BOOTSTRAP_URL="https://raw.githubusercontent.com/outsider55/outsider-net-tune/main/bootstrap.sh"
INSTALL_BASE="${INSTALL_BASE:-$HOME/.outsider-net-tune}"
SHELL_RC="$HOME/.bashrc"
[[ -n "${ZSH_VERSION:-}" ]] && SHELL_RC="$HOME/.zshrc"

grep -q "alias ${TARGET_CMD}=" "$SHELL_RC" 2>/dev/null || echo "alias ${TARGET_CMD}='bash <(curl -fsSL ${BOOTSTRAP_URL}) >/dev/null && bash ${INSTALL_BASE}/app/main.sh'" >> "$SHELL_RC"

echo "已安装快捷命令: ${TARGET_CMD}"
echo "请执行: source $SHELL_RC"
echo "以后直接输入: ${TARGET_CMD}"
