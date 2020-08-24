#!/bin/bash

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

install_bases() {
    apt-get install -y \
        zip unzip \
        wget net-tools curl \
        gcc \
        python python3 python-pip python3-pip \
        git vim
}

install_docker() {
    # option
    apt-get --yes --no-install-recommends --reinstall install lsb-release
    #apt-get --yes --no-install-recommends install dirmngr gnupg
    #apt-get --yes --no-install-recommends install monit postfix
    #apt-get --yes --fix-broken install

    # get-docker
    curl -fsSL http://get.docker.com -o get-docker.sh
    sh get-docker.sh --mirror Aliyun

    # set aliyun mirrors
    echo "{ \"registry-mirrors\": [\"https://57qfh1yo.mirror.aliyuncs.com\"] }" > /etc/docker/daemon.json
    systemctl daemon-reload
    systemctl restart docker
}

install_v2ray() {
    curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
    curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh
    bash install-release.sh
    bash install-dat-release.sh
}

# --------------------------------------------- docker ---------------------------------------------

install_samba() {
    docker pull dperson/samba
    docker run --name samba \
        -p 139:139 -p 445:445 \
        -v /mnt:/mnt \
        -d dperson/samba \
        -u "pi;pi" -u "guest;guest" \
        -s "nas;/mnt/nas;yes;yes;no;pi,guest;pi;pi;" \
        -s "secret;/mnt/secret;yes;no;no;pi;pi;pi"
}

install_h5ai() {
    docker pull clue/h5ai
    docker run --name h5ai \
        -p 80:80 \
        -v /data/h5ai:/var/www -v /mnt:/mnt \
        -d clue/h5ai
}

install_nextcloud() {
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

# --------------------------------------------- configure ---------------------------------------------

GIT_EMAIL="sang.chen@outlook.com"
GIT_NAME="raspsang"
SCPP=~/project/script
SCPP_BASH=$SCPP/runcommand/.bash_aliases
SCPP_VIM=$SCPP/runcommand/.vimrc
SCPP_V2=$SCPP/v2ray
SCPP_SMB=$SCPP/samba/smb.conf

config_clone() {
    if [ ! -d "$SCPP" ]; then
        git clone http://github.com/gitsang/script.git $SCPP
    fi
}

config_v2ray() {
    unzip $SCPP_V2/config.zip
    cp $SCPP_V2/config.json /etc/v2ray/config.json
    systemctl restart v2ray
    systemctl status v2ray
    #export {http,https}_proxy=http://127.0.0.1:1080
}

config_mount() {
    echo "/dev/sda1 /mnt/nas    ntfs-3g defaults,noexec,umask=0000 0 0" >> /etc/fstab
    echo "/dev/sda2 /mnt/secret ntfs-3g defaults,noexec,umask=0000 0 0" >> /etc/fstab
}

config_samba() {
    cp $SCPP_SMB /etc/samba/smb.conf
    systemctl restart smbd
    systemctl status smbd
}

config_git() {
    git config --global user.email $GIT_EMAIL
    git config --global user.name $GIT_NAME
}

config_bash() {
    cp $SCPP_BASH ~/
    source ~/.bashrc
}

config_vim() {
    cp $SCPP_VIM ~/
    vim
}

config_all() {
    config_v2ray
    config_mount
    config_samba
    config_git
    config_bash
    config_vim
}

# --------------------------------------------- option ---------------------------------------------

BASE_NAME=`basename $0`

case "$1" in
    "-h"|"--help")
        echo "uasge:"
        echo "    $0 [option] [param]"
        exit;;
    "--auto")
        set -e
        # init
        init_repo
        install_bases
        install_docker
        install_v2ray
        # config
        config_all
        # docker
        install_samba
        install_nextcloud
        install_h5ai
        exit;;
    "--config")
        config_clone
        case "$2" in
            "all")
                config_all
                exit;;
            "v2ray")
                config_v2ray
                exit;;
            "mount")
                config_mount
                exit;;
            "samba")
                config_samba
                exit;;
            "git")
                config_git
                exit;;
            "bash")
                config_bash
                exit;;
            "vim")
                config_vim
                exit;;
            *)
                echo "usage: $BASE_NAME --config (all|v2ray|mount|samba|git|bash|vim)"
        esac
        exit;;
    *)
        echo "unknown option, uasge: $BASE_NAME --help for help"
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

