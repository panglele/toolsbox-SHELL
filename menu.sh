#!/bin/bash
#——————————————————————————————————————#
#    Author:        pangle
#    Date:          2025-05-21
#    FileName       menu.sh
#——————————————————————————————————————#
path=$(cd `dirname $0`;pwd)
source $path/style.sh       # 配置path路径可让不在当前目录执行脚本也可成功
source $path/speed-bar.sh
CommandName="工具箱"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━检查脚本运行用户━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ #
if [ $UID -ne 0 ];then
    error ${CommandName} 不是root用户,无法运行脚本
    exit 1
fi
    clear
    cat << EOF | sed "s/[╔═╗║╠╣╚╝]/${cyan}&${reset}/g"  | sed "s/^ *\[.....\]/${red}&${reset}/g"

    ████████╗ ██████╗  ██████╗ ██╗     ███████╗    ██████╗  ██████╗ ██╗  ██╗
    ╚══██╔══╝██╔═══██╗██╔═══██╗██║     ██╔════╝    ██╔══██╗██╔═══██╗╚██╗██╔╝
       ██║   ██║   ██║██║   ██║██║     ███████╗    ██████╔╝██║   ██║ ╚███╔╝ 
       ██║   ██║   ██║██║   ██║██║     ╚════██║    ██╔══██╗██║   ██║ ██╔██╗ 
       ██║   ╚██████╔╝╚██████╔╝███████╗███████║    ██████╔╝╚██████╔╝██╔╝ ██╗
       ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚══════╝    ╚═════╝  ╚═════╝ ╚═╝  ╚═╝

        [ 作 者 ] : 庞 乐
        [ 邮 箱 ] : 956143827@qq.com
        [ 提 示 ] : 开发于CentOS-7系统,部分功能非全版本适用,请自行测试
        [ 示 例 ] : 功能执行完毕 使用回车退至上级菜单

