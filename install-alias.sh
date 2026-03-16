#!/usr/bin/env bash
set -euo pipefail

TARGET_CMD="ont"
SCRIPT_URL="https://raw.githubusercontent.com/outsider55/outsider-net-tune/main/main.sh"
SHELL_RC="$HOME/.bashrc"
[[ -n "${ZSH_VERSION:-}" ]] && SHELL_RC="$HOME/.zshrc"

grep -q "alias ${TARGET_CMD}=" "$SHELL_RC" 2>/dev/null || echo "alias ${TARGET_CMD}='bash <(curl -fsSL ${SCRIPT_URL})'" >> "$SHELL_RC"

echo "已安装快捷命令: ${TARGET_CMD}"
echo "请执行: source $SHELL_RC"
echo "以后直接输入: ${TARGET_CMD}"
