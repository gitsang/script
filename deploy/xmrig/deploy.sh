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
    vi ${CONF_PATH}/config.json
}

run_xmrig() {
    systemctl daemon-reload
    systemctl restart xmrig.service
    systemctl status xmrig.service
    tail -f /var/log/xmrig.log
}

stop_xmrig() {
    systemctl stop xmrig.service
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
    echo ""
    echo "option:"
    echo "    -a auto"
    echo "    -b build_xmrig"
    echo "    -c configure xmrig"
    echo "    -d download xmrig"
    echo "    -h help"
    echo "    -i install dependance"
    echo "    -k stop xmrig"
    echo "    -r run xmrig with systemd"
    echo "    -s [opt]"
    echo "       run    screen_run_xmrig"
    echo "       attach screen_attach_xmrig"
    echo "       kill   screen_kill_xmrig"
    echo ""
    echo "Example:"
    echo "$0 -i (install dependance, not necessary)"
    echo "$0 -d (download xmrig bin)"
    echo "$0 -c (configure xmrig, will cover old config)"
    echo "$0 -r (run xmrig by systemctl)"
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
    "-k")
        stop_xmrig
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