EOF
    tip 回车进入
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━退出功能━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ #
function Quit(){
    clear
    cat << EOF | sed "s/[═◉]/${cyan}&${reset}/g"
    ◉═════════════════════◉
        感谢使用 ${CommandName}
    ◉═════════════════════◉
EOF
    exit 0
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━系统功能菜单━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ #
# ───────────────────────1.查看系统信息───────────────────────── #
function GetSystemInfo(){
    echo "正在获取当前主机系统信息"
        speedbar 2
    # ──────CPU信息──────
    cpu_model=$(grep "model name" /proc/cpuinfo |awk -F ": " '{print $2}'|uniq)      # cpu型号
    cpu_cores=$(grep processor /proc/cpuinfo |wc -l)            # cpu核心数
    cpu_frequency=$(grep "cpu MHz" /proc/cpuinfo |awk -F ": " '{print $2}'|uniq)     # cpu主频
    cpu_cache=$(grep "cache size" /proc/cpuinfo |awk -F ": " '{print $2}'|uniq)      # cpu缓存
    printf "   \e[32m%-10s\e[0m\n" "[中央处理器信息]" 
    print_long_line
    printf "\e[38;2;47;74;119m   %-12s\e[0m\t│\e[38;2;182;154;49m %-50s\e[0m\n" "CPU型号" "${cpu_model}"
    printf "\e[38;2;47;74;119m   %-12s\e[0m\t│\e[38;2;182;154;49m %-50s\e[0m\n" "CPU核心数" "${cpu_cores} 核"
    printf "\e[38;2;47;74;119m   %-12s\e[0m\t│\e[38;2;182;154;49m %-50s\e[0m\n" "cpu主频" "${cpu_frequency} MHz"
    printf "\e[38;2;47;74;119m   %-12s\e[0m\t│\e[38;2;182;154;49m %-50s\e[0m\n" "cpu缓存" "${cpu_cache}"
    printf "\n"
    # ──────内存信息──────
    mem_size=$(grep "MemTotal" /proc/meminfo | awk -F " " '{print $2}')     # 内存总量
    mem_free=$(grep "MemFree" /proc/meminfo |awk -F " " '{print $2}')       # 内存余量
    mem_frequency=$(dmidecode |grep "Max Speed"|awk -F ": " '{print $2}'|uniq)  # 内存频率
    printf "   \e[32m%-10s\e[0m\n" "[内存信息]" 
    print_long_line
    printf "\e[38;2;47;74;119m   %-12s\e[0m\t│\e[38;2;182;154;49m %-50s\e[0m\n" "内存总量" "$[$mem_size/1024] MB"
    printf "\e[38;2;47;74;119m   %-12s\e[0m\t│\e[38;2;182;154;49m %-50s\e[0m\n" "内存剩余" "$[$mem_free/1024] MB"
    printf "\e[38;2;47;74;119m   %-12s\e[0m\t│\e[38;2;182;154;49m %-50s\e[0m\n" "内存频率" "${mem_frequency}"
    printf "\n"
    # ──────主机信息──────
    os_version=$(hostnamectl | grep "Operating System"|awk -F ": " '{print $2}')    # 系统版本
    os_kernel=$(hostnamectl | grep "Kernel"|awk -F ": " '{print $2}')       # 内核版本
    hostname=$(hostnamectl | grep "Static hostname"|awk -F ": " '{print $2}')   # 静态主机名
    printf "   \e[32m%-10s\e[0m\n" "[主机信息]"
    print_long_line
    printf "\e[38;2;47;74;119m   %-12s\e[0m\t│\e[38;2;182;154;49m %-50s\e[0m\n" "系统版本" "$os_version"
    printf "\e[38;2;47;74;119m   %-12s\e[0m\t│\e[38;2;182;154;49m %-50s\e[0m\n" "内核版本" "$os_kernel"
    printf "\e[38;2;47;74;119m   %-12s\e[0m\t│\e[38;2;182;154;49m %-50s\e[0m\n" "静态主机名" "$hostname"
    printf "\n"
    # ──────网络信息──────
    network_card=$(ip a | grep '2: '| awk '{print $2}' |tr -d ":") # 首张网卡名
    ip=$(ip a show dev ${network_card}| grep 'inet ' | awk '{print $2}')    # 网卡ip
    gateway=$(ip route | grep default | awk '{print $3}')     #网关
    printf "   \e[32m%-10s\e[0m\n" "[网络信息]"
    print_long_line
    printf "\e[38;2;47;74;119m   %-12s\e[0m\t│\e[38;2;182;154;49m %-50s\e[0m\n" "网卡名" "$network_card"
    printf "\e[38;2;47;74;119m   %-12s\e[0m\t│\e[38;2;182;154;49m %-50s\e[0m\n" "IP地址" "$ip"
    printf "\e[38;2;47;74;119m   %-12s\e[0m\t│\e[38;2;182;154;49m %-50s\e[0m\n" "网关" "$gateway"
    printf "\n"
    # ──────磁盘信息──────
    printf "   \e[32m%-10s\e[0m\n" "[磁盘信息]"
    print_long_line
    printf "\e[38;2;47;74;119m   %-13s│  %-8s │ %-30s│ %-5s\e[0m\n" "[挂载点]" "[已用]" "[文件系统]" "[容量]"
    df -Th | awk 'BEGIN{ORS="\n"}$2 ~ /(ext|xfs)/{printf "\033[38;2;182;154;49m   %-10s│  %-7s│ %-26s│ %-5s\033[0m\n",$NF,$(NF-1),$1,$3}'
    printf "\n"
}
# ───────────────────────2.系统功能设置───────────────────────── #
# ---------------固定IP----------------- #
function FixedIP(){
    infoecho 1 开始固定IP
        sleep 1
    infoecho 2 获取当前网卡配置文件
        sleep 1
        network_card=$(ip a | grep '2: '| awk '{print $2}' |tr -d ":") # 首张网卡名
    infoecho 3 获取IP
        ip=$(ip a show dev ${network_card}| grep 'inet ' | awk '{print $2}')    # 网卡ip
        speedbar 2
    myecho 4 原有的网卡配置文件获取成功,正在删除...
    tip ${CmdName} 是否开启DNS:[y/n] dnsname
    # 不开启则添加为注释行
    case $dnsname in
        y)
            dnsa=DNS1=114.114.114.114
            dnsb=DNS2=8.8.8.8
            ;;
        n)
            dnsa=#DNS1=114.114.114.114
            dnsb=#DNS2=8.8.8.8
        ;;
    esac
    infoecho 5 正在创建新的网卡配置文件
        speedbar 5
    cd /etc/sysconfig/network-scripts/
    # 写入网卡配置
    cat >ifcfg-$wkname <<EOF
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="none"
DEFROUTE="yes"
NAME="$wkname"
DEVICE="$wkname"
ONBOOT="yes"
IPADDR=$ipname
PREFIX=24
GATEWAY=$wgname
$dnsa
$dnsb
EOF
    cd - &> /dev/null
    myecho 6 创建成功,正在重启网络服务
        nmcli connection down ens33 &> /dev/null &&  nmcli connection up ens33  &> /dev/null
    myecho 7 固定IP成功
        sleep 3
}
# ---------------配置YUM源----------------- #
function ConfigYUM(){
        infoecho 1 正在检测网络状态
    if ! ping -W 1 -c 2 www.baidu.com &> /dev/null;then
        error ${CmdName} 网络连接失败,请检查网络!
    fi
        # 备份当前YUM源
        infoecho 2 正在备份当前YUM源
        sleep 1
        cd /etc/yum.repos.d/
        if tar -zcf repo-$(date +%Y-%m-%d_%H-%M-%S).tar.gz ./* --remove-files;then
            infoecho 3 当前YUM源备份成功 
            sleep 1
        else
            error ${CmdName} 当前YUM源备份失败
        fi
        cd - &> /dev/null
        # 配置阿里云YUM和epel
        infoecho 4 正在配置阿里云YUM源,受网络影响,请耐心等待
        sleep 1
        if curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo &> /dev/null && \
           curl -o /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo &> /dev/null;
        then
            yum makecache &>/dev/null
            myecho 5 阿里云YUM源配置成功!
        else
            error ${CmdName} 配置阿里云YUM源失败,请检查网络或其他配置
        fi
        read
}
# ---------------设置主机名----------------- #
function SetHostname(){
    infoecho 1 当前主机名:$(hostname)
    infoecho 2 开始修改主机名
    sleep 1
    tip ${CmdName} "请输入你想修改的主机名" namehost
    hostnamectl set-hostname $namehost
    myecho 3 主机名修改成功,已设置为:$(hostname)
    read
}
function SystemSettings(){
    CmdName="系统功能"
    while true
    do
        clear
        cat << EOF | sed "s/[═◉]/${cyan}&${reset}/g" | sed "s/\[[0-9a-z]\]/${red}&${reset}/g"
    ◉═════════════════════◉
          系统功能设置    
    ◉═════════════════════◉
        [1] 固定IP
        [2] 配置YUM源
        [3] 时间校准
        [4] 设置主机名
        [r] 返回主菜单
        [q] 退出
    ◉═════════════════════◉
EOF
        tip ${CmdName} 请输入功能序号 systemsettings
        case $systemsettings in
        1)  # 固定IP
            FixedIP
        ;;
        2)  # 配置阿里云YUM源
            ConfigYUM
        ;;
        3)  # 时间校准
            infoecho 1 开始校准时间
            yum -y install ntpdate &>/dev/null
            ntpdate ntp.ntsc.ac.cn &>/dev/null
            now=$(date)
            myecho 2 时间校准成功
            infoecho 3 "当前时间为:$now"
            sleep 2
            read
        ;;
        4)  # 设置主机名
            SetHostname
        ;;
        r)
            Menu
        ;;
        q)
            Quit
        ;;
        *)
            clear
                print_line
                warnning ${CmdName} 选项错误,稍后将重新运行
                print_line
            sleep 1
            SystemSettings
        esac
    done
}
# ───────────────────────3.安装至系统───────────────────────── #
function InstallToSystem(){
    # 系统路径与系统命令名
    CommandDir="/usr/local/bin/"
    CommandPath="/usr/local/bin/menu"
    # 检测系统中是否已安装
    if [ ! -f $CommandPath ];then
        tip $CommandName 是否安装到系统命令-y/n? ok
        if [ "${ok:="y"}" = "y" ];then
            echo -e "\e[43m\e[01;03;30m———————正在安装命令到系统———————\e[0m"
            speedbar 3
            # 复制脚本与依赖文件
            cp "$0"  "$CommandPath"
            cp "./userrule.awk" "$CommandDir/userrule.awk"
            cp "./grouprule.awk" "$CommandDir/grouprule.awk"
            cp "./style.sh" "$CommandDir/style.sh"
            cp "./speed-bar.sh" "$CommandDir/speed-bar.sh"
            chmod +x "$CommandPath"
            myecho 1 已安装至系统路径$CommandPath,可使用\<menu\>命令调用${CommandName}
            read
        fi
    else
        info ${CommandName} 当前系统已安装${CommandName}
        read
    fi
}
function SystemTools(){
    CmdName="系统功能"
    while true
    do
        clear
        cat << EOF | sed "s/[═◉]/${cyan}&${reset}/g" | sed "s/\[[0-9a-z]\]/${red}&${reset}/g"
    ◉═════════════════════◉
          系 统 功 能    
    ◉═════════════════════◉
        [1] 查看系统信息
        [2] 系统功能设置
        [3] 安装至系统
        [r] 返回主菜单
        [q] 退出  
    ◉═════════════════════◉
EOF
        tip ${CmdName} 请输入功能序号 systemtools
        case $systemtools in
        1)  # 查看系统信息
            clear
                GetSystemInfo
            read
        ;;
        2)  # 系统功能设置
            SystemSettings
        ;;
        3)  # 安装至系统
            InstallToSystem
        ;;
        r)
            Menu
        ;;
        q)
            Quit
        ;;
        *)
            clear
                print_line
                warnning ${CmdName} 选项错误,稍后将重新运行
                print_line
            sleep 1
            SystemTools
        esac
    done
}
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━网络管理━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ #
# ---------------计算网络地址----------------- #
network_address(){

    local ip=$1
    local netmask=$2
    # 分割IP为四个部分
    IFS=. read -r a b c d <<< "$ip"

    # 计算IP、子网掩码和网络地址的整数形式
    ip_num=$(( (a << 24) | (b << 16) | (c << 8) | d ))
    full_mask=$(( 0xFFFFFFFF ^ ((2**(32 - $netmask)) -1 )))
    network_num=$(( ip_num & full_mask ))

    # 转换为点分十进制
    o1=$(( (network_num >> 24) & 0xFF ))
    o2=$(( (network_num >> 16) & 0xFF ))
    o3=$(( (network_num >> 8)  & 0xFF ))
    o4=$(( network_num & 0xFF ))
    
    # 拼接为点分十进制格式
    NetAddress=$o1.$o2.$o3.$o4
}
# ───────────────────────网段计算器───────────────────────── #
function NetworkSegmentCalculator(){
    infoecho 1 开始计算网段
    sleep 1
    tip 2 请输入IPv4地址 ip
    tip 3 请输入对应子网掩码 netmask
    speedbar 3
    network_address ${ip} ${netmask}
    myecho 4 "${ip}/${netmask} 所在网段为 $NetAddress"
    read
}
function NetworkManagement(){
    CmdName="网络管理"
    while true
    do
        clear
        cat << EOF | sed "s/[═◉]/${cyan}&${reset}/g" | sed "s/\[[0-9irq]\]/${red}&${reset}/g"
    ◉═════════════════════◉
          网 络 管 理    
    ◉═════════════════════◉
        [1] 显示接口信息
        [2] 测试网络状态
        [3] 查看路由表
        [4] 网段计算器
        [r] 返回主菜单
        [q] 退出  
    ◉═════════════════════◉
EOF
        tip ${CmdName} 请输入功能序号 networkmanagement
        case $networkmanagement in
        1)  # 网络接口图表美化输出
            ip -br -c addr show | \
            awk 'BEGIN{printf "|\033[36m %-9s\033[0m|\033[36m %-7s\033[0m|\033[36m %-20s\033[0m|\n","接口","状态","IP"} \
            {printf "  %-11s\033[0m| %-10s\t\033[0m| %-32s\t\n",$1,$2,$3 }'
            read
        ;;
        2)  # 域名或IP测试
            tip 1 "请输入要测试的IP/域名" target
            if [[ "$target" =~ ^[a-zA-Z0-9.-]+$ ]];then
                infoecho 2 "正在测试连通性...(Ctrl+C 停止)"
                ping -c 2 -W 1 "$target" |head -1 |awk 'BEGIN{printf "[3] "}NR==1 {print}'
                ping -c 2 -W 1 "$target" |tail -2 |awk 'BEGIN{printf "[4] "}NR==1 {print}';
            else
                error 3 "错误:无效的地址格式!"
            fi
            myecho 5 测试完成
            read
        ;;
        3)  # 路由表图表美化输出
            route -n | tail -n +3 | \
            awk 'BEGIN {printf "|\033[32m %-12s\033[0m|\033[32m %-14s\033[0m|\033[32m %-12s\033[0m|\033[32m %-6s\033[0m|\n","目标主机","网关","子网掩码","接口"} \
            {printf "|\033[38;2;63;141;144m %-16s\033[0m|\033[38;2;92;146;42m %-16s\033[0m|\033[38;2;182;154;49m %-16s\033[0m|\033[38;2;47;74;119m %-8s\033[0m|\n",\
            $1,$2,$3,$NF}'
            read
        ;;
        4)  # 网段计算器
            NetworkSegmentCalculator
        ;;
        r)
            Menu
        ;;
        q)
            Quit
        ;;
        *)
            clear
                print_line
                warnning ${CmdName} 选项错误,稍后将重新运行
                print_line
            sleep 1
            NetworkManagement
        esac
    done
}
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━用户管理━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ #
# ───────────────────────新建用户───────────────────────── #
function CreateUser(){
    infoecho 1 正在新建用户
    sleep 1
    tip 2 请输入用户名 username
    sleep 1
    # 检测用户是否存在
    if id "$username" &>/dev/null; then
        error ${CmdName} 用户${username}已存在
    fi
    if useradd -m $username 2>/dev/null ;then
        myecho 3 用户${username}创建成功
        tip 4 "是否为${username}设置密码(y/n)" setpasswd
        if [ ${setpasswd:="n"} = "y" ];then
            passwd "$username" 
        fi
    fi
    sleep 1
    myecho 5 用户${username}创建成功
    read
    UserManagement
}
# ───────────────────────删除用户───────────────────────── #
function DeleteUser(){
    infoecho 1 正在删除用户
    sleep 1
    # 检测用户是否存在
    tip 2 请输入用户名 username
    if ! id "$username" &>/dev/null; then
        error ${CmdName} 用户${username}不存在
    fi
    tip 3 "是否删除用户${username}家目录和邮件(y/n)" delhome
    if [ ${delhome:="y"} = "y" ];then
        infoecho 4 正在删除用户${username}和家目录
        sleep 1
        userdel -r "$username"
    else
        infoecho 4 正在删除用户${username}
        sleep 1
        userdel "$username"
    fi
    myecho 5 删除用户${username}成功
    read
    UserManagement
}
# ───────────────────────修改密码───────────────────────── #
function ChangePassword(){
    infoecho 1 正在修改用户密码
    sleep 1
    tip 2 请输入用户名 username
    sleep 1
    if id "$username" &>/dev/null; then
        passwd "$username"
    else
        error ${CmdName} 用户${username}不存在
    fi
    myecho 3 用户${username}密码修改成功
    read
    UserManagement
}
# ───────────────────────用户组配置───────────────────────── #
# ---------------创建用户组----------------- #
function CreateGroup(){
    infoecho 1 正在创建用户组
    sleep 1
    tip 2 请输入用户组名 groupname
    sleep 1
    if groupadd "$groupname" 2>/dev/null; then
        myecho 3 用户组${groupname}创建成功
    else
        error ${CmdName} ${groupname}组已存在
    fi
    read
    GroupSettings
}
# ---------------删除用户组----------------- #
function DeleteGroup(){
    infoecho 1 正在删除用户组
    sleep 1
    tip 2 请输入用户组名 groupname
    sleep 1
    if groupdel "$groupname" 2>/dev/null; then
        myecho 3 用户组${groupname}已删除
    else
        error ${CmdName} ${groupname}组不存在或存在用户依赖
    fi
    read
    GroupSettings
}
# ---------------添加组用户----------------- #
function AddGroupUser(){
    infoecho 1 正在添加组用户
    sleep 1
    tip 2 请输入用户名 username
    tip 3 请输入用户组名 groupname
    sleep 1
    if usermod -aG "$groupname" "$username" 2>/dev/null; then
        myecho 4 "用户${username}已添加到组${groupname}"
    else
        error ${CmdName} 用户或组不存在
    fi
    read
    GroupSettings
}
# ---------------移除组用户----------------- #
function RemoveGroupUsers(){
    infoecho 1 正在移除组用户
    sleep 1
    tip 2 请输入用户名 username
    tip 3 请输入用户组名 groupname
    sleep 1
    if gpasswd -d "$username" "$groupname" 2>/dev/null; then
        myecho 4 "用户${username}已从组${groupname}移除"
    else
        error ${CmdName} 操作失败,请检查输入
    fi
    read
    GroupSettings
}
function GroupSettings(){
    while true
    do
        clear
        cat << EOF | sed "s/[═◉]/${cyan}&${reset}/g" | sed "s/\[[0-9a-z]\]/${red}&${reset}/g"
    ◉═════════════════════◉
         用 户 组 管 理    
    ◉═════════════════════◉
        [1] 创建用户组
        [2] 删除用户组
        [3] 添加组用户
        [4] 移除组用户
        [5] 查看普通组
        [r] 返回主菜单
        [q] 退出
    ◉═════════════════════◉
EOF
        tip ${CmdName} 请输入功能序号 groupsettings
        case $groupsettings in
        1)  # 创建用户组
            CreateGroup
        ;;
        2)  # 删除用户组
            DeleteGroup
        ;;
        3)  # 添加组用户
            AddGroupUser
        ;;
        4)  # 移除组用户
            RemoveGroupUsers
        ;;
        5)  # 普通组图表美化输出
            clear
            awk -f grouprule.awk /etc/group
            read
        ;;
        r)
            Menu
        ;;
        q)
            Quit
        ;;
        *)
            clear
                print_line
                warnning ${CmdName} 选项错误,稍后将重新运行
                print_line
            sleep 1
            GroupSettings
        esac
    done
}
function UserManagement(){
    CmdName="用户管理"
    while true
    do
        clear
        cat << EOF | sed "s/[═◉]/${cyan}&${reset}/g" | sed "s/\[[0-9a-z]\]/${red}&${reset}/g"
    ◉═════════════════════◉
          用 户 管 理    
    ◉═════════════════════◉
        [1] 查看用户
        [2] 新建用户
        [3] 删除用户
        [4] 修改密码
        [5] 用户组配置
        [r] 返回主菜单
        [q] 退出
    ◉═════════════════════◉
EOF
        tip ${CmdName} 请输入功能序号 usermanagement
        case $usermanagement in
        1)  # 查看用户图表美化输出
            tip 1 "请选择查看用户身份类型(1.系统用户 2.普通用户)" userchoice
            if [ $userchoice -eq 1 ];then
                clear
                sort -t ':' -k 3 -n /etc/passwd | awk -v opt=1 -f userrule.awk
                read
            elif [ $userchoice -eq 2 ];then
                clear
                sort -t ':' -k 3 -n /etc/passwd | awk -v opt=2 -f userrule.awk
                read
            else
                clear
                    print_line
                    warnning ${CmdName} 选项错误,稍后将重新运行
                    print_line
                sleep 1
            fi
        ;;
        2)  # 新建用户
            CreateUser
        ;;
        3)  # 删除用户
            DeleteUser
        ;;
        4)  # 修改密码
            ChangePassword
        ;;
        5)  # 用户组配置
            GroupSettings
        ;;
        r)
            Menu
        ;;
        q)
            Quit
        ;;
        *)
            clear
                print_line
                warnning ${CmdName} 选项错误,稍后将重新运行
                print_line
            sleep 1
            UserManagement
        esac
    done
}
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━安全管理━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ #
# ───────────────────────防火墙端口───────────────────────── #
function PortSettings(){
    # 检测防火墙状态
    if [ $(systemctl status firewalld|grep -oP 'Active: \K\w+') =  inactive ];then
        error $CmdName 防火墙未开启,请开启防火墙
        SafetyManagement
    else
        tip $CmdName 请输入要${2}的端口号 port
        if [ -n "$port" ];then
            speedbar 2
            # $1作为命令可选项,分别执行删除和添加
            firewall-cmd --zone=public --$1-port=$port/tcp --permanent  &> /dev/null
            firewall-cmd --reload &> /dev/null
            success $CmdName  $port端口${2}成功
            read
        else
            error $CmdName 请输入合理端口号
            PortSettings
        fi
    fi
}
# ───────────────────────防火墙状态───────────────────────── #
function FirewallSettings(){
    # 查看防火墙状态并用正则匹配关键信息
    state=$(systemctl status firewalld|grep -oP 'Active: \K\w+ \(\w+\)')
    infoecho 1 当前防火墙状态:"${state}"
    tip 2 "请选择防火墙状态(OPEN:o/CLOSE:c)" firewallsettings
    case $firewallsettings in
    o)  # 开启防火墙
        systemctl start firewalld.service
        myecho 3 防火墙已开启
        read
    ;;
    c)  # 关闭防火墙
        systemctl stop firewalld.service
        myecho 3 防火墙已关闭
        read
    ;;
    *)
        clear
            print_line
            warnning ${CmdName} 选项错误,稍后将重新运行
            print_line
        sleep 1
        FirewallSettings
    esac
}
# ───────────────────────SELINUX模式───────────────────────── #
function ModeSettings(){
    tip 1 '请选择SELINUX工作模式(1.Disabled-禁用 2.Permissive-宽容 3.Enforcing-强制)' modesettings
    if [[ ! "${modesettings:=1}" =~ ^[123]$ ]]; then        
        infoecho 2 请选择正确的工作模式
        echo
        ModeSettings
    fi
    # 方便写入配置,将用户输入序号与模式绑定
    case $modesettings in
        1)
            se_mode=disabled
        ;;
        2)
            se_mode=permissive
        ;;
        3)
            se_mode=enforcing
    esac
    tip 2 "SELINUX工作模式将修改为:${se_mode},是否临时生效(y.临时生效 n.写入配置)" modechoice
    case ${modechoice:="y"} in
        y)  # 临时修改
            if [ $modesettings -eq 3 ];then
                setenforce 1
            elif [[ ! "${modesettings:=1}" =~ ^[12]$ ]];then
                setenforce 0
            fi
            myecho 3 "SELINUX工作模式已被修改为:${se_mode}"
            read
        ;;
        n)  # 临时修改+写入配置,实现不用重启的模式切换
            if [ $modesettings -eq 3 ];then
                setenforce 1
                sed -i -r "s/^SELINUX=.*/SELINUX=${se_mode}/" /etc/selinux/config
            elif [ $modesettings -eq 1 || $modesettings -eq 2 ];then
                setenforce 0
                sed -i -r "s/^SELINUX=.*/SELINUX=${se_mode}/" /etc/selinux/config
            fi
            myecho 3 "SELINUX工作模式已被修改为:${se_mode},并已写入配置/etc/selinux/config"
            read
        ;;
        *)
            clear
                print_line
                warnning ${CmdName} 选项错误,稍后将重新运行
                print_line
            sleep 1
            ModeSettings
    esac
}
# ───────────────────────SELINUX───────────────────────── #
function SelinuxSettings(){
    while true
    do
        clear
        cat << EOF | sed "s/[═◉]/${cyan}&${reset}/g" | sed "s/\[[0-9a-z]\]/${red}&${reset}/g"
    ◉═════════════════════◉
          SELINUX管理    
    ◉═════════════════════◉
        [1] 查看当前模式
        [2] 修改SELINUX
        [r] 返回主菜单
        [q] 退出  
    ◉═════════════════════◉
EOF
    tip ${CmdName} 请输入功能序号 selinuxsettings
        case $selinuxsettings in
        1)  # 查看当前模式
            se_state=$(getenforce)
            infoecho 1 当前SELINUX工作模式:"${se_state}"
            read
        ;;
        2)  # 修改SELINUX
            ModeSettings
        ;;
        r)
            Menu
        ;;
        q)
            Quit
        ;;
        *)
            clear
                print_line
                warnning ${CmdName} 选项错误,稍后将重新运行
                print_line
            sleep 1
            SelinuxSettings
        esac
    done
}
function SafetyManagement(){
    CmdName="安全管理"
    while true
    do
        clear
        cat << EOF | sed "s/[═◉]/${cyan}&${reset}/g" | sed "s/\[[0-9a-z]\]/${red}&${reset}/g"
    ◉═══════════════════════◉
           安 全 管 理
    ◉═══════════════════════◉
        [1] 查看防火墙区域
        [2] 添加端口
        [3] 移除端口
        [4] 设置防火墙状态
        [5] SELINUX
        [r] 返回主菜单
        [q] 退出
    ◉═══════════════════════◉
EOF
    tip ${CmdName} 请输入功能序号 safetymanagement
        case $safetymanagement in
        1)  # 查看防火墙区域
            firewall-cmd --list-all
            read
        ;;
        2)  # 添加端口
            PortSettings add 添加
        ;;
        3)  # 移除端口
            PortSettings remove 移除
        ;;
        4)  # 设置防火墙状态
            FirewallSettings
        ;;
        5)  # SELINUX
            SelinuxSettings
        ;;
        r)
            Menu
        ;;
        q)
            Quit
        ;;
        *)
            clear
                print_line
                warnning ${CmdName} 选项错误,稍后将重新运行
                print_line
            sleep 1
            SafetyManagement
        esac
    done
}
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━进程管理━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ #
# ───────────────────────终止进程───────────────────────── #
function KillProcess(){
    infoecho 1 "开始终止进程"
    sleep 1
    tip 2 "输入要终止的PID或进程名" pidname
    sleep 1
    # 正则匹配输入信息是否为PID数字
    if [[ "$pidname" =~ ^[0-9]+$ ]]; then
        if ps -p "$pidname" > /dev/null; then
            kill -9 "$pidname" && \
            myecho 3 "进程${pidname}已终止"
        else
            error 3 "PID为${pidname}的进程不存在"
        fi
    else
        # 通过输入进程名查找队形PID,并且跳过当前运行脚本,防止脚本意外退出
        pids=$(pgrep -f "$pidname" | grep -v $$)
        if [ -z "$pids" ]; then
            error 3 "进程名为${pidname}的进程不存在"
        else
            infoecho 3 正在查找进程
            speedbar 2
            infoecho 4 匹配进程:
            # 展示所有同名进程的相关信息
            ps -o pid,user,%cpu,%mem,cmd -p ${pids}
            tip 5 "是否终止以上所有进程?(y/n)" killchoice
            if [[ $killchoice = "y" ]]; then
                kill -9 $pids
                myecho 6 "已终止所有匹配进程"
            fi
        fi
    fi
    read
}
function ProcessManagement(){
    CmdName="进程管理"
    while true
    do
        clear
        cat << EOF | sed "s/[═◉]/${cyan}&${reset}/g" | sed "s/\[[0-9a-z]\]/${red}&${reset}/g"
    ◉═════════════════════◉
          进 程 管 理
    ◉═════════════════════◉
        [1] 查看进程列表
        [2] 实时监控
        [3] 终止进程
        [4] 查找进程
        [r] 返回主菜单
        [q] 退出
    ◉═════════════════════◉
EOF
    tip ${CmdName} 请输入功能序号 processmanagement
        case $processmanagement in
        1)  # 查看进程列表,使用less退出后不占用终端
            infoecho 1 "进程列表(按方向键查看,按q退出)"
            speedbar 3
            ps aux | less -S
        ;;
        2)  # 默认使用htop实时监控
            infoecho 1 "实时监控(按q退出)"
            if command -v htop &> /dev/null; then
                htop
            else
                tip 2 "安装htop可获得更好体验,是否安装?(y/n)" yumchoice
                if [ ${yumchoice:="y"} = "n" ];then
                    infoecho 3 "正在打开默认进程监控服务(按q退出)"
                    speedbar 3
                    top
                elif [ $yumchoice = "y" ];then
                    infoecho 3 "正在安装htop,受网络波动影响,请耐心等待"
                    yum install -y htop &> /dev/null
                    myecho 4 "下载完毕,正在打开(按q退出)"
                    speedbar 3
                    htop
                fi
        fi
        ;;
        3)
            KillProcess
        ;;
        4)  # 通过进程名查找进程
            infoecho 1 "开始查找进程"
            sleep 1
            tip 2 "请输入进程名" processname
            infoecho 3 "正在查找进程"
            speedbar 2
            # 美化输出
            pgrep -fa "$processname" |awk 'BEGIN{printf "\033[31m|\033[0m\033[32m %-7s\033[0m\033[31m|\033[0m\033[32m %-30s\033[0m\033[31m|\033[0m\n","PID","进程名"}\
            {printf "  %-6s \033[31m|\033[0m %s %s %s %21s\n",$1,$2,$3,$4,$5}'
            read
        ;;
        r)  # 主菜单
            Menu
        ;;
        q)
            Quit
        ;;
        *)
            clear
                print_line
                warnning ${CmdName} 选项错误,稍后将重新运行
                print_line
            sleep 1
            ProcessManagement
        esac
    done
}
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━脚本开发文档━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ #
function ToolsDocumentation(){
    clear
    printf "   \e[32m%-10s\e[0m\n" "[开发文档]"
    print_long_line
    printf "      %s\n  %s\n  %s\n  %s\n  %s\n"  \
        "本脚本为系统工具箱,旨在实现LINUX系统中常用功能的集合、" \
        "封装和输出美化,开发测试机:CentOS Linux 7 (Core) 内核版本:"\
        "Linux 3.10.0-1062.el7.x86_64。脚本文件名:toolsbox,主脚本:"\
        "menu.sh,版本:v2.0.最后更新日期:2025-5-22."
    printf "┌───────────────┬──────────────────────────────────────────────┐\n"
    printf "│\e[38;2;47;74;119m  %-9s\e[0m\t│\e[38;2;182;154;49m  %-46s\e[0m│\n" "作       者" "庞   乐"
    printf "│\e[38;2;47;74;119m  %-15s\e[0m\t│\e[38;2;182;154;49m  %-44s\e[0m│\n" "联 系 方 式" "956143827@qq.com"
    printf "│\e[38;2;47;74;119m  %-10s\e[0m\t│\e[38;2;182;154;49m  %-44s\e[0m│\n" "GitHub 地址" "https://github.com/panglele/toolsbox-SHELL"
    printf "│\e[38;2;47;74;119m  %-15s\e[0m\t│\e[38;2;182;154;49m  %-50s\e[0m│\n" "开 发 参 考" "千峰刘杰老师 :get-os-info.sh"
    printf "│\e[38;2;47;74;119m  %-11s\e[0m\t│\e[38;2;182;154;49m  %-46s\e[0m│\n" "" "CSDN: M乔木  :QiaoMuOS-24-3-25.sh"
    printf "└───────────────┴──────────────────────────────────────────────┘\n"
    read
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━工具箱主菜单━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ #
function Menu(){
    trap  'warnning "$CommandName" "工具箱无法使用Ctrl+C退出"' INT      # 捕获ctrl+c
    while true
    do
        clear
        cat << EOF | sed "s/[═◉]/${cyan}&${reset}/g" | sed "s/\[[0-9a-z]\]/${red}&${reset}/g"
    ◉═════════════════════◉
         ToolsBox[2.0]
    ◉═════════════════════◉
        [1] 系统功能
        [2] 服务部署
        [3] 网络管理
        [4] 用户管理
        [5] 安全管理
        [6] 进程管理
        [7] 安装至系统
        [i] 开发文档
        [q] 退出
    ◉═════════════════════◉
EOF
        tip ${CommandName} 请输入功能序号 menu
        case $menu in
        1)  # 系统功能
            SystemTools
        ;;
        2)  # 服务部署
            echo "功能待完善"
            read
        ;;
        3)  # 网络管理
            NetworkManagement
        ;;
        4)  # 用户管理
            UserManagement
        ;;
        5)  # 安全管理
            SafetyManagement
        ;;
        6)  # 进程管理
            ProcessManagement
        ;;
        7)  # 安装至系统
            InstallToSystem
        ;;
        i)  # 开发文档
            ToolsDocumentation
        ;;
        q)  # 退出
            Quit
        ;;
        *)  # 捕获异常输入
            clear
                print_line
                warnning ${CommandName} 选项错误,稍后将重新运行
                print_line
            sleep 1
            Menu
        esac
    done
}

Menu