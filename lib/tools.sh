#!/usr/bin/env bash

tools_menu() {
  echo "=============================="
  echo " 扩展工具箱"
  echo "=============================="
  echo "1) Snell（状态 / 安装 / 生成配置）"
  echo "2) Xray / Reality（状态 / 安装 / 生成配置）"
  echo "3) sing-box（状态 / 安装 / 生成配置）"
  echo "4) SOCKS5 代理（状态 / 安装 / 部署）"
  echo "5) Cloudflare Tunnel（状态 / 安装 / 快速开始）"
  echo "6) 扩展工具总览"
  echo "0) 返回"
  echo "=============================="
  while true; do
    read -rp "请选择: " t
    case "$t" in
      1)
        echo "--- Snell 菜单 ---"
        echo "1) 查看状态"
        echo "2) 安装 Snell"
        echo "3) 生成配置并启动"
        echo "4) 查看 Snell 服务状态"
        echo "0) 返回"
        read -rp "请选择: " s
        case "$s" in
          1) snell_status ;;
          2) install_snell ;;
          3) generate_snell_config ;;
          4) show_snell_service ;;
          *) ;;
        esac
        return ;;
      2)
        echo "--- Xray / Reality 菜单 ---"
        echo "1) 查看状态"
        echo "2) 安装 Xray"
        echo "3) 生成 Reality 配置并启动"
        echo "4) 查看 Xray 服务状态"
        echo "0) 返回"
        read -rp "请选择: " s
        case "$s" in
          1) xray_status ;;
          2) install_xray ;;
          3) generate_xray_reality_config ;;
          4) show_xray_service ;;
          *) ;;
        esac
        return ;;
      3)
        echo "--- sing-box 菜单 ---"
        echo "1) 查看状态"
        echo "2) 安装 sing-box"
        echo "3) 生成 SOCKS 配置并启动"
        echo "4) 查看 sing-box 服务状态"
        echo "0) 返回"
        read -rp "请选择: " s
        case "$s" in
          1) singbox_status ;;
          2) install_singbox ;;
          3) generate_singbox_socks_config ;;
          4) show_singbox_service ;;
          *) ;;
        esac
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
