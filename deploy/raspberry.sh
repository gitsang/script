#!/bin/bash

# sudo passwd pi
# sudo passwd root
# su - root
# export {http,https}_proxy=http://192.168.5.10:1080
# wget https://raw.githubusercontent.com/gitsang/script/master/deploy/raspberry.sh
# bash -x raspberry.sh --init
# bash -x raspberry.sh --install v2ray
# bash -x raspberry.sh --install samba
# bash -x raspberry.sh --install h5ai
# bash -x raspberry.sh --install filerun
# tunnel 

# --------------------------------------------- config ---------------------------------------------

GIT_EMAIL="sang.chen@outlook.com"
GIT_NAME="raspsang"
SCPP=~/project/script
SCPP_BASH=$SCPP/runcommand/.bash_aliases
SCPP_VIM=$SCPP/runcommand/.vimrc
SCPP_V2=$SCPP/v2ray
SCPP_SMB=$SCPP/samba/smb.conf

# --------------------------------------------- common ---------------------------------------------

reboot_ask() {
    echo "System should be reboot, are you sure you want to reboot? (yes/no)"
    read Arg
    case $Arg in
        yes)
            echo "system will be reboot soon"
            reboot;;
        "")
            echo "system will not be reboot, you can reboot it manually"
            break;;
    esac
}

# --------------------------------------------- init ---------------------------------------------

#---------------# init repo #---------------#

init_repo() {
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/raspberry-pi-os/raspbian/ buster main non-free contrib rpi" \
        > /etc/apt/sources.list
    echo "deb-src http://mirrors.tuna.tsinghua.edu.cn/raspberry-pi-os/raspbian/ buster main non-free contrib rpi" \
        >> /etc/apt/sources.list
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ buster main ui" \
        > /etc/apt/sources.list.d/raspi.list

    apt-get update 
    apt-get upgrade -y
}

#---------------# install bases #---------------#

config_clone() {
    if [ ! -d "$SCPP" ]; then
        git clone http://github.com/gitsang/script.git $SCPP
    fi
}

config_git() {
    git config --global user.email $GIT_EMAIL
    git config --global user.name $GIT_NAME
}

config_bash() {
    cp $SCPP_BASH ~
    echo "configure bash alias runcommand finished. Use \`source ~/.bashrc\` to load"
}

config_vim() {
    cp $SCPP_VIM ~
    echo "configure vim runcommand finished. Use \`vim\` to install vim plugin"
}

install_bases() {
    apt-get install -y \
        zip unzip \
        git vim \
        wget net-tools curl \
        python python3 python-pip python3-pip \
        gcc
    # config
    config_clone
    config_git
    config_bash
    config_vim
}

# --------------------------------------------- install ---------------------------------------------

#---------------# v2ray #---------------#

config_v2ray() {
    unzip $SCPP_V2/config.zip
    cp $SCPP_V2/config.json /usr/local/etc/v2ray/config.json
    systemctl enable v2ray
    systemctl restart v2ray
    systemctl status v2ray
}

install_v2ray() {
    curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
    curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh
    bash install-release.sh
    bash install-dat-release.sh
    # config
    config_v2ray
}

#---------------# samba #---------------#

config_mount() {
    echo "/dev/sda1 /mnt/nas    ntfs-3g defaults,noexec,umask=0000 0 0" >> /etc/fstab
    echo "/dev/sda2 /mnt/secret ntfs-3g defaults,noexec,umask=0000 0 0" >> /etc/fstab
}

config_samba() {
    # add user
    smbpasswd -a root
    useradd guest
    passwd guest
    smbpasswd -a guest
    # config file
    cp $SCPP_SMB /etc/samba/smb.conf
    echo "[nas]" >> /etc/samba/guest.smb.conf
    echo "path = /mnt/nas" >> /etc/samba/guest.smb.conf
    # restart
    systemctl enable smbd
    systemctl restart smbd
    systemctl status smbd
}

install_samba() {
    apt-get install -y samba*
    # config
    config_mount
    config_samba
}

#---------------# h5ai #---------------#

install_php() {
    sudo apt-get install -y php*
}

install_apache2() {
    sudo apt-get install -y apache2
}

config_h5ai() {
    echo "config_h5ai unimplement"
}

