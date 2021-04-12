#!/bin/bash

BIN_PATH=/usr/local/bin/
CONF_PATH=/usr/local/etc/xmrig/
SERVICE_PATH=/etc/systemd/system/

install_dependance() {
    apt install -y cmake automake clang git vim wget curl
    yum install -y cmake automake clang git vim wget curl
    pkg install -y cmake automake clang git vim wget curl
}

download_xmrig() {
    mkdir xmrig-C3-tgz
    cd xmrig-C3-tgz
    wget https://github.com/C3Pool/xmrig-C3/releases/download/v6.11.0-C3/xmrig-v6.11.0-C3-linux-Static.tar.gz
    tar zxvf xmrig-v6.11.0-C3-linux-Static.tar.gz
    cp ./xmrig ${BIN_PATH}
    cd -
}

build_xmrig() {
    git clone https://github.com/C3Pool/xmrig-C3.git
    cd xmrig-C3
    mkdir build
    cd build
    cmake .. -DWITH_HWLOC=OFF
    make -j8
    cp ./xmrig ${BIN_PATH}
}

config_xmrig() {
    mkdir -p ${CONF_PATH}
    cp ./config.json ${CONF_PATH}
    cp ./xmrig.service ${SERVICE_PATH}
}

run_xmrig() {
    systemctl daemon-reload
    systemctl restart xmrig.service
    systemctl status xmrig.service
}

screen_run_xmrig() {
    screen -R xmrig ${BIN_PATH}/xmrig -c ${CONF_PATH}/config.json
}

screen_attach_xmrig() {
    screen -r xmrig
}

screen_kill_xmrig() {
    screen -X -S xmrig quit
    ps -ef | grep xmrig | grep -v grep | awk '{print $2}' | xargs -i -i kill -9 {}
}

help_xmrig() {
    echo "Usage:"
    echo "    $0 [option]"
    echo "option:"
    echo "    -h help"
    echo ""
    echo "    -a auto"
    echo "    -i install dependance"
    echo "    -d download xmrig"
    echo "    -c config xmrig"
    echo "    -r run xmrig with systemd"
    echo ""
    echo "    -b build_xmrig"
    echo "    -s [opt]"
    echo "       run    screen_run_xmrig"
    echo "       attach screen_attach_xmrig"
    echo "       kill   screen_kill_xmrig"
}

OPT=$1
case $OPT in
    "-h")
        help_xmrig
        ;;
    "-a")
        install_dependance
        download_xmrig
        config_xmrig
        run_xmrig
        ;;
    "-i")
        install_dependance
        ;;
    "-d")
        download_xmrig
        ;;
    "-c")
        config_xmrig
        ;;
    "-r")
        run_xmrig
        ;;
    "-b")
        build_xmrig
        ;;
    "-s")
        case $2 in
            "run")
                screen_run_xmrig
                ;;
            "attach")
                screen_attach_xmrig
                ;;
            "kill")
                screen_kill_xmrig
                ;;
        esac
        ;;
    *)
        help_xmrig
        ;;
esac

