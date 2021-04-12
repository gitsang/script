#!/bin/bash

BIN_PATH=/usr/local/bin/
CONF_PATH=/usr/local/etc/xmrig/
SERVICE_PATH=/etc/systemd/system/

download_xmrig() {
    mkdir xmrig-C3-tgz
    cd xmrig-C3-tgz
    wget https://github.com/C3Pool/xmrig-C3/releases/download/v6.11.0-C3/xmrig-v6.11.0-C3-linux-Static.tar.gz
    tar zxvf xmrig-v6.11.0-C3-linux-Static.tar.gz
    cp ./xmrig ${BIN_PATH}
}

build_xmrig() {
    git clone https://github.com/C3Pool/xmrig-C3.git
    cd xmrig-C3
    mkdir build
    cd build
    cmake .. -DWITH_HWLOC=OFF
    make -j16
    cp ./xmrig ${BIN_PATH}
}

init_xmrig() {
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
    ps -ef | grep xmrig | awk '{print $2}' | xargs -i -i kill -9 {}
}

help_xmrig() {
    echo "Usage:"
    echo "    ./xmrig.sh [option]"
    echo "option:"
    echo "    -h help"
    echo "    -d download xmrig"
    echo "    -i init xmrig"
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
    "-d")
        download_xmrig
        ;;
    "-i")
        init_xmrig
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