install_h5ai() {
    # bases
    install_apache2
    install_php
    # install
    wget https://release.larsjung.de/h5ai/h5ai-0.29.2.zip -P ~/package/h5ai-0.29.2.zip
    unzip ~/package/h5ai-0.29.2.zip -d /var/www/html/
    # config
    config_h5ai
}

#---------------# filerun #---------------#

config_filerun() {
    echo "config_filerun unimplement"
}

install_filerun() {
    echo "install_filerun unimplement"
    config_filerun
}

# --------------------------------------------- docker ---------------------------------------------

install_docker() {
    # get-docker
    curl -fsSL http://get.docker.com -o get-docker.sh
    sh get-docker.sh --mirror Aliyun

    # set aliyun mirrors
    echo "{ \"registry-mirrors\": [\"https://57qfh1yo.mirror.aliyuncs.com\"] }" > /etc/docker/daemon.json
    systemctl daemon-reload
    systemctl restart docker
}

docker_install_samba() {
    docker pull dperson/samba
    docker run --name samba \
        -p 139:139 -p 445:445 \
        -v /mnt:/mnt \
        -d dperson/samba \
        -u "pi;pi" -u "guest;guest" \
        -s "nas;/mnt/nas;yes;yes;no;pi,guest;pi;pi;" \
        -s "secret;/mnt/secret;yes;no;no;pi;pi;pi"
}

docker_install_h5ai() {
    docker pull clue/h5ai
    docker run --name h5ai \
        -p 80:80 \
        -v /data/h5ai:/var/www -v /mnt:/mnt \
        -d clue/h5ai
}

docker_install_nextcloud() {
    docker pull postgres
    docker pull nextcloud
    docker run --name postgres \ 
        --restart=always \
        -p 5432:5432 \
        -v /data/postgresql:/var/lib/postgresql/data \
        -e POSTGRES_PASSWORD=postgres \
        -d postgres
    docker run --name nextcloud \
        --restart=always \
        -p 8080:80 \
        -v /data/nextcloud:/var/www/html \
        -v /mnt:/mnt \
        --link postgres:postgres \
        nextcloud
}

# --------------------------------------------- option ---------------------------------------------

BASE_NAME=`basename $0`

case "$1" in
    "-h"|"--help")
        echo "uasge:"
        echo "    $BASE_NAME [option] [param]"
        echo ""
        echo "-a, --auto           auto deploy (may have problem)"
        echo "-i, --init           init system"
        echo "    --install [name] install program and config, include [v2ray|samba|h5ai|filerun]"
        echo "-d, --docker [name]  install program by docker, include [install|samba|h5ai|filerun]"
        exit;;
    "-i"|"--init")
        init_repo
        install_bases
        exit;;
    "--install")
        case "$2" in
            "v2ray")
                install_v2ray
                exit;;
            "samba")
                install_samba
                exit;;
            "h5ai")
                install_h5ai
                exit;;
            "filerun")
                install_filerun
                exit;;
            *)
                echo "usage:"
                echo "    $BASE_NAME <-i|--install> (v2ray|samba|h5ai|filerun)"
                exit;;
        esac
        exit;;
    "-d"|"--docker")
        case "$2" in
            "install")
                install_docker
                exit;;
            "samba")
                docker_install_samba
                exit;;
            "h5ai")
                docker_install_h5ai
                exit;;
            "filerun")
                docker_install_filerun
                exit;;
            *)
                echo "usage:"
                echo "    $BASE_NAME <-d|--docker> (install|samba|h5ai|filerun)"
                exit;;
        esac
        exit;;
    "-a"|"--auto")
        $BASE_NAME --init
        $BASE_NAME --install v2ray
        $BASE_NAME --install samba
        $BASE_NAME --install h5ai
        $BASE_NAME --install filerun
        reboot_ask
        exit;;
    *)
        echo "unknown option, uasge:"
        echo "    $BASE_NAME --help for help"
        exit;;
esac

# --------------------------------------------- other ---------------------------------------------

init_firewalld() {
    systemctl start firewalld
    systemctl status firewalld
    firewall-cmd --zone=public --add-port=443/tcp --permanent
    firewall-cmd --reload
    firewall-cmd --zone=public --list-ports
}

