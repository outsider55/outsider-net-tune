# outsider-net-tune

> **v0.8.0**  
> 多功能 VPS 网络优化与工具脚本

`outsider-net-tune` 是一个面向 VPS / 独服场景的综合脚本工具，目标是把常见的：

- BBR / TCP 优化
- DNS 与 IPv4 / IPv6 策略调整
- 网络诊断
- 配置备份与回滚
- 直连 / 落地 / 中转模式优化
- 代理与隧道类扩展工具

整合到一个**更适合长期维护、安装简单、交付清晰**的项目里。

---

## 这个项目适合谁

适合这些用户：

- 想给 VPS 做网络优化的人
- 有直连 / 落地 / 中转场景的人
- 想要“一键优化”而不是手动改一堆 sysctl 的人
- 想把 SOCKS5 / Xray / sing-box / Cloudflare Tunnel 也整合进同一套工具链的人

---

## 当前已经具备的能力

### 核心优化
- 查看 / 启用 BBR
- 预览 / 应用 sysctl 优化参数
- IPv4 / IPv6 优先级切换
- 国外 DNS / 国内 DNS / 恢复默认 DNS
- 网络与系统诊断
- 配置备份、备份列表、回滚

### 场景模式
- 直连模式
- 落地模式
- 中转 / Realm 模式
- 一键自动优化（自动备份 + 尝试启用 BBR + 自动选模板 + 结果摘要）

### 扩展工具箱
- SOCKS5（microsocks）安装 / 部署
- Cloudflare Tunnel 安装 / 快速开始
- Xray 安装 / Reality 配置生成
- sing-box 安装 / SOCKS 配置生成
- Snell 安装与配置入口（仍在继续打磨）

### 项目体验
- `help` 帮助命令
- `selfcheck` 项目自检
- `update` 更新入口
- 在线安装脚本
- 快捷命令 `x` / `X`

---

## 安装方式

### 在线一键安装（推荐）
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/outsider55/outsider-net-tune/main/bootstrap.sh)
```

安装完成后可直接运行：
```bash
x
# 或
X
```

如果你想手动运行主脚本：
```bash
bash ~/.outsider-net-tune/app/main.sh
```

---

## 快速上手

### 查看帮助
```bash
x help
```

### 进入菜单
```bash
x
```

### 查看 BBR 状态
```bash
x bbr status
```

### 尝试启用 BBR
```bash
x bbr enable
```

### 一键自动优化
```bash
x mode auto
```

### 查看 DNS 状态
```bash
x dns status
```

### 查看备份列表
```bash
x backups
```

### 打开扩展工具箱
```bash
x tools
```

---

## 当前项目结构

```bash
outsider-net-tune/
├── README.md
├── VERSION
├── bootstrap.sh
├── install.sh
├── install-alias.sh
├── main.sh
├── lib/
├── templates/
└── docs/
```

---

## 当前设计原则

1. 修改前先备份
2. 尽量支持回滚
3. 模块化设计，不把所有逻辑堆进一个文件
4. 核心优化与扩展工具分层管理
5. 优先让安装、使用、交付更顺手

---

## 当前状态说明

这个项目已经不再是单纯骨架，已经进入：

**可安装、可使用、可继续扩展的交付阶段**。

但它仍然在持续打磨中，重点会继续放在：
- Snell 稳定性
- 代理配置体验
- 一键优化体验
- 文档和交付体验

---

## 仓库地址

GitHub：

**https://github.com/outsider55/outsider-net-tune**
