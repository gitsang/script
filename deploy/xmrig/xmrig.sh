#!/bin/bash

BIN_PATH=/usr/local/bin/
CONF_PATH=/usr/local/etc/xmrig/
SERVICE_PATH=/etc/systemd/system/

download_xmrig() {
    mkdir xmrig-C3
    cd xmrig-C3
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

start_xmrig() {
    systemctl daemon-reload
    systemctl restart xmrig.service
    systemctl status xmrig.service
}

run_xmrig() {
    ./xmrig -c ./config.json
}

help_xmrig() {
    echo "Usage:"
    echo "    ./xmrig.sh [option]"
    echo "option:"
    echo "    -h help"
    echo "    -d download_xmrig"
    echo "    -b build_xmrig"
    echo "    -i init_xmrig"
    echo "    -s start_xmrig"
    echo "    -r run_xmrig"
}

OPT=$1
case $OPT in
    "-h")
        help_xmrig
        ;;
    "-d")
        download_xmrig
        ;;
    "-b")
        build_xmrig
        ;;
    "-i")
        init_xmrig
        ;;
    "-s")
        start_xmrig
        ;;
    "-r")
        run_xmrig
        ;;
    *)
        download_xmrig
        init_xmrig
        start_xmring
        ;;
esac

