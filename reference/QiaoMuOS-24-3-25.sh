#!/usr/bin/bash
#声明函数
JX_d(){
	clear
	#echo "请输入登录镜像仓库的凭证"
	docker login --username=M乔木 --password=Qianfeng@123   registry.cn-beijing.aliyuncs.com &>/dev/null
	#docker login --username=M乔木 registry.cn-beijing.aliyuncs.com 
	#if [ $? -ne "0" ];then
	#clear
	#echo "[凭证异常 已退出!]"
	#exit 9
	#fi
}
JX(){
	clear
	echo "-------------------------------------------------------------"
	docker images
	echo "-------------------------------------------------------------"
}
JX_z(){
	read -p "为确保唯一性,请输入你不低于6位数的镜像ID[回复q退出]:" JX_num
	case ${JX_num} in
q)
	clear 
	echo "[已退出!]"
	exit 0		
	;;
*)
	JX_f=$(docker images | grep "$JX_num" &>/dev/null && echo 1 || echo 2)
	if [ ${JX_f} -ne "1" ];then
	clear
	echo "[已退出!]"
	echo "[该镜像不存在!]"
	exit
	fi
	read -p "请为你的镜像起个新名字:" JX_j
	sleep 1 
	read -p "请为你的镜像设定个版本:" JX_b
	clear
    echo "[开始修改新镜像信息...]"	
	docker tag ${JX_num} registry.cn-beijing.aliyuncs.com/qm-ay/${JX_j}:${JX_b}
	echo "[开始推送镜像到阿里云...]"
	docker push registry.cn-beijing.aliyuncs.com/qm-ay/${JX_j}:${JX_b} &>/dev/null
	if [ $? -eq "0" ];then
	echo "[镜像推送成功 请到阿里云仓库查看!]"
	exit 0
	else
	echo "[镜像推送失败 请查看日志]"
	exit 9
	fi	
	esac 
}
function dd_docker(){
clear
cat<<EOF
+--------------+
 [1]深度清理空间
 [2]清理空闲卷组
 [3]清理空闲镜像
 [4]清理空闲网络
 [5]清理空闲容器
 [6]返回主菜单
 [q]退出程序
+--------------+
EOF
	read -p "请输入序号:" dd_num
	case $dd_num in
	1)
	echo "开始深度清理docker空间..."
	sleep 1 
	dd_s=$(docker system prune -f | awk '/Total reclaimed space:/{print $4}')
	echo "本次清理空间:${dd_s}"
	sleep 1
	dd_docker	
	;;
	2)
	echo "开始清理空闲卷组..."
	sleep 1
	dd_k=$(docker volume prune -f | awk '/Total reclaimed space:/{print $4}')
	echo "本次清理空闲卷组:${dd_k}"
	sleep 1
	dd_docker
	;;
	3)
	echo "开始清理空闲镜像..."
	sleep 1
	dd_x=$(docker image prune -f | awk '/Total reclaimed space:/{print $4}')
	echo "本次清理空闲镜像:${dd_x}"
	sleep 1
	dd_docker
	;;
	4)
	echo "开始清理空闲网络..."
	sleep 1
	docker network prune -f
	echo "已清理空闲网络"
	sleep 1
	dd_docker
	;;
	5)
	echo "开始清理空闲容器..."
	sleep 1
	dd_r=$(docker container prune -f | awk '/Total reclaimed space:/{print $4}')
	sleep 1
	echo "本次清理空闲容器:${dd_r}"
	sleep 1
	dd_docker
	;;
	6)
	menus
	;;
	q)
	Qc_QM
	;;
	*)
	Rr_QM
	dd_docker
	esac
}
function Dk_save(){
    if [ ! -d "./images" ]; then
        mkdir images
    fi
    cd images
    docker images --format "{{.ID}} {{.Repository}}:{{.Tag}} {{.Size}}" > images_pull.txt
    while read line
    do
        image_id=`echo $line | awk '{print $1}'`
        image_repository=`echo $line | awk '{print $2}'`
        image_size=`echo $line | awk '{print $3}'`
        docker save -o $image_id.tar $image_repository &>/dev/null  && \
        echo "镜像名:[${image_repository}] 大小:[${image_size}]"
    done < images_pull.txt
}
function Dk_load(){
    if [ ! -d "./images" ]; then
        echo "当前目录下没有可有导入的镜像[已退出!]"
	exit 9
    fi
    cd images
    while read line
    do
        image_id=`echo $line | awk '{print $1}'`
        image_repository=`echo $line | awk '{print $2}'`
        docker load -i $image_id.tar &>/dev/null && \
        echo "镜像名:[${image_repository}] 已导入!"
    done < images_pull.txt
}
function Dk_sl(){
clear
cat<<EOF
+----------+
 [1] save
 [2] load
 [q] q退出
+----------+
EOF
read -p "请输入序号:" im_id
case $im_id in
1)
	Dk_save
	;;
2)
	Dk_load
	;;
q)
	Qc_QM
	;;
*)
	echo "输入错误已退出!"
	exit 9
esac
}
function dH_QM(){
	a=0
        while :
do
        let a++
        clear ; netstat -nplt
        read -t 1 -p "回复q退出:" num
        case $num in
        q)
           exit 0
        esac
