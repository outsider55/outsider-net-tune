#!/usr/bin/env bash
set -euo pipefail

# 用于后续发布时快速检查项目是否具备交付条件
BASE_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
cd "$BASE_DIR"

echo '=== outsider-net-tune release check ==='
for f in README.md install.sh install-alias.sh main.sh docs/deploy.md; do
  [[ -f "$f" ]] && echo "OK  $f" || { echo "MISS $f"; exit 1; }
done

echo
echo '可执行脚本：'
find . -maxdepth 2 -type f \( -name '*.sh' \) -print | sort

echo
echo 'release check 完成'
