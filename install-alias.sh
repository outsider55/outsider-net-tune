#!/usr/bin/env bash
set -euo pipefail

INSTALL_BASE="${INSTALL_BASE:-$HOME/.outsider-net-tune}"
TARGET_SCRIPT="$INSTALL_BASE/app/main.sh"

if [[ ! -f "$TARGET_SCRIPT" ]]; then
  echo "未找到主脚本: $TARGET_SCRIPT"
  echo "请先运行 bootstrap.sh 完成安装"
  exit 1
fi

if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
  BIN_DIR="/usr/local/bin"
else
  BIN_DIR="$HOME/.local/bin"
  mkdir -p "$BIN_DIR"
  case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *)
      SHELL_RC="$HOME/.bashrc"
      [[ -n "${ZSH_VERSION:-}" ]] && SHELL_RC="$HOME/.zshrc"
      grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$SHELL_RC" 2>/dev/null || \
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
      ;;
  esac
fi

cat >"$BIN_DIR/x" <<EOF
#!/usr/bin/env bash
bash "$TARGET_SCRIPT" "\$@"
EOF
chmod +x "$BIN_DIR/x"

cat >"$BIN_DIR/X" <<EOF
#!/usr/bin/env bash
bash "$TARGET_SCRIPT" "\$@"
EOF
chmod +x "$BIN_DIR/X"

echo "已安装快捷命令: x / X"
echo "安装位置: $BIN_DIR"
if [[ "$BIN_DIR" == "$HOME/.local/bin" ]]; then
  echo "如果当前终端还不能直接执行 x，请先运行: source ~/.bashrc"
fi
echo "以后可直接使用:"
echo "  x"
echo "或"
echo "  X"