done
}
function make_ZBA() {
    clear
    echo "开始部署Agent..."
    sleep 1
    read -p "请输入Server端服务器IP:" AG_IP

    rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm &>/dev/null

    yum clean all &>/dev/null && yum makecache fast &>/dev/null

    yum -y install zabbix-agent &>/dev/null

    sed -i '/^Server=127.0.0.1/d' /etc/zabbix/zabbix_agentd.conf
    echo "Server=${AG_IP}" >>/etc/zabbix/zabbix_agentd.conf

    sed -i '/^ServerActive=127.0.0.1/d' /etc/zabbix/zabbix_agentd.conf
    echo "ServerActive=${AG_IP}" >>/etc/zabbix/zabbix_agentd.conf

    agent_H=$(hostname)
    sed -i '/^Hostname=Zabbix server/d' /etc/zabbix/zabbix_agentd.conf
    echo "Hostname=${agent_H}" >>/etc/zabbix/zabbix_agentd.conf

    echo 'zabbix  ALL=(ALL)  NOPASSWD: ALL' >>/etc/sudoers

    echo 'EnableRemoteCommands=1' >>/etc/zabbix/zabbix_agentd.conf
    echo 'LogRemoteCommands=1' >>/etc/zabbix/zabbix_agentd.conf

    systemctl restart zabbix-agent &>/dev/null

    systemctl enable zabbix-agent &>/dev/null

    echo "Agent端已部署完成！Server端为:${AG_IP}"
}
function make_ZBS() {
    #环境检测
    clear
    echo "--------------------------------------------------------"
    echo "[1]开始检测防火墙Selinux..."
    f_w=$(systemctl status firewalld | awk '/Active:/{print $2}')
    s_l=$(getenforce)
    #判断是否关闭 没关闭就结束运行
    if [ ${f_w} = "inactive" -a ${s_l} = "Disabled" ]; then
        echo "[2]防火墙SeLinux已关闭..."
        sleep 1
        echo "[3]正在飞速安装zabbix中..."
        sleep 1
    else
        echo "[2]防火墙SeLinux未关闭..."
        systemctl disable firewalld &>/dev/null
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
        sleep 1
        echo "[3]正在关闭..."
        sleep 1
        echo "[4]防火墙SeLinux已关闭 请重启机器生效..."
        echo "--------------------------------------------------------"
        exit 0
    fi
    #安装zabbix源
    rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm &>/dev/null
    #安装数据库并清理缓存
    echo '[4]准备安装数据库,全程20秒左右,请耐心等待...'
    sleep 1
    echo '[5]开始清理环境...'
    yum erase mariadb mariadb-server mariadb-libs mariadb-devel -y &>/dev/null
    userdel -r mysql &>/dev/null
    rm -rf /etc/my* &>/dev/null
    rm -rf /var/lib/mysql &>/dev/null
    rm -rf /usr/bin/mysql &>/dev/null
    yum -y erase $(rpm -qa | egrep "mysql|mariadb") &>/dev/null

    echo '[6]正在下载mysqlyum源...'
    yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-7.noarch.rpm &>/dev/null

    echo '[7]正在安装mysql...'
    yum install -y mysql-community-server --enablerepo mysql57-community --disablerepo mysql80-community &>/dev/null
    yum -y groupinstall "Development Tools" &>/dev/null

    echo '[8]正在配置mysql...'
    yum -y install yum-utils &>/dev/null
    yum-config-manager --disable mysql80-community &>/dev/null
    yum-config-manager --enable mysql57-community &>/dev/null

    echo '[9]正在启动mysql...'
    systemctl start mysqld &>/dev/null

    echo '[10]正在设置密码,请稍后...'
    num_az=$(awk '/temporary password/{p=$NF}END{print p}' /var/log/mysqld.log)
    echo 'validate-password=OFF' >>/etc/my.cnf

    systemctl restart mysqld &>/dev/null
    read -p '请输入新密码:' passwdx
    mysqladmin -uroot -p"$num_az" password "$passwdx" &>/dev/null

    echo "[11]安装完成,密码已设置完成为:$passwdx"
    echo "[12]密码已保存到/mysql_passwd.txt目录下"
    echo $passwdx >/mysql_passwd.txt

    yum clean all &>/dev/null && yum makecache fast &>/dev/null
    #安装zabbix模块
    echo "[13]开始安装zabbix..."
    yum -y install zabbix-server-mysql zabbix-agent zabbix-get zabbix-sender centos-release-scl &>/dev/null
    yum -y install yum-utils &>/dev/null
    rpm -qa | grep yum-utils &>/dev/null
    if [ $? -eq 1 ]; then
        sleep 1
        yum -y install yum-utils &>/dev/null
    fi
    yum-config-manager --enable zabbix-frontend &>/dev/null
    yum -y install zabbix-web-mysql-scl zabbix-nginx-conf-scl centos-release-scl &>/dev/null
    #建立运行数据库
    echo "[14]正在建立运行数据库..."
    mysql -p"${passwdx}" -e 'create database zabbix character set utf8 collate utf8_bin;' &>/dev/null
    mysql -p"${passwdx}" -e "create user zabbix@localhost identified by 'admin';" &>/dev/null
    mysql -p"${passwdx}" -e 'grant all privileges on zabbix.* to zabbix@localhost;' &>/dev/null
    mysql -p"${passwdx}" -e 'set global log_bin_trust_function_creators = 1;' &>/dev/null
    mysql -p"${passwdx}" -e 'flush privileges;' &>/dev/null
    echo "[15]zabbix登录数据库密码为:admin"
    echo "zabbix登录数据库密码为:admin" >>/zabbix-mysql.txt
    zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p"admin" zabbix 2>/dev/null
    #关联数据库
    echo "[16]正在改写相关配置文件..."
    mysql -p"${passwdx}" -e 'set global log_bin_trust_function_creators = 0;' &>/dev/null
    echo "DBHost=localhost" >>/etc/zabbix/zabbix_server.conf
    echo "DBPassword=admin" >>/etc/zabbix/zabbix_server.conf
    echo "DBPort=3306" >>/etc/zabbix/zabbix_server.conf
    #关联php
    sed -i '2s/^#//;3s/^#//' /etc/opt/rh/rh-nginx116/nginx/conf.d/zabbix.conf
    sed -i '38,118d' /etc/opt/rh/rh-nginx116/nginx/nginx.conf
    sed -i 's/listen.acl_users = apache/listen.acl_users = apache,nginx/' /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf
    sed -i '25d' /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf
    echo 'php_value[date.timezone] = Asia/Shanghai' >>/etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf
    #重启服务
    echo "[17]正在重启相关服务..."
    systemctl restart zabbix-server zabbix-agent rh-nginx116-nginx rh-php72-php-fpm &>/dev/null
    systemctl enable zabbix-server zabbix-agent rh-nginx116-nginx rh-php72-php-fpm &>/dev/null
    echo "[18]zabbix已部署 后续请登录浏览器安装..."
    echo "--------------------------------------------------------"
}
function Az_docker() {
    clear
    #检测防火墙selinux
    echo "------------------------------------------------------------"
    echo "[1]开始检测防火墙SeLinux是否关闭..."
    sleep 1
    f_w=$(systemctl status firewalld | awk '/Active:/{print $2}')
    s_l=$(getenforce)
    #判断是否关闭 没关闭就结束运行
    if [ ${f_w} = "inactive" -a ${s_l} = "Disabled" ]; then
        echo "[2]防火墙SeLinux已关闭..."
        sleep 1
        echo "[3]正在飞速安装docker中..."
        sleep 1
    else
        echo "[2]防火墙SeLinux未关闭..."
        systemctl disable firewalld &>/dev/null
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
        sleep 1
        echo "[3]正在关闭..."
        sleep 1
        echo "[4]防火墙SeLinux已关闭 请重启机器生效..."
        echo "------------------------------------------------------------"
        exit 0
    fi
    #防火墙关了的话就继续开启路由转发
    echo "[4]正在开启路由转发虚拟网桥..."
    echo 'net.ipv4.ip_forward =1' >>/etc/sysctl.conf
    echo 'net.bridge.bridge-nf-call-iptables =1' >>/etc/sysctl.conf
    echo 'net.bridge.bridge-nf-call-ip6tables =1' >>/etc/sysctl.conf
    sysctl -p &>/dev/null
    sleep 1
    #防火墙关闭的话就清理docker环境
    echo "[5]正在清理环境中..."
    yum -y remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine &>/dev/null
    sleep 1
    echo "[6]开始安装docker依赖..."
    yum install -y yum-utils device-mapper-persistent-data lvm2 &>/dev/null
    sleep 1
    echo "[7]开始配置阿里docker源..."
    yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo &>/dev/null
    yum clean all &>/dev/null && yum makecache fast &>/dev/null
    sleep 1
    echo "[8]开始安装docker..."
    yum -y install docker-ce doker-ce-cli containerd.io &>/dev/null
    sleep 1
    echo "[9]开始配置开机自启..."
    systemctl start docker &>/dev/null
    systemctl enable docker &>/dev/null
    systemctl restart docker &>/dev/null
    sleep 1
    echo "[10]开始配置阿里云镜像加速器..."
    clear
    echo "[11]开始建立docker加速器放置目录..."
    mkdir -p /etc/docker
    sleep 1
    echo "[12]开始写入配置..."
    tee /etc/docker/daemon.json &>/dev/null <<-'EOF'
{
  "registry-mirrors": ["https://2zwkpj0m.mirror.aliyuncs.com"],
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
    sleep 1
    echo "[13]重新加载system工具..."
    sed -i 's/containerd.sock/containerd.sock --data-root=\/dockerdata/' /usr/lib/systemd/system/docker.service 
    systemctl daemon-reload &>/dev/null
    sleep 1
    echo "[14]重新启动docker..."
    systemctl restart docker &>/dev/null
    sleep 1
    echo "[15]阿里云镜像加速器配置完毕!"
    sleep 1
    echo "[16]开始拉取基础镜像centos:7..."
    docker pull centos:7 &>/dev/null
    sleep 1
    echo "[17]已部署docker及第一个基础镜像centos7已配置完毕!"
    sleep 1
    echo '[18]开始使用你的一个docker命令体验激动人心的docker吧!'
    sleep 1
    echo '[19]docker images:查看已下载镜像'
    sleep 1
    echo '[20]docker info:查看docker基本信息'
    sleep 1
    echo '[21]docker run -it centos:7 /bin/bash  启动容器'
    echo "------------------------------------------------------------"
}
function jq_z() {
    jq_id=$(cat /opt/QMOSjQ/jQ${idjqw}/* | head -1)
    if [ -z $jq_id ]; then
        :
    else
        read -p "该资产已注册 是否覆盖[y|n]" jq_num
        case $jq_num in
        y)
            :
            ;;
        n)
            echo "重新加载注册界面..."
            sleep 1
            jqzh
            ;;
        *)
            Rr_QM
            jqzh
            ;;
        esac
    fi
}
function jq_d() {
    if [ $? -eq 0 ]; then
        :
    else
        clear
        echo "该资产还没有注册..."
        sleep 1
        echo "请在资产注册信息以后再使用!"
        sleep 1
        jqfun
    fi
}
function jq_f() {
    jq_fQ=$(ls /opt/ | grep QMOSjQ &>/dev/null && echo 1 || echo 2)
    case $jq_fQ in
    1)
        :
        ;;
    2)
        clear
        echo "---------------------------"
        echo " 检测到环境不支持运行堡垒机"
        sleep 1
        echo " 前往堡垒机主界面使用[环境部署]"
        echo "---------------------------"
        sleep 1
        jqfun
        ;;
    esac
}
function Qc_QM() {
    clear
    cat <<EOF
=============
 "已退出程序!"
=============
EOF
    exit 0
}
function Rr_QM() {
    clear
    cat <<EOF
=============================
 "序列号输入错误 稍后将重新运行!"
=============================
EOF
    sleep 1
}
function make_redis() {
    #自动化部署Redis
    clear
    echo "----------------------------------------------------------------------------"
    DATA=$(ls / | grep data)
    if [ -z $DATA ]; then
        echo "[1]检查是否下载wget..."
        yum -y install wget &>/dev/null
        echo "[2]创建放置redis目录..."
        mkdir -p /data/app
        echo "[3]进入工作目录..."
        cd /data/app
        echo "[4]下载redis..."
        wget http://download.redis.io/releases/redis-5.0.10.tar.gz &>/dev/null
        echo '[5]解压redis...'
        tar xzf redis-5.0.10.tar.gz &>/dev/null
        echo '[6]重命名redis...'
        mv redis-5.0.10/ redis
        echo '[7]下载编译工具...'
        cd redis/ && yum install -y gcc make &>/dev/null
        echo "[8]安装redis..."
        make &>/dev/null
        cd /data/app/redis
        echo "[9]备份redis配置文件..."
        cp redis.conf redis.conf.backup
        echo "[10]开始修改配置文件..."
        sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' redis.conf
        sed -i '/^dir/d' redis.conf
        echo 'dir /data/app/redis/data' >>redis.conf
        sed -i '/^logfile/d' redis.conf
        echo 'logfile /var/log/redis.log' >>redis.conf
        sed -i '/^daemonize/d' redis.conf
        echo 'daemonize yes' >>redis.conf
        mkdir /data/app/redis/data
        touch /var/log/redis.log
        echo "[11]开始配置全局启用reids..."
        echo 'export PATH=/data/app/redis/src:$PATH' >>/etc/profile
        source /etc/profile &>/dev/null
        echo "[12]开始配置system工具管理redis..."
        cd /lib/systemd/system/
        cat >redis.service <<EOF
[Unit]
Description=Redis
After=network.target

[Service]
ExecStart=/data/app/redis/src/redis-server /data/app/redis/redis.conf  --daemonize no
ExecStop=/data/app/redis/src/redis-cli -h 127.0.0.1 -p 6379 shutdown

[Install]
WantedBy=multi-user.target
EOF
        cd - &>/dev/null
        systemctl daemon-reload
        systemctl start redis.service
        cd /data/app/redis
        echo "[13]安装完毕!"
        sleep 1
        echo "请使用./data/app/redis/src/redis-cli -h localhost -p 6379 命令登录使用redis!"
        echo "如果环境变量不生效,请手动执行命令:sourece /etc/profile"
        echo "----------------------------------------------------------------------------"
        sleep 2
    else
        echo "[1]安装失败..."
        sleep 1
        echo "[2]原因根目录下存在冲突目录..."
        sleep 1
        echo "[3]请在删除/data目录或重命名后重新运行本程序...!"
        echo "----------------------------------------------------------------------------"
        exit 2
    fi
}
function make_MGR() {
    clear
    echo "------------------------------------------------"
    echo '--------------------------'
    echo '开始安装果仁烤面筋记事本...'
    echo '--------------------------'
    Mpd=$(rpm -qa cowsay)
    sleep 1
    if [ -z $Mpd ]; then
        clear
        echo "安装果仁烤面筋记事本失败! 原因缺少程序运行必须的插件!"
        echo "正在下载插件请稍后..."
        yum -y install cowsay &>/dev/null
        echo "下载插件完毕..."
        sleep 1
        echo "继续安装果仁烤面筋记事本..."
    fi
    mkdir -p /usr/Grk/DB &>/dev/null
    cd /usr/Grk
    echo '#!/usr/bin/bash                          
 # **************************************
 #   CSDN:         M乔木 
 #   qq邮箱:        2776617348@qq.com 
 #   解释器:        这是一个shell脚本        
 # **************************************
	
	#===================================================================
	#函数声明
	function Grk_ck(){
		clear
		echo '--------------------------------------------------------------'
		cat<<EOF
	            "果仁烤面筋记事本" 
EOF
		echo '--------------------------------------------------------------'		
		cowsay -f supermilker  "查看笔记"
		echo '-----------------'
		ls /usr/Grk/DB/ | sort
		echo '-----------------'
		read -p "[查看内容回复x | 返回主页回复q]:" q_grk
		case $q_grk in 
	x)
		clear
		echo '--------------------------------------------------------------'
		cat<<EOF
	            "果仁烤面筋记事本" 
EOF
		echo '--------------------------------------------------------------'		
		cowsay -f supermilker  "查看内容"
		echo '-----------------'
		ls /usr/Grk/DB/ | sort
		echo '-----------------'
		read -p "请输入你想要查看的笔记名"  q_Grk
		clear
		echo '--------------------------------------------------------------'
		cat /usr/Grk/DB/${q_Grk}
		echo '--------------------------------------------------------------'
		read -p "[继续查看回复h | 退出回复q]:" Q_grk
		case $Q_grk in
	h)
		Grk_ck
		;;
	q)
		clear
		echo '[欢迎下次使用!]'
		exit 0
		;;
	*)	
		clear
		echo "===================="
		echo " 输入错误 请重新输入"
		echo "===================="
		sleep 1
		Grk_ck
		esac
		;;
	q)
		Zjm_grk
		;;
	*)	
		clear
		echo "===================="
		echo " 输入错误 请重新输入"
		echo "===================="
		sleep 1
		Grk_ck
		esac 
	}
	function Sx_grk(){		
		clear
		echo '--------------------------------------------------------------'
		cat<<EOF
	            "果仁烤面筋记事本" 
EOF
		echo '--------------------------------------------------------------'		
		cowsay -f supermilker  "\"记录美好生活\""
		read -p "请输入你要记录的标题:" numhead
		clear
		echo '--------------------------------------------------------------'
		echo "                        [${numhead}]                           "
			read -p "请输入你想记录的内容:" nummain	
		echo '--------------------------------------------------------------'
		echo $nummain > /usr/Grk/DB/${numhead}.md
	}
	function Zjm_grk(){
		clear
		echo '--------------------------------------------------------------'
		cat<<EOF
	            "果仁烤面筋记事本" 
EOF
		echo '--------------------------------------------------------------'		
		cowsay -f supermilker  "\"记录美好生活\""
		cat<<EOF
+--------------+
  1.查看笔记
  2.新建笔记
  q.退出记事本
+--------------+
EOF
		read -p ":" drk_zjm
		case $drk_zjm in
	1)
		Grk_ck
		;;
	2)
		Sx_grk
		sleep 1
		Zjm_grk
		;;
	q)
		clear
		echo '[欢迎下次使用!]'
		exit 0
		;;
	*)
		clear
		echo "===================="
		echo " 输入错误 请重新输入"
		echo "===================="
		sleep 1
		Zjm_grk
		esac
	}
	#显示界面
    Zjm_grk' >MGR.sh
    chmod +x /usr/Grk/MGR.sh &>/dev/null
    echo 'export PATH=/usr/Grk:$PATH' >>/etc/profile 2>/dev/null
    source /etc/profile &>/dev/null
    a=0
    while [ $a -lt "9" ]; do
        let a++
        echo "[${a}] kk +1"
        sleep 1
    done
    echo "安装结束..."
    echo "------------------------------------------------"
    sleep 1
    source /etc/profile &>/dev/null
    cd &>/dev/null
    echo "[现在开始可以使用MGR命令使用果仁烤面筋了!]"
    sleep 1
    echo "[如果环境变量不生效,请手动执行命令:sourece /etc/profile]"
    sleep 1
    echo '[笔记存放路径在:/usr/Grk/DB目录]'
}
function Csh_js() {
    #设置主机名
    host_name="QMOS-js"
    # 设置DNS
    dnsaY=DNS1=114.114.114.114
    dnsbY=DNS2=8.8.8.8

    # 清除屏幕
    clear
    # 开始初始化服务器
    echo "======================="
    echo " 开始极速初始化服务器..."
    echo " 全程将持续10秒左右..."
    echo "======================="

    # 禁用防火墙
    systemctl disable firewalld &>/dev/null

    # 修改SELinux配置文件，禁用SELinux
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config &>/dev/null
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux &>/dev/null

    # 设置主机名
    hostnamectl set-hostname $host_name

    # 获取网卡名称
    wknameY=$(ls /etc/sysconfig/network-scripts/ | grep ifcfg-ens | cut -d'-' -f2)

    # 获取IP地址
    ipnameY=$(ip -f inet a show dev $wknameY | awk "/inet/{print $2}" | awk '{print $2}' | cut -d'/' -f1)

    # 安装net-tools
    yum -y install net-tools &>/dev/null

    # 删除旧的网卡配置文件
    rm -rf /etc/sysconfig/network-scripts/ifcfg-$wknameY &>/dev/null

    # 获取默认网关
    wgnameY=$(route -n | grep '^0.0.0.0' | awk '{print $2}')

    # 创建新的网卡配置文件
    cd /etc/sysconfig/network-scripts/
    cat >ifcfg-$wknameY <<EOF
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="none"
DEFROUTE="yes"
NAME="$wknameY"
DEVICE="$wknameY"
ONBOOT="yes"
IPADDR=$ipnameY
PREFIX=24
GATEWAY=$wgnameY
$dnsaY
$dnsbY
EOF
    # 返回根目录
    cd /root &>/dev/null

    #重启网卡
    systemctl restart network

    #下载vim编辑器 函数
    vimQM

    #设置全局启用服务
    clear
    systemqm
    # 初始化服务器成功提示
    echo "==============================="
    echo "  极速初始化服务器成功，已重启..."
    echo "==============================="
    # 重启服务器
    reboot
}
function Fs_g() {
    clear
    #空闲内存
    Fr=$(free -h | awk 'NR==2{print $4}')
    #已用内存
    Us=$(free -h | awk 'NR==2{print $3}')
    #系统存储空间
    Us_system=$(df -Th | grep /dev/ | awk '/^\//{print $0}' | head -1 | awk '{print $4}')
    Us_free=$(df -Th | grep /dev/ | awk '/^\//{print $0}' | head -1 | awk '{print $5}')
    #cpu负载率
    cpu_s=$(uptime | awk -F'average:' '{print $2}')
    #当前登录用户
    Us_yh=$(echo $USER)
    #当前网卡IP
    Ip_status=$(echo $SSH_CONNECTION | awk '{print $3}')
    #登录服务器设备IP
    Ip_f=$(echo $SSH_CLIENT | awk '{print $1}')
    #网络情况
    Ip_p=$(
        ping -c1 -W1 baidu.com &>/dev/null
        echo $?
    )
    if [ $Ip_p = 0 ]; then
        wl=yes
    else
        wl=no
    fi
    #网络带宽
    RT_k=$(ls /etc/sysconfig/network-scripts/ | grep ifcfg-e | head -1 | cut -d'-' -f2)
    RX_status=$(netstat -i | grep "$RT_k" | awk 'NR==1{print $3}')
    TX_status=$(netstat -i | grep "$RT_k" | awk 'NR==1{print $7}')
    cat <<EOF
+-----------------------------------+
  [1]空闲内存:[$Fr]
  [2]已用内存:[$Us]
  [3]系统存储空间 
  已用:[$Us_system]
  空闲:[$Us_free]
  [4]cpu负载率:[$cpu_s]
  [5]当前登录用户:[$Us_yh]
  [6]当前网卡IP:[$Ip_status]
  [7]登录服务器设备IP:[$Ip_f]
  [8]网络情况:[$wl]
  [9]网络带宽 
  接收RX:[$RX_status]
  发送TX:[$TX_status]
+-----------------------------------+
EOF
}
function statusF() {
    clear
    Fs_g
    read -p "[刷新回复x|退出回复q]:" sF_num
    case $sF_num in
    x)
        statusF
        ;;
    q)
        Qc_QM
        ;;
    *)
        Rr_QM
        systemft
        ;;
    esac
}
function WYyum() {
    clear
    echo "---------------------------------------------------------------------------------------------------"
    echo "开始安装网易yum源..."
    rm -rf /etc/yum.repos.d/*
    cd /etc/yum.repos.d/
    curl -o CentOS7-Base-163.repo https://mirrors.163.com/.help/CentOS7-Base-163.repo &>/dev/null
    yum clean all &>/dev/null && yum makecache fast
    cd -
    clear
    echo "------------------------------------------网易yum源仓库----------------------------------------------"
    yum repolist
    echo "---------------------------------------------------------------------------------------------------"
    echo "网易yum源仓库安装完成..."
    sleep 3
}
function TXyum() {
    clear
    echo "---------------------------------------------------------------------------------------------------"
    echo "开始安装腾讯yum源..."
    rm -rf /etc/yum.repos.d/*
    cd /etc/yum.repos.d/
    curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.tencent.com/repo/centos7_base.repo &>/dev/null
    yum clean all &>/dev/null && yum makecache fast
    cd -
    clear
    echo "-----------------------------------------腾讯yum源仓库----------------------------------------------"
    yum repolist
    echo "---------------------------------------------------------------------------------------------------"
    echo "腾讯yum源仓库安装完成..."
    sleep 3
}
function SYJC() {
    #变量区修改内容看这里
    #设置主机名
    host_name="QMOS"
    # 设置DNS
    dnsaY=DNS1=114.114.114.114
    dnsbY=DNS2=8.8.8.8

    # 清除屏幕
    clear

    # 开始初始化服务器
    echo "======================"
    echo "  开始初始化服务器..."
    echo "  全程将持续15秒左右..."
    echo "======================"

    # 禁用防火墙
    systemctl disable firewalld &>/dev/null

    # 修改SELinux配置文件，禁用SELinux
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config &>/dev/null
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux &>/dev/null

    # 设置主机名
    hostnamectl set-hostname $host_name

    # 删除yum仓库配置文件
    rm -f /etc/yum.repos.d/* &>/dev/null || rm -rf /etc/yum.repos.d/* && echo "检测到/etc/yum.repos.d/下有目录，已删除"

    # 下载阿里源基础包
    curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo &>/dev/null

    # 下载阿里包加强包
    curl -o /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo &>/dev/null

    # 清除yum缓存
    yum clean all &>/dev/null && yum makecache fast &>/dev/null

    # 获取网卡名称
    wknameY=$(ls /etc/sysconfig/network-scripts/ | grep ifcfg-ens | cut -d'-' -f2)

    # 获取IP地址
    ipnameY=$(ip -f inet a show dev $wknameY | awk "/inet/{print $2}" | awk '{print $2}' | cut -d'/' -f1)

    # 删除旧的网卡配置文件
    rm -rf /etc/sysconfig/network-scripts/ifcfg-$wknameY &>/dev/null

    # 安装net-tools
    yum -y install net-tools &>/dev/null

    # 获取默认网关
    wgnameY=$(route -n | grep '^0.0.0.0' | awk '{print $2}')

    # 创建新的网卡配置文件
    cd /etc/sysconfig/network-scripts/
    cat >ifcfg-$wknameY <<EOF
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="none"
DEFROUTE="yes"
NAME="$wknameY"
DEVICE="$wknameY"
ONBOOT="yes"
IPADDR=$ipnameY
PREFIX=24
GATEWAY=$wgnameY
$dnsaY
$dnsbY
EOF
    # 返回根目录
    cd /root &>/dev/null

    # 重启网络服务
    systemctl restart network &>/dev/null

    # 安装lrzsz
    yum -y install lrzsz &>/dev/null

    # 安装ntpdate
    yum -y install ntpdate &>/dev/null
    ntpdate time.windows.com &>/dev/null

    # 安装cowsay
    yum -y install cowsay &>/dev/null

    # 安装bash-completion
    yum -y install bash-completion &>/dev/null

    #下载vim编辑器 函数
    vimQM

    #设置全局启用服务
    clear
    systemqm
    echo "==========================="
    echo " 初始化服务器成功，已重启..."
    echo "==========================="
    # 重启服务器
    reboot
}
function RCCSH() {
    #开机欢迎
    clear
    SHAN='\E[33;5m' #黄色闪烁警示
    RES='\E[0m'     # 清除颜色
    echo "+---------------------------------+"
    echo -e "  ${SHAN} 欢迎使用乔木的基础环境配置脚本3.0 ${RES}"
    echo "   CSDN:M乔木                  "
    echo "   邮箱: 2776617348@qq.com     "
    echo "+---------------------------------+"
    #关闭防火墙  函数fwset
    fwset
    #修改主机名 定义变量nameeJC 接收输入
    echo "开始修改主机名..."
    sleep 1
    read -p "请输入你想修改的主机名:" nameeJC
    hostnamectl set-hostname $nameeJC
    echo "主机名修改完毕，设置为$nameeJC"
    sleep 1
    #调用函数yumpz	yum仓库函数
    yumpz
    #固定IP gdIPD函数
    gdIPD
    sleep 1
    #下载传文件服务
    clear
    sleep 1
    echo "开始下载配置命令包并同步网络时间..."
    sleep 1
    echo "下载时间根据网络的不同速度也不同,请耐心等待..."
    yum -y install lrzsz &>/dev/null
    #校准时间
    yum -y install ntpdate &>/dev/null
    ntpdate time.windows.com &>/dev/null
    #下载cowsay
    yum -y install cowsay &>/dev/null
    #下载扩展tab补全包
    yum -y install bash-completion &>/dev/null
    #下载vim编辑器 函数
    vimQM
    #下载wget下载工具
    yum -y install wget &>/dev/null
    #下载网络工具包
    yum -y install net-tools &>/dev/null
    #下载unzip解压工具
    yum -y install unzip &>/dev/null
    echo "下载结束 同步网络时间成功"
    #shell脚本语法检测
    yum -y install ShellCheck &>/dev/null
    
    #设置全局启用
    clear
    systemqm
    #设置开机提示
    read -p "请选择是否设置开机提示[y|n]:" KJts
    case $KJts in
    y)
        #开机设置提示
        hostTS

        echo "+----------------------------+"
        echo -e "  ${SHAN} 配置结束即将重启... ${RES}"
        echo "   CSDN:M乔木                "
        echo "   邮箱: 2776617348@qq.com   "
        echo -e "  ${SHAN} 欢迎下次使用! ${RES}"
        echo "+----------------------------+"
        #重启程序结束
        reboot
        ;;
    n)
        sleep 1
        echo "+---------------------------+"
        echo -e "  ${SHAN} 配置结束即将重启... ${RES}"
        echo "   CSDN:M乔木               "
        echo "   邮箱: 2776617348@qq.com   "
        echo -e "  ${SHAN} 欢迎下次使用! ${RES}"
        echo "+---------------------------+"
        #重启程序结束
        reboot
        ;;
    *)
        echo "================="
        echo " 输入错误,已重启!"
        echo "================="
        reboot
        ;;
    esac
}
function vimQM() {
    echo "正在下载vim文本编辑器..."
    yum -y install vim &>/dev/null
    echo 'autocmd BufNewFile *.sh exec ":call AddShell()"
function  AddShell()
 call append(0,"#!/usr/bin/bash                ")
 call append(1,"#CSDN :M乔木 ")
 call append(2,"#Email:2776617348@qq.com ")
 call append(3,"#解释器:这是一个shell脚本    ")
endfunction' >>/etc/vimrc
    echo 'autocmd BufNewFile *.txt exec ":call AddTxt()"
function  AddTxt()
 call append(0,"#CSDN :M乔木                 ")
 call append(1,"#Email:2776617348@qq.com   ")
 call append(2,"#解释器:这是一个txt文件       ")
endfunction' >>/etc/vimrc
    echo 'autocmd BufNewFile *.md exec ":call AddMd()"
function  AddMd()
 call append(0,"#CSDN :M乔木                 ")
 call append(1,"#Email:2776617348@qq.com    ")
 call append(2,"#解释器:这是一个md文件        ")
endfunction' >>/etc/vimrc
    echo "安装成功已退出"
}
function dlJQ() {
    clear
    id1Y=$(cat /opt/QMOSjQ/jQ1/Y 2>/dev/null)
    id1M=$(cat /opt/QMOSjQ/jQ1/M 2>/dev/null)
    id1IP=$(cat /opt/QMOSjQ/jQ1/IP 2>/dev/null)

    id2Y=$(cat /opt/QMOSjQ/jQ2/Y 2>/dev/null)
    id2M=$(cat /opt/QMOSjQ/jQ2/M 2>/dev/null)
    id2IP=$(cat /opt/QMOSjQ/jQ2/IP 2>/dev/null)

    id3Y=$(cat /opt/QMOSjQ/jQ3/Y 2>/dev/null)
    id3M=$(cat /opt/QMOSjQ/jQ3/M 2>/dev/null)
    id3IP=$(cat /opt/QMOSjQ/jQ3/IP 2>/dev/null)

    id4Y=$(cat /opt/QMOSjQ/jQ4/Y 2>/dev/null)
    id4M=$(cat /opt/QMOSjQ/jQ4/M 2>/dev/null)
    id4IP=$(cat /opt/QMOSjQ/jQ4/IP 2>/dev/null)

    id5Y=$(cat /opt/QMOSjQ/jQ5/Y 2>/dev/null)
    id5M=$(cat /opt/QMOSjQ/jQ5/M 2>/dev/null)
    id5IP=$(cat /opt/QMOSjQ/jQ5/IP 2>/dev/null)

    id6Y=$(cat /opt/QMOSjQ/jQ6/Y 2>/dev/null)
    id6M=$(cat /opt/QMOSjQ/jQ6/M 2>/dev/null)
    id6IP=$(cat /opt/QMOSjQ/jQ6/IP 2>/dev/null)

    id7Y=$(cat /opt/QMOSjQ/jQ7/Y 2>/dev/null)
    id7M=$(cat /opt/QMOSjQ/jQ7/M 2>/dev/null)
    id7IP=$(cat /opt/QMOSjQ/jQ7/IP 2>/dev/null)

    id8Y=$(cat /opt/QMOSjQ/jQ8/Y 2>/dev/null)
    id8M=$(cat /opt/QMOSjQ/jQ8/M 2>/dev/null)
    id8IP=$(cat /opt/QMOSjQ/jQ8/IP 2>/dev/null)

    id9Y=$(cat /opt/QMOSjQ/jQ9/Y 2>/dev/null)
    id9M=$(cat /opt/QMOSjQ/jQ9/M 2>/dev/null)
    id9IP=$(cat /opt/QMOSjQ/jQ9/IP 2>/dev/null)

    id0Y=$(cat /opt/QMOSjQ/jQ0/Y 2>/dev/null)
    id0M=$(cat /opt/QMOSjQ/jQ0/M 2>/dev/null)
    id0IP=$(cat /opt/QMOSjQ/jQ0/IP 2>/dev/null)

    cat <<EOF
+---------------------------------+
            Jump Server                    
+---------------------------------+  
    [0]IP:${id0IP}
    [1]IP:${id1IP}
    [2]IP:${id2IP}
    [3]IP:${id3IP}
    [4]IP:${id4IP}
    [5]IP:${id5IP}
    [6]IP:${id6IP}
    [7]IP:${id7IP}
    [8]IP:${id8IP}
    [9]IP:${id9IP}
+---------------------------------+
EOF
}
function systemqm() {
        echo 'export PATH=/root/QM' >>/etc/profile
	sed -i 's/QM/QM:$PATH/' /etc/profile
	source  /etc/profile 
	echo "已设置全局启用本程序!"
}
function zz_ll() {
    clear
    cat <<EOF
+---------------------------+
         作者信息
+---------------------------+
  CSDN:  M乔木               
  mail:  2776617348@qq.com  
+---------------------------+
EOF
    read -p "输入q退出:" zzname
    case $zzname in
    q)
        Qc_QM
        ;;
    *)
        Rr_QM
        menus
        ;;
    esac
}
function qhnetw() {
    clear     # 清除屏幕
    cat <<EOF # 输出菜单内容
+-----------------------+
  [1]有线网络---wired
  [2]无线网络---wireless
  [3]返回上级
  [q]退出程序
+-----------------------+
EOF

    read -p "请输入序列号:" networkid # 提示用户输入序列号
    case $networkid in          # 根据用户输入的序列号执行相应的操作
    1)
        echo "开始切换有线网络..." # 输出提示信息
        wfo=$(ls /etc/sysconfig/network-scripts/ | grep ifcfg- | head -1 | cut -d- -f2)
        sed -i 's/BOOTPROTO="dhcp"/BOOTPROTO="none"/' /etc/sysconfig/network-scripts/ifcfg-$wfo # 修改配置文件，禁用DHCP
        systemctl restart network                                                               # 重启网络服务
        wiredid=$(ip a | grep $wfo | grep 10 | awk '/inet/{print $2}' | awk -F"/" '{print $1}') # 获取当前有线网络IP地址
        echo "当前最新ip为:$wiredid"                                                                 # 输出当前IP地址
        exit 0                                                                                  # 退出函数
        ;;
    2)
        echo "开始切换无线网络..." # 输出提示信息
        wfo=$(ls /etc/sysconfig/network-scripts/ | grep ifcfg- | head -1 | cut -d- -f2)
        sed -i 's/BOOTPROTO="none"/BOOTPROTO="dhcp"/' /etc/sysconfig/network-scripts/ifcfg-$wfo # 修改配置文件，启用DHCP
        systemctl restart network                                                               # 重启网络服务
        wirelessid=$(ip a | grep $wfo | grep 192 | awk '{print $2}' | awk -F"/" '{print $1}')   # 获取当前无线网络IP地址
        echo "当前最新ip为:$wirelessid"                                                              # 输出当前IP地址
        exit 0                                                                                  # 退出函数
        ;;
    3)
        systemset
        ;;
    q)
        Qc_QM
        ;;
    *)
        Rr_QM
        qhnetw
        ;;
    esac
}
function jqzh() {
    clear
    dlJQ #显示服务器列表
    read -p "请输入你要注册几号账号[回复q退出]:" idjqw
    case $idjqw in
    1)
        jq_z
        read -p "请输入你的服务器用户名:" namejq
        read -p "请输入你的服务器密码:" mmjq
        read -p "请输入你的服务器IP:" IPjq
        echo "$namejq" >/opt/QMOSjQ/jQ1/Y
        echo "$mmjq" >/opt/QMOSjQ/jQ1/M
        echo "$IPjq" >/opt/QMOSjQ/jQ1/IP
        ;;
    2)
        jq_z
        read -p "请输入你的服务器用户名:" namejq
        read -p "请输入你的服务器密码:" mmjq
        read -p "请输入你的服务器IP:" IPjq
        echo "$namejq" >/opt/QMOSjQ/jQ2/Y
        echo "$mmjq" >/opt/QMOSjQ/jQ2/M
        echo "$IPjq" >/opt/QMOSjQ/jQ2/IP
        ;;
    3)
        jq_z
        read -p "请输入你的服务器用户名:" namejq
        read -p "请输入你的服务器密码:" mmjq
        read -p "请输入你的服务器IP:" IPjq
        echo "$namejq" >/opt/QMOSjQ/jQ3/Y
        echo "$mmjq" >/opt/QMOSjQ/jQ3/M
        echo "$IPjq" >/opt/QMOSjQ/jQ3/IP
        ;;
    4)
        jq_z
        read -p "请输入你的服务器用户名:" namejq
        read -p "请输入你的服务器密码:" mmjq
        read -p "请输入你的服务器IP:" IPjq
        echo "$namejq" >/opt/QMOSjQ/jQ4/Y
        echo "$mmjq" >/opt/QMOSjQ/jQ4/M
        echo "$IPjq" >/opt/QMOSjQ/jQ4/IP
        ;;
    5)
        jq_z
        read -p "请输入你的服务器用户名:" namejq
        read -p "请输入你的服务器密码:" mmjq
        read -p "请输入你的服务器IP:" IPjq
        echo "$namejq" >/opt/QMOSjQ/jQ5/Y
        echo "$mmjq" >/opt/QMOSjQ/jQ5/M
        echo "$IPjq" >/opt/QMOSjQ/jQ5/IP
        ;;
    6)
        jq_z
        read -p "请输入你的服务器用户名:" namejq
        read -p "请输入你的服务器密码:" mmjq
        read -p "请输入你的服务器IP:" IPjq
        echo "$namejq" >/opt/QMOSjQ/jQ6/Y
        echo "$mmjq" >/opt/QMOSjQ/jQ6/M
        echo "$IPjq" >/opt/QMOSjQ/jQ6/IP
        ;;
    7)
        jq_z
        read -p "请输入你的服务器用户名:" namejq
        read -p "请输入你的服务器密码:" mmjq
        read -p "请输入你的服务器IP:" IPjq
        echo "$namejq" >/opt/QMOSjQ/jQ7/Y
        echo "$mmjq" >/opt/QMOSjQ/jQ7/M
        echo "$IPjq" >/opt/QMOSjQ/jQ7/IP
        ;;
    8)
        jq_z
        read -p "请输入你的服务器用户名:" namejq
        read -p "请输入你的服务器密码:" mmjq
        read -p "请输入你的服务器IP:" IPjq
        echo "$namejq" >/opt/QMOSjQ/jQ8/Y
        echo "$mmjq" >/opt/QMOSjQ/jQ8/M
        echo "$IPjq" >/opt/QMOSjQ/jQ8/IP
        ;;
    9)
        jq_z
        read -p "请输入你的服务器用户名:" namejq
        read -p "请输入你的服务器密码:" mmjq
        read -p "请输入你的服务器IP:" IPjq
        echo "$namejq" >/opt/QMOSjQ/jQ9/Y
        echo "$mmjq" >/opt/QMOSjQ/jQ9/M
        echo "$IPjq" >/opt/QMOSjQ/jQ9/IP
        ;;
    0)
        jq_z
        read -p "请输入你的服务器用户名:" namejq
        read -p "请输入你的服务器密码:" mmjq
        read -p "请输入你的服务器IP:" IPjq
        echo "$namejq" >/opt/QMOSjQ/jQ0/Y
        echo "$mmjq" >/opt/QMOSjQ/jQ0/M
        echo "$IPjq" >/opt/QMOSjQ/jQ0/IP
        ;;
    q)
        echo "已退出..."
        sleep 1
        jqfun
        ;;
    *)
        Rr_QM
        jqzh
        ;;
    esac
    echo "注册成功!"
    sleep 1
    jqfun
}
function jqjm() {
    dlJQ
    read -p "请输入想登录的服务器的序列号[输入q退出]:" jqnameid
    case $jqnameid in
    0)
        sshpass -p${id0M} ssh -o StrictHostKeyChecking=no ${id0Y}@${id0IP} 2>/dev/null
        jq_d
        ;;
    1)
        sshpass -p${id1M} ssh -o StrictHostKeyChecking=no ${id1Y}@${id1IP} 2>/dev/null
        jq_d
        ;;
    2)
        sshpass -p${id2M} ssh -o StrictHostKeyChecking=no ${id2Y}@${id2IP} 2>/dev/null
        jq_d
        ;;
    3)
        sshpass -p${id3M} ssh -o StrictHostKeyChecking=no ${id3Y}@${id3IP} 2>/dev/null
        jq_d
        ;;
    4)
        sshpass -p${id4M} ssh -o StrictHostKeyChecking=no ${id4Y}@${id4IP} 2>/dev/null
        jq_d
        ;;
    5)
        sshpass -p${id5M} ssh -o StrictHostKeyChecking=no ${id5Y}@${id5IP} 2>/dev/null
        jq_d
        ;;
    6)
        sshpass -p${id6M} ssh -o StrictHostKeyChecking=no ${id6Y}@${id6IP} 2>/dev/null
        jq_d
        ;;
    7)
        sshpass -p${id7M} ssh -o StrictHostKeyChecking=no ${id7Y}@${id7IP} 2>/dev/null
        jq_d
        ;;
    8)
        sshpass -p${id8M} ssh -o StrictHostKeyChecking=no ${id8Y}@${id8IP} 2>/dev/null
        jq_d
        ;;
    9)
        sshpass -p${id9M} ssh -o StrictHostKeyChecking=no ${id9Y}@${id9IP} 2>/dev/null
        jq_d
        ;;
    q)
        echo "已退出..."
        sleep 1
        jqfun
        ;;
    *)
        Rr_QM
        jqjm
        ;;
    esac
}
function jqfun() {
    clear
    cat <<EOF
+---------------+
   [1]环境部署
   [2]注册资产
   [3]登录资产
   [4]清理资产
   [5]返回上级
   [q]退出程序
+---------------+
EOF
    read -p "请输入序列号:" jqid
    case $jqid in
    1)
        clear
        echo "------------------------------------------------------------"
        echo "[1]开始检测环境是否支持堡垒机运行..."
        jqnum=$(
            rpm -qa | grep sshpass &>/dev/null
            echo $?
        )
        jqnumk=$(
            ls /opt | grep QMOSjQ &>/dev/null
            echo $?
        )
        if [ $jqnum -eq 0 ]; then
            echo "[2]环境支持堡垒机运行..."
        else
            echo "[2]环境不支持运行 开始配置..."
            yum -y install sshpass &>/dev/null
        fi
        if [ $jqnumk -eq 0 ]; then
            echo "[3]正在运行..."
        else
            echo "[3]开始建立堡垒机运行所需文件..."
            mkdir -p /opt/QMOSjQ/{jQ1,jQ2,jQ3,jQ4,jQ5,jQ6,jQ7,jQ8,jQ9,jQ0}
            touch /opt/QMOSjQ/jQ1/{Y,M,IP}
            touch /opt/QMOSjQ/jQ2/{Y,M,IP}
            touch /opt/QMOSjQ/jQ3/{Y,M,IP}
            touch /opt/QMOSjQ/jQ4/{Y,M,IP}
            touch /opt/QMOSjQ/jQ5/{Y,M,IP}
            touch /opt/QMOSjQ/jQ6/{Y,M,IP}
            touch /opt/QMOSjQ/jQ7/{Y,M,IP}
            touch /opt/QMOSjQ/jQ8/{Y,M,IP}
            touch /opt/QMOSjQ/jQ9/{Y,M,IP}
            touch /opt/QMOSjQ/jQ0/{Y,M,IP}
        fi
        echo "[4]检测结束..."
        echo "------------------------------------------------------------"
        sleep 1
        jqfun
        ;;
    2)
        jq_f
        jqzh
        ;;
    3)
        jq_f
        jqjm
        ;;
    4)
        clear
        echo "------------------------------------------------------------"
        echo "[1]开始清理资产..."
        yum -y remove sshpass &>/dev/null
        rm -rf /opt/QMOSjQ &>/dev/null
        sleep 1
        echo "[2]清理完毕..."
        echo "------------------------------------------------------------"
        sleep 1
        jqfun
        ;;
    5)
        menus
        ;;
    q)
        Qc_QM
        ;;
    *)
        Rr_QM
        jqfun
        ;;
    esac
}
function pingip() {
    clear
    echo "========================"
    echo " 正在运行程序,请稍等片刻..."
    echo "========================"
    >/opt/a.md
    >/opt/b.md
    Wk_Ip=$(ls /etc/sysconfig/network-scripts/ | awk '/ifcfg/{print}' | cut -d- -f2 | head -1)
    Ip_Ping=$(ip -f inet a show dev $Wk_Ip | awk "/inet/{print $2}" | awk '{print $2}' | cut -d'/' -f1 | cut -d'.' -f1-3)
    for i in {1..254}; do
        {
            ping -W1 -c3 ${Ip_Ping}.${i} &>/dev/null
            if [ $? -eq 0 ]; then
                echo "${Ip_Ping}.${i} 此ip繁忙" >>/opt/b.md
            else
                echo "${Ip_Ping}.${i} 此ip空闲" >>/opt/a.md
            fi
        } &
    done
    sleep 3
    read -p "请选择查看离线IP还是在线iP[1|2]" IPnumxz
    case $IPnumxz in
    1)
        clear
        echo "========================="
        echo " 已显示前十条离线ip"
        cat /opt/a.md | head
        echo "========================="
        read -p "回复q退出" ping_F
        case $ping_F in
        q)
            rm -f /opt/a.md
            rm -f /opt/b.md
            echo "已退出..."
            sleep 1
            onekey
            ;;
        *)
            rm -f /opt/a.md
            rm -f /opt/b.md
            echo "输入错误已退出..."
            sleep 1
            onekey
            ;;
        esac
        ;;
    2)
        clear
        echo "========================="
        echo " 已显示前十条在线ip"
        cat /opt/b.md | head
        echo "========================="
        read -p "回复q退出" ping_F
        case $ping_F in
        q)
            rm -f /opt/a.md
            rm -f /opt/b.md
            echo "已退出..."
            sleep 1
            onekey
            ;;
        *)
            rm -f /opt/a.md
            rm -f /opt/b.md
            echo "输入错误已退出..."
            sleep 1
            onekey
            ;;
        esac
        ;;
    *)
        Rr_QM
        pingip
        ;;
    esac
}
function Y_BJ() {
    clear
    cat <<EOF
+---------------+
  [1]开启YML书写
  [2]关闭YML书写
  [q]退出程序
+---------------+
EOF
    read -p "请输入序号:" Y_sz
    case $Y_sz in
    1)
        clear
        echo "----------------------------------"
        echo "[1]开始配置vim编辑器..."
        sleep 1
        echo "[2]正在写入配置文件..."
        sleep 1
        echo 'set paste nu et ts=2 sw=2 cuc autoindent' >>/etc/vimrc
        echo "[3]YML格式已启用!"
        echo "----------------------------------"
        sleep 1
        onekey
        ;;
    2)
        clear
        echo "----------------------------------"
        echo "[1]开始打开vim编辑器..."
        sleep 1
        echo "[2]正在删除YML书写配置..."
        sleep 1
        sed -i '/set nu et ts=2 sw=2 cuc autoindent/d' /etc/vimrc
        echo "[3]YML格式已关闭!"
        echo "----------------------------------"
        sleep 1
        onekey
        ;;
    q)
        Qc_QM
        ;;
    *)
        Rr_QM
        Y_BJ
        ;;
    esac
}
function onekey() {
    clear
    cat <<EOF
+----------------------+
  [1]vim编辑器--YML模式      
  [2]查看当前网段IP情况  
  [3]切换系统提示到中文
  [4]查看防火墙selinux 
  [5]推送镜像到aliyun       
  [6]安全密码生成器
  [7]监控服务后台进程
  [8]docker镜像管理
  [9]docker空间管理
  [10]返回主菜单         
  [q]退出程序                
+----------------------+
EOF
    read -p "请输入序列号:" numkey
    case $numkey in
    1)
        Y_BJ
        ;;
    2)
        pingip
        ;;
    3)
        clear
        echo "==================="
        echo " 切换系统提示到中文"
        echo "==================="
        sleep 1
        export LANG=zh_CN.UTF-8 &>/dev/null
        onekey
        ;;
    4)
        getenforce && systemctl status firewalld
        sleep 3
        onekey
        ;;
    5)
        JX_d
        JX
        JX_z
        ;;
    6)
        passwdbcm
        onekey
        ;;
    7)
	dH_QM
	;;
    8)
	Dk_sl
	;;
    9)
	dd_docker
	;;
    10)
        menus
        ;;
    q)
        Qc_QM
        ;;
    *)
        Rr_QM
        onekey
        ;;
    esac
}
function Apachefunct() {
    clear
    echo "------------------------------------------------------------"
    echo "[1]检测环境..."
    sleep 1
    #调用函数 关闭防火墙
    fwset
    #安装阿帕奇
    sleep 1
    echo "[2]开始安装阿帕奇服务器 本次安转将持续两分钟请耐心等待..."
    yum -y install httpd &>/dev/null
    #启动阿帕奇
    systemctl start httpd
    echo "[3]apache安装成功! 现在可以使用system工具来使用管理PHP了!"
    echo "------------------------------------------------------------"
    sleep 1
}
function PHPfunct() {
    clear
    echo "------------------------------------------------------------"
    echo "[1]开始安装PHP..."
    sleep 1
    echo "[2]本次安装将根据网速的情况持续2分钟到五分钟左右,请耐心等待..."
    yum -y install php php-fpm &>/dev/null
    echo "[3]PHP安装成功! 现在可以使用system工具来使用管理PHP了!"
    echo "------------------------------------------------------------"
    sleep 1
}
function MySqlfunct() {
    clear
    echo "---------------------------------------------------------------------"
    echo '[1]准备安装数据库,全程根据网络情况持续1~5分钟左右,请耐心等待...'
    sleep 1
    echo '[2]开始清理环境...'
    yum erase mariadb mariadb-server mariadb-libs mariadb-devel -y &>/dev/null
    userdel -r mysql &>/dev/null
    rm -rf /etc/my* &>/dev/null
    rm -rf /var/lib/mysql &>/dev/null
    rm -rf /usr/bin/mysql &>/dev/null
    yum -y erase $(rpm -qa | egrep "mysql|mariadb") &>/dev/null
    Se_gb=$(getenforce)
    fw_gd=$(systemctl status firewalld | awk '/Active:/{print $2}')
    echo "[3]正在检查防火墙selinux..."
    sleep 1
    if [ $Se_gb != Disabled -a $fw_gd != inactive ]; then
        echo '[4]防火墙和selinux未关闭,正在关闭...'
        systemctl disable firewalld &>/dev/null
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux &>/dev/null
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config &>/dev/null
        echo "[防火墙和selinux已关闭,请在安装结束重启服务器以生效配置]"
    else
        echo '[4]防火墙和selinux已关闭,正在继续...'
    fi
    sleep 1
    echo '[5]正在下载mysqlyum源...'
    yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-7.noarch.rpm &>/dev/null

    echo '[6]正在安装mysql...'
    yum install -y mysql-community-server --enablerepo mysql57-community --disablerepo mysql80-community &>/dev/null
    yum -y groupinstall "Development Tools" &>/dev/null

    echo '[7]正在配置mysql...'
    yum -y install yum-utils &>/dev/null
    yum-config-manager --disable mysql80-community &>/dev/null
    yum-config-manager --enable mysql57-community &>/dev/null

    echo '[8]正在启动mysql...'
    systemctl start mysqld &>/dev/null

    echo '[9]正在设置密码,请稍后...'
    num_az=$(awk '/temporary password/{p=$NF}END{print p}' /var/log/mysqld.log)
    echo 'validate-password=OFF' >>/etc/my.cnf

    systemctl restart mysqld &>/dev/null
    read -p '请输入新密码:' passwdx
    mysqladmin -uroot -p"$num_az" password "$passwdx" &>/dev/null

    echo "[10]安装完成,密码已设置完成为:$passwdx"
    echo "[11]密码已保存到/mysql_passwd.txt目录下"
    echo "mysql57密码为:${passwdx}" >/mysql_passwd.txt
    echo "---------------------------------------------------------------------"
    sleep 2
}
function NGfunct() {
    clear
    echo "------------------------------------------------------------"
    read -p "安装前是否准备环境[y|n]:" NGfunctjc
    case $NGfunctjc in
    y)
        sleep 1
        ;;
    n)
        echo "请前往系统设置[关闭防火墙|校准时间|固定IP]"
        sleep 2
        systemft
        ;;
    *)
        Rr_QM
        NGfunct
        ;;
    esac
    echo "[1]开始安装Nginx..."
    yum -y install nginx &>/dev/null
    echo "[2]安装完成,开始配置..."
    sleep 1
    echo "[3]现在可以使用system工具开始管理Nginx了"
    sleep 1
    echo "[4]支持操作 systenctl[start|restart|stop|status]Nginx"
    echo "------------------------------------------------------------"
    sleep 1
}
function JCset() {
    clear
    echo "=================="
    echo "  开始初始化系统..."
    echo "=================="
    sleep 1
    clear
    cat <<EOF
+-----------------+
  [1]日常使用初始化
  [2]实验机初始化
  [3]极速初始化
  [q]回复q退出
+-----------------+
EOF
    read -p "请输入序列号选择:" JCrs
    case $JCrs in
    1)
        RCCSH
        ;;
    2)
        SYJC
        ;;
    3)
        Csh_js
        ;;
    q)
        Qc_QM
        ;;
    *)
        Rr_QM
        JCset
        ;;
    esac
}
function fwset() {
    echo "[1]开始关闭防火墙..."
    sleep 1
    systemctl disable firewalld &>/dev/null
    echo "[2]防火墙已关闭..."
    sleep 1
    #关闭selinux
    echo "[3]开始关闭selinux..."
    sleep 1
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
    echo "[4]selinux已关闭..."
    sleep 1
    echo "[5]请在稍后重启服务器 否则关闭的服务不会生效"
    sleep 2
}
function hostTS() {
    echo "[1]开始设置开机提示..."
    sleep 1
    read -p "[2]请输入你想要设置的开机欢迎词:" TSname
    cd /etc/profile.d &>/dev/null
    sleep 1
    echo "[3]开始生成开机提示文件..."
    cat >>kj.sh <<EOF
#!/usr/bin/bash
        #登录欢迎
        cowsay -f telebears "$TSname"
        #结束
        echo "[欢迎回来!]"  
EOF
    echo "[4]开机提示设置成功:$TSname"
}
function hostnames() {
    echo "[1]开始修改主机名..."
    sleep 1
    read -p "[2]请输入你想修改的主机名:" nameht
    hostnamectl set-hostname $nameht
    echo "[3]主机名修改完毕，设置为:$nameht"
    sleep 1
}
function yumpz() {
    clear
    cat <<EOF
+--------------+
   yum仓库V2.0
+--------------+
   [1]局域仓库
   [2]阿里仓库
   [3]网易仓库 
   [4]腾讯仓库
   [q]退出程序  
+--------------+
EOF
    read -p "请输入你要部署的仓库序号:" pzcurl
    case $pzcurl in
    1)
        echo "[1]开始配置yum源文件..."
        sleep 1
        read -p "[2]请输入你想连接的yum仓库ip地址" yumpzss
        rm -f /etc/yum.repos.d/* &>/dev/null || rm -rf /etc/yum.repos.d/* && echo "检测到/etc/yum.repos.d/下有目录，已删除"
        cd /etc/yum.repos.d/
        echo "[3]开始创建yum源仓库文件..."
        cat >>jc.repo <<EOF
[base]
name=base
baseurl=http://$yumpzss/base
gpgcheck=0
enable=1

[epel]
name=epel
baseurl=http://$yumpzss/epel
gpgcheck=0
enable=1

[extras]
name=extras
baseurl=http://$yumpzss/extras
enable=1
gpgcheck=0

[updates]
name=updates
baseurl=http://$yumpzss/updates
gpgcheck=0
enable=1

[remi-safe]
name=remi-safe
baseurl=http://$yumpzss/remi-safe
gpgcheck=0
enable=1

[mysql57]
name=mysql57
baseurl=http://$yumpzss/mysql57
gpgcheck=0
enable=1 
EOF
        echo "[4]配置yum源文件结束..."
        sleep 1
        #启动动画
        echo "[5]即将开始配置yum缓存..."
        sleep 1
        #清理缓存
        echo "[6]开始清理本机yum缓存..."
        yum clean all &>/dev/null
        echo "[7]清理完毕..."
        sleep 1
        echo "[8]开始生成本地缓存..."
        yum makecache &>/dev/null
        echo "[9]缓存生成完毕..."
        #列出yum包数
        sleep 1
        echo "[10]即将检索本次安装yun包总数..."
        yum repolist
        sleep 2
        ;;
    2)
        clear
        echo "--------------------------------------------------------------------------------------------------"
        echo "[1]开始配置阿里yum源文件..."
        sleep 1
        echo "[2]开始清理环境..."
        rm -f /etc/yum.repos.d/* &>/dev/null 
        if [ $? -ne 0 ];then
        echo "[?]检测到/etc/yum.repos.d/下有目录!"
        sleep 1
        echo "[!]已清理!"
        rm -rf /etc/yum.repos.d/*  &>/dev/null
        fi
        #阿里源基础包下载
        curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo &>/dev/null
        #阿里包加强包下载
        curl -o /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo &>/dev/null
        echo "[3]源文件下载完成!"
        sleep 1
        echo "[4]配置yum源文件结束..."
        sleep 1
        #启动动画
        echo "[5]即将开始配置yum缓存..."
        sleep 1
        #清理缓存
        echo "[6]开始清理本机yum缓存..."
        yum clean all &>/dev/null
        echo "[7]清理完毕..."
        sleep 1
        echo "[8]开始生成本地缓存..."
        yum makecache fast &>/dev/null
        echo "[9]缓存生成完毕..."
        #列出yum包数
        sleep 1
        echo "[10]即将检索本次安装yun包总数..."
        clear
        echo "-----------------------------------------阿里yum源仓库----------------------------------------------"
        yum repolist
        echo "--------------------------------------------------------------------------------------------------"
        echo "[11]阿里仓库安装结束..."
        sleep 3
        ;;
    3)
        WYyum
        ;;
    4)
        TXyum
        ;;
    q)
        Qc_QM
        ;;
    *)
        Rr_QM
        yumpz
        ;;
    esac
}
function gdIPD() {
    clear
    SHAN='\E[33;5m' #黄色闪烁警示
    RES='\E[0m'     # 清除颜色
    echo "+----------------------------+"
    echo -e "     ${SHAN} 欢迎使用固定IP程序 ${RES}"
    echo "   CSDN:M乔木             "
    echo "   邮箱: 2776617348@qq.com  "
    echo "+----------------------------+"
    echo "[1]正在配置网卡，请稍后..."
    sleep 1
    #获取当前网卡配置文件
    echo "[2]获取当前网卡配置文件"
    sleep 1
    #wkname=`ls /etc/sysconfig/network-scripts/ | grep ifcfg-ens | cut -d'-' -f2`
    wkname=$(ls /etc/sysconfig/network-scripts/ | awk '/ifcfg/{print}' | cut -d- -f2 | head -1)
    #获取IP
    echo "[3]获取IP"
    sleep 1
    ipname=$(ip -f inet a show dev $wkname | awk "/inet/{print $2}" | awk '{print $2}' | cut -d'/' -f1)
    #删除原有的网卡配置文件
    echo "[4]删除原有的网卡配置文件"
    sleep 1
    rm -rf /etc/sysconfig/network-scripts/ifcfg-$wkname
    #设置判断选择网关
    echo "[5]正在获取网关..."
    yum -y install net-tools &>/dev/null
    wgname=$(route -n | grep '^0.0.0.0' | awk '{print $2}')

    #设置判断开启DNS
    read -p "[6]是否开启DNS:[y|n] " dnsname
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
    sleep 1
    #创建新的网卡配置文件
    cd /etc/sysconfig/network-scripts/
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
    cd /root
    #重启网络服务
    echo "[7]重启网络服务..."
    systemctl restart network
    #结束配置
    echo "+--------------------------------+"
    echo -e "   ${SHAN} 本次配置结束! ${RES}    "
    echo "   CSDN:    M乔木                 "
    echo "   邮箱:    2776617348@qq.com     "
    echo -e "   ${SHAN} 欢迎下次使用! ${RES}    "
    echo "+--------------------------------+"
}
function systemset() {
    clear
    cat <<EOF
+--------------------+
  [1]设置固定IP                     
  [2]设置校准时间                    
  [3]部署yum仓库                 
  [4]设置主机名                  
  [5]设置开机提示
  [6]设置网络适配               
  [7]关闭防火墙SeLinux
  [8]初始化服务器    
  [9]返回主菜单                  
  [q]回复q退出                   
+--------------------+
EOF
    read -p "请输入序列号:" setname
    case $setname in
    1)
        gdIPD
        systemset
        ;;
    2)
        echo "开始校准时间..."
        yum -y install ntpdate &>/dev/null
        ntpdate time.windows.com &>/dev/null
        sjs=$(date)
        echo "时间校准成功"
        echo "当前时间为:"$sjs
        sleep 2
        systemset
        ;;
    3)
        yumpz
        systemset
        ;;
    4)
        hostnames
        systemset
        ;;
    5)
        hostTS
        sleep 2
        systemset
        ;;
    6)
        qhnetw
        ;;
    7)
        fwset
        systemset
        ;;
    8)
        JCset
        ;;
    9)
        menus
        ;;
    q)
        Qc_QM
        ;;
    *)
        Rr_QM
        systemset
        ;;
    esac
}
function systemft() {
    clear
    cat <<EOF
+----------------+
  [1]系统信息查询  
  [2]系统功能设置
  [3]设置全局使用  
  [4]返回主菜单    
  [q]退出程序  
+----------------+
EOF
    read -p "请输入序列号:" systemname
    case $systemname in
    1)
        statusF
        ;;
    2)
        systemset
        ;;
    3)
        systemqm
        sleep 1
        systemft
        ;;
    4)
        menus
        ;;
    q)
        Qc_QM
        ;;
    *)
        Rr_QM
        systemft
        ;;
    esac
}
function wbcg() {
    clear
    cat <<EOF
+--------------+
  [1]Nginx       
  [2]MySQL  
  [3]PHP-fpm      
  [4]Apache      
  [5]Redis
  [6]Docker
  [7]Zabbix-S
  [8]Zabbix-A
  [9]返回主菜单  
  [q]退出程序
+--------------+
EOF
    read -p "请输入序号:" wbcgid
    case $wbcgid in
    1)
        NGfunct
        ;;
    2)
        MySqlfunct
        ;;
    3)
        PHPfunct
        ;;
    4)
        Apachefunct
        ;;
    5)
        make_redis
        ;;
    6)
        Az_docker
        ;;
    7)
        make_ZBS
        ;;
    8)
        make_ZBA
        ;;
    9)
        menus
        ;;
    q)
        Qc_QM
        ;;
    *)
        Rr_QM
        wbcg
        ;;
    esac
    cat <<EOF
+-----------+
 [1]继续部署
 [q]退出程序
+-----------+
EOF
    read -p "请输入序列号:" numwzgn
    case $numwzgn in
    1)
        wbcg
        ;;
    q)
        Qc_QM
        ;;
    *)
        Rr_QM
        wbcg
        ;;
    esac
}
function passwdbcm() {
    clear
    echo "========================"
    echo " 开始生成随机安全密码..."
    echo "========================"
    nja=$(uuidgen | cut -d- -f1)
    njb=$(uuidgen | cut -d- -f2)
    njc=$RANDOM@
    njd=G$njb$nja$njc
    sleep 1
    echo "====================================="
    echo " 随机安全密码为:$njd"
    echo "====================================="
    echo "随机安全密码为:$njd 创建时间为:$(date +%F-%T)" >/sjpass.md
    sleep 1
    echo "======================================================"
    echo " 随机安全密码已生成,已存储到路径:/sjpass.md中,请妥善保管"
    echo "======================================================"
    sleep 3
}
function appstore() {
    clear
    cat <<EOF
+-------------------+
       应用商店        
+-------------------+
  [1]vim文本编辑器       
  [2]ntpdate校准时间
  [3]cowsay奶牛说        
  [4]Tab补全包           
  [5]wget下载工具        
  [6]网络工具包          
  [7]lrzsz工具  
  [8]unzip解压工具
  [9]果仁烤面筋记事本
  [10]shell语法检测         
  [11]返回主菜单                
  [q]退出程序        
+-------------------+
EOF
    read -p "请输入序号:" appnum
    case $appnum in
    1)
        vimQM
        sleep 1
        appstore
        ;;
    2)
        echo "开始下载ntpdate校准时间工具,并校准时间..."
        yum -y install ntpdate $ >/dev/null
        ntpdate time.windows.com &>/dev/null
        echo "安装成功已退出"
        sleep 1
        appstore
        ;;
    3)
        echo "开始下载cowsay..."
        yum -y install cowsay &>/dev/null
        echo "安装成功已退出"
        sleep 1
        appstore
        ;;
    4)
        echo "开始下载tab补全包..."
        yum -y install bash-completion &>/dev/null
        echo "安装成功已退出"
        sleep 1
        appstore
        ;;
    5)
        echo "开始下载wget工具..."
        yum -y install wget &>/dev/null
        echo "安装成功已退出"
        sleep 1
        appstore
        ;;
    6)
        echo "开始下载网络工具包..."
        yum -y install net-tools &>/dev/null
        echo "安装成功已退出"
        sleep 1
        appstore
        ;;
    7)
        echo "正在上下传文件工具..."
        yum -y install lrzsz &>/dev/null
        echo "安装成功已退出"
        sleep 1
        appstore
        ;;
    8)
        echo "正在unzip解压工具..."
        yum -y install unzip &>/dev/null
        echo "安装成功已退出"
        sleep 1
        appstore
        ;;
    9)
        make_MGR
        sleep 1
        appstore
        ;;
    10)
	echo "正在安装shell语法检测工具..."
	yum -y install ShellCheck &>/dev/null
	echo "安装成功已退出"
        sleep 1
        appstore	
	;;
    11)
        menus
        ;;
    q)
        Qc_QM
        ;;
    *)
        Rr_QM
        appstore
        ;;
    esac
}
function menus() {
    clear
    SHAN='\E[33;5m' #黄色闪烁警示
    RES='\E[0m'     # 清除颜色
    echo "+---------------+"
    echo -e "  ${SHAN}QiaoMuOS[3.0]${RES}"
    cat <<EOF
+---------------+
   [1]系统功能               
   [2]部署服务                
   [3]Jump堡垒                                
   [4]应用商店                
   [5]扩展功能               
   [6]联络作者                
   [q]退出程序                
+---------------+
EOF
    read -p "请输入序列号:" nova
    case $nova in
    1)
        systemft
        ;;
    2)
        wbcg
        ;;
    3)
        jqfun
        ;;
    4)
        appstore
        ;;
    5)
        onekey
        ;;
    6)
        zz_ll
        ;;
    q)
        Qc_QM
        ;;
    *)
        Rr_QM
        menus
        ;;
    esac
}
#====================================================
#调用显示主菜单 menus
      menus
