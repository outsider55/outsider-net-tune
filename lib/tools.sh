#!/usr/bin/env bash

tools_menu() {
  echo "=============================="
  echo " 扩展工具箱"
  echo "=============================="
  echo "1) Snell 状态 / 部署入口"
  echo "2) Xray / Reality 状态入口"
  echo "3) sing-box 状态入口"
  echo "4) SOCKS5 代理（状态 / 安装 / 部署）"
  echo "5) Cloudflare Tunnel（状态 / 安装 / 快速开始）"
  echo "6) 扩展工具总览"
  echo "0) 返回"
  echo "=============================="
  while true; do
    read -rp "请选择: " t
    case "$t" in
      1)
        snell_status
        echo
        read -rp "是否尝试安装 Snell? [y/N] " c
        [[ "$c" =~ ^[Yy]$ ]] && install_snell_placeholder
        return ;;
      2)
        xray_status
        echo
        read -rp "是否尝试安装 Xray? [y/N] " c
        [[ "$c" =~ ^[Yy]$ ]] && install_xray_placeholder
        return ;;
      3)
        singbox_status
        echo
        read -rp "是否尝试安装 sing-box? [y/N] " c
        [[ "$c" =~ ^[Yy]$ ]] && install_singbox_placeholder
        return ;;
      4)
        echo "--- SOCKS5 菜单 ---"
        echo "1) 查看环境状态"
        echo "2) 安装 microsocks"
        echo "3) 一键部署 SOCKS5"
        echo "4) 查看 SOCKS5 服务状态"
        echo "0) 返回"
        read -rp "请选择: " s
        case "$s" in
          1) socks5_status ;;
          2) install_microsocks ;;
          3) deploy_microsocks ;;
          4) show_microsocks_service ;;
          *) ;;
        esac
        return ;;
      5)
        echo "--- Cloudflare Tunnel 菜单 ---"
        echo "1) 查看状态"
        echo "2) 安装 cloudflared"
        echo "3) 查看快速开始"
        echo "0) 返回"
        read -rp "请选择: " s
        case "$s" in
          1) show_cloudflared_status ;;
          2) install_cloudflared ;;
          3) cloudflared_quickstart ;;
          *) ;;
        esac
        return ;;
      6) proxy_tools_overview; return ;;
      0) return 0 ;;
      *) echo "无效选择" ;;
    esac
  done
}
