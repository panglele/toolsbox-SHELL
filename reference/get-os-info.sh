#!/usr/bin/bash

unset c
color(){
    declare -A c=([Error]=31 [Success]=32 [Warning]=33 [Info]=34)
    #echo -e "\033[${c[$1]}m[`date +%T`]($1)  $2\033[0m"
    printf "\033[${c[$1]}m%-10s%-10s %-30s\033[0m\n" "[`date +%T`]" "($1)" "$2"
    sleep 0.5
}
cpu(){
    cpus=$(grep processor /proc/cpuinfo |wc -l)
    cpuModel=$(grep "model name" /proc/cpuinfo | uniq | awk -F ':' '{print $2}')
    cpuCache=$(grep "cache size" /proc/cpuinfo | uniq | awk -F ':' '{print $2}')
    printf "%-10s\t%-50s\n" "[CPU]" "[Info]"
    printf "%-10s\t%-50s\n" "cpu核心：" "${cpus/ /}核"
    printf "%-10s\t%-50s\n" "cpu型号：" "${cpuModel/ /}"
    printf "%-10s\t%-50s\n" "cpu缓存：" "${cpuCache/ /}"
}
memory(){
    memTotal=$(awk -F':' '/MemTotal:/{print $2}' /proc/meminfo | awk '{print $1,$2}')
    memFree=$(awk -F':' '/MemFree:/{print $2}' /proc/meminfo | awk '{print $1,$2}')
    memBuffer=$(awk -F':' '/Buffers:/{print $2}' /proc/meminfo | awk '{print $1,$2}')
    memCached=$(awk -F':' '/^Cached:/{print $2}' /proc/meminfo | awk '{print $1,$2}')
    swapTotal=$(awk -F':' '/SwapTotal:/{print $2}' /proc/meminfo | awk '{print $1,$2}')
    swapFree=$(awk -F':' '/SwapFree:/{print $2}' /proc/meminfo | awk '{print $1,$2}')
    memDevice=$(dmidecode |grep -P -A 5 "Memory Device"|grep Size|grep -v 'Range' | wc -l)
    maxMem=$(dmidecode |grep "Maximum Capacity" | awk '{print $3,$4}')
    maxHz=$(dmidecode |grep "Max Speed" |uniq | awk '{print $3,$4}')
    printf "%-10s\t%-50s\n" "[Memory]" "[Info]"
    printf "%-10s\t%-50s\n" "内存总量：" "$memTotal"
    printf "%-10s\t%-50s\n" "内存剩余：" "$memFree"
    printf "%-10s\t%-50s\n" "内存写缓：" "$memBuffer"
    printf "%-10s\t%-50s\n" "内存读缓：" "$memCached"
    printf "%-10s\t%-50s\n" "临时缓存总量：" "$swapTotal"
    printf "%-10s\t%-50s\n" "临时缓存剩余：" "$swapFree"
    printf "%-10s\t%-50s\n" "内存条数：" "$memDevice"
    printf "%-10s\t%-50s\n" "最大支持内存：" "$maxMem"
    printf "%-10s\t%-50s\n" "内存频率：" "$maxHz"
}
disk(){
    printf "%-10s\t%-15s\t%-30s\t%-5s\n" "[MountPoint]" "[Used]" "[FileSystem]" "[Size]"
    df -Th | awk 'BEGIN{ORS="\n"}$2 ~ /(ext|xfs)/{printf "%-10s\t%-15s\t%-30s\t%-5s\n",$NF,$(NF-1),$1,$3}'
}

os(){
    os_release=$(hostnamectl | awk -F': ' '/Operating System/{print $2}')
    os_kernel=$(hostnamectl | awk -F': ' '/Kernel/{print $2}')
    hostname=$(hostnamectl | awk -F': ' '/Static hostname/{print $2}')
    printf "%-10s\t%-20s\n" "[Info]" "[Value]"
    printf "%-20s\t%-20s\n" "系统版本：" "$os_release"
    printf "%-20s\t%-20s\n" "内核版本：" "$os_kernel"
    printf "%-20s\t%-20s\n" "主机名称：" "$hostname"
    netIf=$(ip -f inet a | awk '/^[0-9]/{print $0}' |awk -F':' '{print $2}')
    netIfs=$(echo netIf |wc -w)
    printf "%-20s\t%-20s\t%-18s\n" "[InterFace]" "[IpAddress]" "[MacAddress]"
    for i in $netIf
    do
        # 网卡ip
        iname=$(ip -f inet a show dev $i | awk '/inet/{print $2}')
        # 网卡mac
        mname=$(ip -f link a show dev $i |awk '/link/{print $2}')
        printf "%-20s\t%-20s\t%-18s\n" "$i" "$iname" "$mname"
    done
}

color Info "开始读取本地信息"

main(){
    color Success "中央处理器信息"
    # cpu 信息查询函数
    cpu
    color Success "内存信息"
    # 内存 信息查询函数
    memory
    color Success "网络信息"
    os
    # 磁盘信息
    color Success "磁盘信息"
    disk 
}

main