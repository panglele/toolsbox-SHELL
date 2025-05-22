
# 查看系统用户awk规则文件
BEGIN{
    FS=":";
    OFS="|";

    RED = "\033[31m"
    Tawny = "\033[38;2;182;154;49m"
    Purple = "\033[38;2;103;75;110m"
    Blue = "\033[38;2;47;74;119m"
    Green = "\033[38;2;92;146;42m"
    Cyan = "\033[38;2;63;141;144m"
    Reset = "\033[0m"

    printf("╔")
    for(i=0;i<83;i++){
        printf "═"
    }
    printf("╗\n")

    printf "║ %-16s | %-5s | %-5s | %-23s | %-14s ║\n","用户名","UID","GID","主目录","SHELL"
   
    printf("╠")
    for(i=0;i<83;i++){
        printf "═"
    }
    printf("╣\n")
} 

{
    if (opt == 1){
        if ($3<100){
            printf "║ "Cyan"%-20s"Reset"| "Green"%-6s"Reset"| "Tawny"%-6s"Reset"| "Blue"%-27s"Reset"| "Purple"%-15s"Reset"║\n",$1,$3,$4,$6,$7
        }
    }

    if (opt != 1){
        if ($3>1000){
            printf "║ "Cyan"%-20s"Reset"| "Green"%-6s"Reset"| "Tawny"%-6s"Reset"| "Blue"%-27s"Reset"| "Purple"%-15s"Reset"║\n",$1,$3,$4,$6,$7
        }
    }    
}

END{
    printf("╚")
    for(i=0;i<83;i++){
        printf "═"
    }
    printf("╝\n")
}
