#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
chmod +x "$SCRIPT_DIR/main.sh"
find "$SCRIPT_DIR/lib" -type f -name '*.sh' -exec chmod +x {} +

cat <<'EOF'
outsider-net-tune 已初始化。

推荐使用：
  bash main.sh

也可以安装快捷别名 X：
  bash install-alias.sh
  source ~/.bashrc
  X
EOF
