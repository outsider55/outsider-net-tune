#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
source "$BASE_DIR/lib/common.sh"
source "$BASE_DIR/lib/meta.sh"
source "$BASE_DIR/lib/bbr.sh"
source "$BASE_DIR/lib/sysctl.sh"
source "$BASE_DIR/lib/ipv46.sh"
source "$BASE_DIR/lib/dns.sh"
source "$BASE_DIR/lib/diagnose.sh"
source "$BASE_DIR/lib/modes.sh"
source "$BASE_DIR/lib/proxy_tools.sh"
source "$BASE_DIR/lib/installers.sh"
source "$BASE_DIR/lib/tools.sh"

show_menu() {
  clear 2>/dev/null || true
  show_banner
  echo " 1) 内核 / BBR 管理"
  echo " 2) TCP / 网络优化"
  echo " 3) DNS / IPv4 / IPv6 策略"
  echo " 4) 系统与网络诊断"
  echo " 5) 备份与回滚"
  echo " 6) 场景优化模式"
  echo " 7) 扩展工具箱"
  echo " 8) 项目帮助 / 自检 / 更新"
  echo "66) 一键自动优化"
  echo " 0) 退出"
  echo "========================================"
}

menu_bbr() {
  clear 2>/dev/null || true
  echo "--- 内核 / BBR 管理 ---"
  echo "1) 查看 BBR 状态"
  echo "2) 尝试启用 BBR"
  echo "0) 返回"
  while true; do
    read -rp "请选择: " c
    case "$c" in
      1) bbr_status; pause_continue; return ;;
      2) bbr_enable; pause_continue; return ;;
      0) return ;;
      *) echo "无效选择" ;;
    esac
  done
}

menu_net() {
  clear 2>/dev/null || true
  echo "--- TCP / 网络优化 ---"
  echo "1) 预览优化参数"
  echo "2) 应用默认优化参数"
  echo "0) 返回"
  while true; do
    read -rp "请选择: " c
    case "$c" in
      1) sysctl_preview; pause_continue; return ;;
      2) sysctl_apply; pause_continue; return ;;
      0) return ;;
      *) echo "无效选择" ;;
    esac
  done
}

menu_ip() {
  clear 2>/dev/null || true
  echo "--- DNS / IPv4 / IPv6 策略 ---"
  echo "1) IPv4 优先"
  echo "2) IPv6 / 默认优先"
  echo "3) 国外 DNS 模式"
  echo "4) 国内 DNS 模式"
  echo "5) 恢复默认 DNS"
  echo "6) 查看当前 DNS 状态"
  echo "0) 返回"
  while true; do
    read -rp "请选择: " c
    case "$c" in
      1) ipv4_prefer; pause_continue; return ;;
      2) ipv6_prefer; pause_continue; return ;;
      3) apply_dns_mode abroad; pause_continue; return ;;
      4) apply_dns_mode cn; pause_continue; return ;;
      5) apply_dns_mode restore; pause_continue; return ;;
      6) show_dns_status; pause_continue; return ;;
      0) return ;;
      *) echo "无效选择" ;;
    esac
  done
}

menu_diag() {
  clear 2>/dev/null || true
  diagnose_all
  pause_continue
}

menu_backup() {
  clear 2>/dev/null || true
  echo "--- 备份与回滚 ---"
  echo "1) 立即备份"
  echo "2) 查看备份列表"
  echo "3) 回滚到最近备份"
  echo "0) 返回"
  while true; do
    read -rp "请选择: " c
    case "$c" in
      1) backup_configs; pause_continue; return ;;
      2) list_backups; pause_continue; return ;;
      3) rollback_configs; pause_continue; return ;;
      0) return ;;
      *) echo "无效选择" ;;
    esac
  done
}

menu_modes() {
  clear 2>/dev/null || true
  echo "--- 场景优化模式 ---"
  echo "1) 直连模式"
  echo "2) 落地模式"
  echo "3) 中转 / Realm 模式"
  echo "4) 一键自动优化"
  echo "0) 返回"
  while true; do
    read -rp "请选择: " c
    case "$c" in
      1) mode_direct; pause_continue; return ;;
      2) mode_landing; pause_continue; return ;;
      3) mode_relay; pause_continue; return ;;
      4) mode_auto_all; pause_continue; return ;;
      0) return ;;
      *) echo "无效选择" ;;
    esac
  done
}

menu_project() {
  clear 2>/dev/null || true
  echo "--- 项目帮助 / 自检 / 更新 ---"
  echo "1) 查看帮助"
  echo "2) 项目自检"
  echo "3) 更新项目（预留）"
  echo "0) 返回"
  while true; do
    read -rp "请选择: " c
    case "$c" in
      1) show_help; pause_continue; return ;;
      2) selfcheck; pause_continue; return ;;
      3) update_project; pause_continue; return ;;
      0) return ;;
      *) echo "无效选择" ;;
    esac
  done
}

handle_menu() {
  while true; do
    show_menu
    read -rp "请选择: " choice
    case "$choice" in
      1) menu_bbr ;;
      2) menu_net ;;
      3) menu_ip ;;
      4) menu_diag ;;
      5) menu_backup ;;
      6) menu_modes ;;
      7) tools_menu; pause_continue ;;
      8) menu_project ;;
      66) clear 2>/dev/null || true; mode_auto_all; pause_continue ;;
      0) exit 0 ;;
      *) echo "无效选择" ;;
    esac
  done
}

cmd="${1:-menu}"
sub="${2:-}"

case "$cmd" in
  menu) handle_menu ;;
  diagnose) diagnose_all ;;
  help|-h|--help) show_help ;;
  selfcheck) selfcheck ;;
  update) update_project ;;
  backup) backup_configs ;;
  backups) list_backups ;;
  rollback) rollback_configs "${2:-}" ;;
  bbr)
    case "$sub" in
      enable) bbr_enable ;;
      status|"") bbr_status ;;
      *) echo "未知 bbr 子命令: $sub"; exit 1 ;;
    esac ;;
  ipv4) ipv4_prefer ;;
  ipv6) ipv6_prefer ;;
  dns)
    case "$sub" in
      abroad|cn|restore) apply_dns_mode "$sub" ;;
      status|"") show_dns_status ;;
      *) echo "未知 dns 子命令: $sub"; exit 1 ;;
    esac ;;
  sysctl)
    case "$sub" in
      preview|"") sysctl_preview ;;
      apply) sysctl_apply ;;
      *) echo "未知 sysctl 子命令: $sub"; exit 1 ;;
    esac ;;
  mode)
    case "$sub" in
      direct) mode_direct ;;
      landing) mode_landing ;;
      relay) mode_relay ;;
      auto) mode_auto_all ;;
      *) echo "未知 mode 子命令: $sub"; exit 1 ;;
    esac ;;
  tools) tools_menu ;;
  *) echo "未知命令: $cmd"; exit 1 ;;
esac
