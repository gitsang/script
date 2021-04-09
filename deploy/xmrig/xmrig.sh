#!/bin/bash

TGZ=xmrig-6.11.1-linux-x64.tar.gz
if [ ! -f "${TGZ}" ]; then
    wget https://github.com/xmrig/xmrig/releases/download/v6.11.1/xmrig-6.11.1-linux-x64.tar.gz
fi

DIR=xmrig-6.11.1
if [ ! -d "${DIR}" ]; then
    tar zxvf ${TGZ}
fi

BIN_PATH=/usr/local/bin/
if [ ! -f "${BIN_PATH}/xmrig" ]; then
    cp ${DIR}/xmrig ${BIN_PATH}
fi

CONF_PATH=/usr/local/etc/xmrig/
SERVICE_PATH=/etc/systemd/system/
mkdir -p ${CONF_PATH}
cp ./config.json ${CONF_PATH}
cp ./xmrig.service ${SERVICE_PATH}

systemctl daemon-reload
systemctl restart xmrig.service
systemctl status xmrig.service
