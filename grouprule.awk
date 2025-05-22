
# 查看系统组awk规则文件
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
    for(i=0;i<78;i++){
        printf "═"
    }
    printf("╗\n")

    printf "║ %-17s | %-5s | %-40s ║\n","组名","GID","组内用户列表"
   
    printf("╠")
    for(i=0;i<78;i++){
        printf "═"
    }
    printf("╣\n")
} 

{
    if($3>1000){
        printf "║ "Cyan"%-20s"Reset"| "Green"%-6s"Reset"| "Tawny"%-47s"Reset"║\n",$1,$3,$4
    }
}

END{
    printf("╚")
    for(i=0;i<78;i++){
        printf "═"
    }
    printf("╝\n")
}
