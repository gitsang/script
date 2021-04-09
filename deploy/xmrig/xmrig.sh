#!/bin/bash

TGZ=xmrig-6.11.1-linux-x64.tar.gz
if [ ! -f "${TGZ}" ]; then
    wget https://github.com/xmrig/xmrig/releases/download/v6.11.1/xmrig-6.11.1-linux-x64.tar.gz
fi

DIR=xmrig-6.11.1
if [ ! -f "${DIR}" ]; then
    tar zxvf ${TGZ}
fi
