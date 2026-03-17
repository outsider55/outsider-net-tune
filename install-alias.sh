#!/usr/bin/env bash
set -euo pipefail

INSTALL_BASE="${INSTALL_BASE:-$HOME/.outsider-net-tune}"
TARGET_SCRIPT="$INSTALL_BASE/app/main.sh"

if [[ ! -f "$TARGET_SCRIPT" ]]; then
  echo "未找到主脚本: $TARGET_SCRIPT"
  echo "请先运行 bootstrap.sh 完成安装"
  exit 1
fi

cat >/usr/local/bin/x <<EOF
#!/usr/bin/env bash
bash "$TARGET_SCRIPT" "\$@"
EOF
chmod +x /usr/local/bin/x

cat >/usr/local/bin/X <<EOF
#!/usr/bin/env bash
bash "$TARGET_SCRIPT" "\$@"
EOF
chmod +x /usr/local/bin/X

echo "已安装快捷命令: x / X"
echo "以后可直接使用:"
echo "  x"
echo "或"
echo "  X"
