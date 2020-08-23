
# var_conf

GIT_EMAIL="sang.chen@outlook.com"
GIT_NAME="raspsang"
SCPP=~/project/script
SCPP_BA=$SCPP/runcommand/.bash_aliases
SCPP_BR=$SCPP/runcommand/.bashrc
SCPP_VIM=$SCPP/runcommand/.vimrc
SCPP_V2=$SCPP/v2ray

init_source_tsinghua() {
    sudo echo "deb http://mirrors.tuna.tsinghua.edu.cn/raspberry-pi-os/raspbian/ buster main non-free contrib rpi" \
        > /etc/apt/sources.list
    sudo echo "deb-src http://mirrors.tuna.tsinghua.edu.cn/raspberry-pi-os/raspbian/ buster main non-free contrib rpi" \
        >> /etc/apt/sources.list
    sudo echo "deb http://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ buster main ui" \
        > /etc/apt/sources.list.d/raspi.list
}

init_apt() {
    sudo apt-get update 
    sudo apt-get upgrade -y
    sudo rm /etc/systemd/network/99-default.link -f
    
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

install_base() {
    sudo apt-get install -y \
        zip unzip \
        wget net-tools \
        gcc gcc-c++ \
        python python3 python-pip python3-pip \
}

install_git() {
    sudo apt-get install git -y
    git config --global user.email $GIT_EMAIL
    git config --global user.name $GIT_NAME
}

init_script() {
    if [ -d "$SCPP" ]; then
        git clone http://github.com/gitsang/script.git $SCPP
    else
        cd $SCPP && git pull
    fi
}

init_bashrc() {
    cp SCPP_BA ~/ # && cp SCPP_BR ~/
    source ~/.bashrc
}

install_vim() {
    sudo apt-get install vim -y
    cp $SCPP_VIM ~/
}

install_OMV() {
    wget -O - https://github.com/OpenMediaVault-Plugin-Developers/installScript/raw/master/install | sudo bash
}

install_v2ray() {
    cd $SCPP_V2
    unzip config.zip
    bash v2ray.sh
    cp config.json /etc/v2ray/
}

init_firewalld() {
    systemctl start firewalld
    systemctl status firewalld
    firewall-cmd --zone=public --add-port=443/tcp --permanent
    firewall-cmd --reload
    firewall-cmd --zone=public --list-ports
}

install_h5ai() {
    echo "install_h5ai"
}

install_docker() {
    curl -fsSL http://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
}

install_OMV
