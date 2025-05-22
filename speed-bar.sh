#!/bin/bash
#——————————————————————————————————————#
#    Author:        pangle
#    Date:          2025-05-21
#    FileName       speed-bar.sh
#——————————————————————————————————————#
speedbar(){
    green=$(tput setaf 2)
    reset=$(tput sgr0)

    duration=$1          # 总时长（秒）
    interval=0.1          # 更新间隔（秒）
    steps=$((duration*10)) # 总步数（0.1秒/步）
    echo -n "处理中..."
    for ((i=1; i<=steps; i++)); do
        # 计算进度百分比
        percent=$((i*100/steps))
        # 构建进度条（总长度20字符）
        bar="   [${green}"
        for ((j=0; j<i*20/steps; j++)); do
            bar+=">"
        done
        bar+="${reset}"
        for ((j=i*20/steps; j<20; j++)); do
            bar+="-"
        done
        bar+="]"
        # 打印进度（使用\r覆盖当前行）
        printf "\r%s ${green}%3d%%${reset}" "$bar" "$percent"
        sleep $interval
    done
    echo 
}

