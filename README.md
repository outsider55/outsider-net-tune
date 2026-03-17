# outsider-net-tune

一个面向 VPS / 独服的**多功能网络优化与工具脚本**。

它的目标不是只做 BBR，也不是做一个难以维护的超大脚本，
而是把常见的：
- BBR / TCP 优化
- IPv4 / IPv6 策略
- DNS 调整
- 备份 / 回滚
- 网络诊断
- 场景化优化
- 扩展工具入口

整理成一个更适合长期维护的原创项目。

---

## 当前定位

`outsider-net-tune` 是一个：

**多功能 VPS 网络优化与工具脚本平台**

---

## 已实现模块

### 1. 内核 / BBR 管理
- 查看 BBR 状态
- 尝试启用 BBR

### 2. TCP / 网络优化
- 预览优化参数
- 应用优化参数

### 3. DNS / IPv4 / IPv6 策略
- IPv4 优先
- IPv6 / 默认优先
- 国外 DNS 模式
- 国内 DNS 模式
- 恢复默认 DNS
- 查看 DNS 状态

### 4. 系统与网络诊断
- 系统信息
- 出口 IP
- DNS
- 当前 TCP 关键参数

### 5. 备份与回滚
- 修改前备份
- 查看备份列表
- 最近备份回滚

### 6. 场景优化模式
- 直连模式
- 落地模式
- 中转 / Realm 模式
- 一键自动优化

### 7. 扩展工具箱
- Snell（预留）
- Xray / Reality（预留）
- sing-box（预留）
- SOCKS5（预留）
- Tunnel / 反代（预留）
- AI 工具（预留）

---

## 当前用法

### 菜单模式
```bash
bash main.sh
```

### 命令模式
```bash
bash main.sh diagnose
bash main.sh bbr status
bash main.sh bbr enable
bash main.sh sysctl preview
bash main.sh sysctl apply
bash main.sh dns abroad
bash main.sh dns cn
bash main.sh dns restore
bash main.sh backups
bash main.sh rollback
bash main.sh mode auto
```

---

## 在线一键安装
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/outsider55/outsider-net-tune/main/bootstrap.sh)
```

安装后运行：
```bash
bash ~/.outsider-net-tune/app/main.sh
```

## 快捷别名安装
```bash
bash install-alias.sh
source ~/.bashrc
ont
```

---

## 设计原则
1. 先备份，再修改
2. 尽量支持回滚
3. 模块化，不把所有逻辑堆进一个文件
4. 优先做真正常用的能力
5. 核心优化与扩展工具分层管理
