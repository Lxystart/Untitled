#!/bin/bash
#解锁网易云音乐客户端变灰歌曲
#Linxu初学者写的渣渣 整合脚本 第一次写，写的有点蠢  ---1802
#发行版本判断  使用的逗逼大佬的代码，膜拜大佬。
#https://github.com/ToyoDAdoubi/doubi
#项目地址:https://github.com/nondanee/UnblockNeteaseMusic
#Github：https://github.com/Lxystart
#https://github.com/nodesource/distributions
#实测 AWS Lightsail Debian 9.5 ; Ubuntu 18.04; 成功  Debian 8.5失败
#实测 阿里云 CentOS 7.3 ; Ubantu 16.04  成功    Debian 8.7失败
#实测 GCP Debian 9.7 成功
#Date:2019-04-27

clear
echo
#echo "#############################################################"  
echo "解锁网易云音乐客户端变灰歌曲                               "    
#echo "# Learn address:https://github.com/ToyoDAdoubi/doubi        #"
#echo "# Author: https://github.com/Lxystart                       #"
#echo "# Github: https://github.com/nondanee/UnblockNeteaseMusic   #"
echo " Last Date:   2019-04-27                                        "
#echo "#############################################################"  
echo

check_sys() {
    if [[ -f /etc/redhat-release ]]; then
        release="centos"
    elif cat /etc/issue | grep -q -E -i "debian"; then
        release="debian"
    elif cat /etc/issue | grep -q -E -i "ubuntu"; then
        release="ubuntu"
    elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
    elif cat /proc/version | grep -q -E -i "debian"; then
        release="debian"
    elif cat /proc/version | grep -q -E -i "ubuntu"; then
        release="ubuntu"
    elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
    fi
    #bit=`uname -m`
}
check_port() {
        echo -e '按Ctrl + C 取消执行脚本' | _color_ red invert
        echo
        echo -e '网络通畅的话2分钟左右完成，请耐心等待。' | _color_ green bold
        echo
        echo -e '支持Debian 9+  Ubuntu 16.04+  CentOS 7+'
        echo
        echo -e "请输入你要设置的网易云音乐的 端口 [10000-65535] " | _color_ cyan bold
        echo
    while true 
    do
        read -e -p "(默认端口: 10001):" port
        
        [[ -z "$port" ]] && port="10001"
        echo $((${port} + 0)) &>/dev/null
        if [[ $? -eq 0 ]]; then
            if [[ ${port} -ge 10000 ]] && [[ ${port} -le 65535 ]]; then
                echo
                echo "——————————————————————————————"
                echo -e "	端口设置为 : ${Red_background_prefix} ${port} ${Font_color_suffix}"
                echo "——————————————————————————————"
                echo
                break
            else
                echo -e "${Error} 请输入正确的数字 !" | _color_ red bold
            fi
        else
            echo -e "${Error} 请输入正确的数字 !"
        fi
    done
}
centos() {
    check_port
    yum -y install curl
    curl -sL https://rpm.nodesource.com/setup_10.x | bash -
    yum -y install nodejs
    yum -y install epel-release
    yum -y install supervisor
    yum -y install git
    git clone https://github.com/nondanee/UnblockNeteaseMusic.git

    cd UnblockNeteaseMusic
    #echo ''>>/etc/supervisord.d/netease.ini
    echo '[supervisord]' >>/etc/supervisord.d/netease.ini
    echo 'nodaemon=false' >>/etc/supervisord.d/netease.ini
    echo '' >>/etc/supervisord.d/netease.ini
    echo '[program:netease]' >>/etc/supervisord.d/netease.ini
    echo 'user=root' >>/etc/supervisord.d/netease.ini
    echo 'directory=/root/UnblockNeteaseMusic' >>/etc/supervisord.d/netease.ini
    echo 'command=/usr/bin/node app.js -s -p '${port}'' >>/etc/supervisord.d/netease.ini
    echo 'autostart=true' >>/etc/supervisord.d/netease.ini
    echo 'autorestart=true' >>/etc/supervisord.d/netease.ini

    systemctl start supervisord && systemctl enable supervisord

    echo ''
    echo '脚本运行完毕。水平有限，不一定成功' | _color_ red invert
    echo ''
    echo '请到网易云音乐PC客户端——设置——工具——自定义代理'
    echo ''
    echo '填写你的VPS IP和端口,进行测试,以测试结果为准。' | _color_ blue bold
    echo ''
    echo "您设置的端口为：" ${port} | _color_ yellow bold
    echo ''
    echo "您设置的端口为：" ${port} | _color_ purple bold
    echo ''
    echo "记得打开你的VPS 防火墙端口 " | _color_ red invert
    echo ''
    echo '祝您使用愉快。' | _color_ cyan bold
    echo ''
}
ubuntu() {
    check_port
    apt-get update
    sudo apt-get install -y curl
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    sudo apt-get install -y nodejs
    sudo apt-get install -y git
    sudo apt-get install -y supervisor
    git clone https://github.com/nondanee/UnblockNeteaseMusic.git

    cd UnblockNeteaseMusic
    echo '' >>/etc/supervisor/supervisord.conf
    echo '[supervisord]' >>/etc/supervisor/supervisord.conf
    echo 'nodaemon=false' >>/etc/supervisor/supervisord.conf
    echo '' >>/etc/supervisor/supervisord.conf
    echo '[program:netease]' >>/etc/supervisor/supervisord.conf
    echo 'user=root' >>/etc/supervisor/supervisord.conf
    echo 'directory=/root/UnblockNeteaseMusic' >>/etc/supervisor/supervisord.conf
    echo 'command=/usr/bin/node app.js -s -p '${port}'' >>/etc/supervisor/supervisord.conf
    echo 'autostart=true' >>/etc/supervisor/supervisord.conf
    echo 'autorestart=true' >>/etc/supervisor/supervisord.conf
    systemctl start supervisor
    systemctl restart supervisor
    
    echo ''
    echo '脚本运行完毕。水平有限，不一定成功' | _color_ red invert
    echo ''
    echo '请到网易云音乐PC客户端——设置——工具——自定义代理'
    echo ''
    echo '填写你的VPS IP和端口,进行测试,以测试结果为准。' | _color_ blue bold
    echo ''
    echo "您设置的端口为：" ${port} | _color_ yellow bold
    echo ''
    echo "您设置的端口为：" ${port} | _color_ purple bold
    echo ''
    echo "记得打开你的VPS 防火墙端口 " | _color_ red invert
    echo ''
    echo '祝您使用愉快。' | _color_ cyan bold
    echo ''
}
debian() {
    check_port
    apt-get update
    sudo apt-get install -y curl
    curl -sL https://deb.nodesource.com/setup_10.x | bash -
    sudo apt-get install -y nodejs
    sudo apt-get install -y git
    sudo apt-get install -y supervisor
    git clone https://github.com/nondanee/UnblockNeteaseMusic.git

    cd UnblockNeteaseMusic
    echo '' >>/etc/supervisor/supervisord.conf
    echo '[supervisord]' >>/etc/supervisor/supervisord.conf
    echo 'nodaemon=false' >>/etc/supervisor/supervisord.conf
    echo '' >>/etc/supervisor/supervisord.conf
    echo '[program:netease]' >>/etc/supervisor/supervisord.conf
    echo 'user=root' >>/etc/supervisor/supervisord.conf
    echo 'directory=/root/UnblockNeteaseMusic' >>/etc/supervisor/supervisord.conf
    echo 'command=/usr/bin/node app.js -s -p '${port}'' >>/etc/supervisor/supervisord.conf
    echo 'autostart=true' >>/etc/supervisor/supervisord.conf
    echo 'autorestart=true' >>/etc/supervisor/supervisord.conf
    systemctl start supervisor
    systemctl restart supervisor

    echo ''
    echo '脚本运行完毕。水平有限，不一定成功' | _color_ red invert
    echo ''
    echo '请到网易云音乐PC客户端——设置——工具——自定义代理'
    echo ''
    echo '填写你的VPS IP和端口,进行测试,以测试结果为准。' | _color_ blue bold
    echo ''
    echo "您设置的端口为：" ${port} | _color_ yellow bold
    echo ''
    echo "您设置的端口为：" ${port} | _color_ purple bold
    echo ''
    echo "记得打开你的VPS 防火墙端口 " | _color_ red invert
    echo ''
    echo '祝您使用愉快。' | _color_ cyan bold
    echo ''
}

function _color_() {
    case "$1" in
    red) nn="31" ;;
    green) nn="32" ;;
    yellow) nn="33" ;;
    blue) nn="34" ;;
    purple) nn="35" ;;
    cyan) nn="36" ;;
    esac
    ff=""
    case "$2" in
    bold) ff=";1" ;;
    bright) ff=";2" ;;
    uscore) ff=";4" ;;
    blink) ff=";5" ;;
    invert) ff=";7" ;;
    esac
    color_begin=$(echo -e -n "\033[${nn}${ff}m")
    color_end=$(echo -e -n "\033[0m")
    while read line; do
        echo "${color_begin}${line}${color_end}"
    done
}

check_sys
[[ ${release} != "centos" ]] && [[ ${release} != "debian" ]] && [[ ${release} != "ubuntu" ]] && echo -e "${Error} 本脚本不支持当前系统 ${release} !" && exit 1

if [ ${release} = centos ]; then
    centos
elif [ ${release} = ubuntu ]; then
    ubuntu
elif [ ${release} = debian ]; then
    debian
fi
