#!/bin/bash
#——————————————————————————————————————#
#    Author:        pangle
#    Date:          2025-05-10
#    FileName       style.sh
#——————————————————————————————————————#

# 前景色
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
# 背景色
bg_red=$(tput setab 1)
bg_green=$(tput setab 2)
bg_yellow=$(tput setab 3)
bg_blue=$(tput setab 4)
bg_magenta=$(tput setab 5)
bg_cyan=$(tput setab 6)

reset=$(tput sgr0)

# 成功
success(){  
    echo "$green[$1]▶ $2 $reset"
}
# 错误
error(){    
    echo "$red[$1]▶ $2 $reset"
}
# 警告
warnning(){
    echo "$yellow[$1]▶ $2 $reset"
}
# 信息
info(){
    echo "$blue[$1]▶ $2 $3 $reset"
}
# 输入提示
tip(){
    read -p "$magenta[$1]$2: $reset" $3
}
# 批量输出
output(){
    echo "$1:[${cyan}$2${reset}]"
}
infoecho(){
    echo "$blue[$1]$2 $reset"
}
myecho(){
    echo "$green[$1]$2$reset"
}
print_line(){
    echo "◉═════════════════════════════════════════◉"
}
print_long_line(){
    echo "◉═══════════════════════════════════════════════════════════◉"
}

test_success(){
    echo "$green[$1]-->$reset $bg_green $2 $reset"
}

test_error(){
    echo "$red[$1]-->$reset $bg_red$2 $reset"
}

test_warnning(){
    echo "$yellow[$1]-->$reset $bg_yellow$2 $reset"
}

test_info(){
    echo "$blue[$1]-->$reset $bg_blue$2 $reset"
}