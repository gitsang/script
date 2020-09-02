#!/bin/bash

ROCKETMQ_VERSION=4.7.1

build() {
    ROCKETMQ_ZIP=rocketmq-all-${ROCKETMQ_VERSION}-source-release.zip
    ROCKETMQ_DIR=rocketmq-all-${ROCKETMQ_VERSION}-source-release
    ROCKETMQ_TARGET_DIR=distribution/target/rocketmq-${ROCKETMQ_VERSION}/rocketmq-${ROCKETMQ_VERSION}

    # make tmp file
    CWD=`pwd`
    mkdir -p tmp_rocketmq
    cd tmp_rocketmq
    # download source release zip
    if [ ! -f "${ROCKETMQ_ZIP}" ]; then
        wget https://mirrors.tuna.tsinghua.edu.cn/apache/rocketmq/$VERSION/$ROCKETMQ_ZIP
    fi
    # unzip file
    if [ ! -d "${ROCKETMQ_DIR}" ]; then
        unzip ${ROCKETMQ_ZIP}
    fi
    # compile and copy target
    cd ${ROCKETMQ_DIR}
    if [ ! -d "${ROCKETMQ_TARGET_DIR}" ]; then
        mvn -Prelease-all -DskipTests clean install -U
    fi
    if [ ! -d "${CWD}/rocketmq" ]; then
        cp -r ${ROCKETMQ_TARGET_DIR} $CWD/rocketmq
    fi
    # copy deploy shell
    cd ${CWD}
    if [ ! -f "rocketmq/deploy.sh" ]; then
        cp deploy.sh rocketmq/
        chmod +x rocketmq/deploy.sh
    fi
}

build
