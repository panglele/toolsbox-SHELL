# ToolsBox Shell 工具箱

![Bash Version](https://img.shields.io/badge/Bash-5.0%2B-blue) ![Platform](https://img.shields.io/badge/Platform-CentOS%207-lightgrey) ![License](https://img.shields.io/badge/License-GPL3.0-green)

一个基于Bash的系统管理工具箱，集成常用功能，支持界面美化与快捷操作。

📧 作者邮箱：956143827@qq.com  
🐱 GitHub仓库：[https://github.com/panglele/toolsbox-SHELL](https://github.com/panglele/toolsbox-SHELL)

---

## 🌟 功能特性

### 系统功能
- 查看硬件信息（CPU/内存/磁盘/网络）
- IP地址固定配置
- YUM源快速切换（支持阿里云镜像）
- 系统时间校准
- 一键安装工具箱到系统命令

### 网络管理
- 网络接口状态可视化
- 路由表美化输出
- 网段计算器
- 域名/IP连通性测试

### 用户管理
- 用户/组增删改查
- 密码策略管理
- 用户权限组配置
- 用户信息表格化展示

### 安全管理
- 防火墙端口管理
- SELinux模式切换
- 防火墙状态控制

### 进程管理
- 进程实时监控（支持htop）
- 进程搜索与终止
- 资源占用可视化

### 扩展功能
- ASCII艺术界面
- 进度条动画
- 颜色代码支持
- 错误处理机制

---

## 🛠️ 安装与使用

### 环境要求
- 操作系统：CentOS 7.x（其他Linux发行版需测试）
- 权限要求：Root用户
- 依赖文件：
  - `style.sh`（颜色配置）
  - `speed-bar.sh`（进度条动画）
  - `userrule.awk`/`grouprule.awk`（用户组格式化）

### 快速安装
```bash
git clone https://github.com/yourname/toolsbox-SHELL.git
cd toolsbox-SHELL
chmod +x menu.sh
sudo ./menu.sh  # 需要root权限
```
### 开发参考
- 千峰刘杰老师：get-os-info.sh
- CSDN: M乔木：QiaoMuOS-24-3-25.sh
    url:https://blog.csdn.net/qiaomuv/article/details/135323900?fromshare=blogdetail&sharetype=blogdetail&sharerId=135323900&sharerefer=PC&sharesource=PeiDongQing&sharefrom=from_link
