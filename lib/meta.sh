#!/usr/bin/env bash

ROOT_DIR="${BASE_DIR:-$(cd -- "$(dirname -- "$0")/.." && pwd)}"
VERSION_FILE="$ROOT_DIR/VERSION"
PROJECT_VERSION="$(cat "$VERSION_FILE" 2>/dev/null || echo '0.0.0')"

show_banner() {
  echo "========================================"
  echo " outsider-net-tune v${PROJECT_VERSION}"
  echo " 多功能 VPS 网络优化与工具脚本"
  echo "========================================"
}

show_help() {
  cat <<EOF
outsider-net-tune v${PROJECT_VERSION}

用法：
  bash main.sh                # 菜单模式
  bash main.sh diagnose       # 网络诊断
  bash main.sh bbr status     # 查看 BBR 状态
  bash main.sh bbr enable     # 尝试启用 BBR
  bash main.sh sysctl preview # 预览优化参数
  bash main.sh sysctl apply   # 应用优化参数
  bash main.sh dns status     # 查看 DNS 状态
  bash main.sh status         # 查看状态总览
  bash main.sh mode auto      # 一键自动优化
  bash main.sh backups        # 查看备份列表
  bash main.sh rollback       # 回滚最近备份
  bash main.sh tools          # 扩展工具箱
  bash main.sh selfcheck      # 项目自检
  bash main.sh update         # 更新项目（预留）
EOF
}

selfcheck() {
  echo "=== 自检开始 ==="
  local missing=0
  for f in "$ROOT_DIR/README.md" "$ROOT_DIR/main.sh" "$ROOT_DIR/install.sh" "$ROOT_DIR/install-alias.sh"; do
    if [[ -f "$f" ]]; then
      echo "OK  $(basename "$f")"
    else
      echo "MISS $(basename "$f")"
      missing=1
    fi
  done
  for d in lib templates docs; do
    if [[ -d "$ROOT_DIR/$d" ]]; then
      echo "OK  $d/"
    else
      echo "MISS $d/"
      missing=1
    fi
  done
  if [[ $missing -eq 0 ]]; then
    echo "自检通过"
  else
    echo "自检存在缺项"
    return 1
  fi
}

update_project() {
  local install_base target bootstrap_url
  install_base="${INSTALL_BASE:-$HOME/.outsider-net-tune}"
  target="$install_base/app"
  bootstrap_url="https://raw.githubusercontent.com/outsider55/outsider-net-tune/main/bootstrap.sh"

  if [[ -d "$target" ]]; then
    echo "开始更新 outsider-net-tune ..."
    bash <(curl -fsSL "$bootstrap_url")
    echo "更新完成"
  else
    echo "未检测到安装目录，改为首次安装"
    bash <(curl -fsSL "$bootstrap_url")
  fi
}
