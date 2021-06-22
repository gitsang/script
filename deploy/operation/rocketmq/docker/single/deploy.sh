#!/bin/bash

# Config =======================================================================

# RocketMQ Runtime Config
ROCKETMQ_VERSION=4.9.0
DOCKER_IMAGE=gitsang/rocketmq:${ROCKETMQ_VERSION}
ROCKETMQ_HOME=/usr/local/rocketmq/rocketmq-${ROCKETMQ_VERSION}
MEM_OPT="-Xms1g -Xmx2g -Xmn1g"

# Global Config
NAMESRV_ADDR=127.0.0.1:9876
BROKER_IP=127.0.0.1
    
# Broker Config
BROKER_CLUSTER=DefaultCluster
BROKER_NAME=rocketmq-broker
BROKER_ID=0
BROKER_FLUSH_TYPE=ASYNC_FLUSH
BROKER_ROLE=ASYNC_MASTER
NAMESRV_ADDR=${NAMESRV_ADDR}
BROKER_PORT=10911
BROKER_IP1=${BROKER_IP}
BROKER_IP2=${BROKER_IP}
ACL_ENABLE=true
BROKER_DATA_PATH=`pwd`/data/${BROKER_NAME}
    
# Namesrv Config
NAMESRV_NAME=rocketmq-namesrv

# Function =====================================================================

data_clean() {
    echo "REMOVE DATA ${BROKER_NAME}"
    rm -fr `pwd`/data/${BROKER_NAME}/store
    rm -fr `pwd`/data/${BROKER_NAME}/logs
}

init_broker() {
    CONF_PATH=${BROKER_DATA_PATH}/broker.properties
    mkdir -p ${BROKER_DATA_PATH}
    echo > ${CONF_PATH}
    echo "deleteWhen         = 04"                     >> ${CONF_PATH}
    echo "fileReservedTime   = 48"                     >> ${CONF_PATH}
    echo "brokerClusterName  = ${BROKER_CLUSTER}"      >> ${CONF_PATH}
    echo "brokerName         = ${BROKER_NAME}"         >> ${CONF_PATH}
    echo "brokerId           = ${BROKER_ID}"           >> ${CONF_PATH}
    echo "flushDiskType      = ${BROKER_FLUSH_TYPE}"   >> ${CONF_PATH}
    echo "brokerRole         = ${BROKER_ROLE}"         >> ${CONF_PATH}
    echo "namesrvAddr        = ${NAMESRV_ADDR}"        >> ${CONF_PATH}
    echo "listenPort         = ${BROKER_PORT}"         >> ${CONF_PATH}
    echo "brokerIP1          = ${BROKER_IP1}"          >> ${CONF_PATH}
    echo "brokerIP2          = ${BROKER_IP2}"          >> ${CONF_PATH}
    echo "aclEnable          = ${ACL_ENABLE}"          >> ${CONF_PATH}
    echo "storePathRootDir   = ${ROCKETMQ_HOME}/store" >> ${CONF_PATH}
    echo "storePathCommitLog = ${ROCKETMQ_HOME}/log"   >> ${CONF_PATH}
}

deploy_namesrv() {
    echo "deploy ${NAMESRV_NAME}"
    docker stop ${NAMESRV_NAME}
    docker rm ${NAMESRV_NAME}

    docker run -dit \
        --name ${NAMESRV_NAME} \
        --restart always \
        -p 9876:9876 \
        -v `pwd`/data/${NAMESRV_NAME}/logs:${ROCKETMQ_HOME}/logs/ \
        -e "JAVA_OPT_EXT=-server ${MEM_OPT}" \
        ${DOCKER_IMAGE} \
        sh mqnamesrv
}

deploy_broker() {
    echo "deploy ${BROKER_NAME}"
    docker stop ${BROKER_NAME}
    docker rm ${BROKER_NAME}

    docker run -d \
        --name ${BROKER_NAME} \
        --restart always \
        -p 10909:10909 \
        -p 10911:10911 \
        -p 10912:10912 \
        -v ${BROKER_DATA_PATH}/store:${ROCKETMQ_HOME}/store/ \
        -v ${BROKER_DATA_PATH}/logs:${ROCKETMQ_HOME}/logs/ \
        -v ${BROKER_DATA_PATH}/broker.properties:${ROCKETMQ_HOME}/conf/broker.properties \
        -e "JAVA_OPT_EXT=-server ${MEM_OPT}" \
        ${DOCKER_IMAGE} \
        sh mqbroker -c ${ROCKETMQ_HOME}/conf/broker.properties
}

# Options ======================================================================

help() {
    echo "Usage:"
    echo "deploy.sh [options]"
    echo ""
    echo "Options:"
    echo "    -c, --clean   : data clean"
    echo "    -i, --init    : config init"
    echo "    -n, --namesrv : deploy namesrv"
    echo "    -b, --broker  : deploy broker"
    exit -1
}

case "$1" in
    -c|--clean) 
        data_clean
        ;;
    -i|--init)
        init_broker
        ;;
    -n|--namesrv) 
        deploy_namesrv
        ;;
    -b|--broker)
        deploy_broker
        ;;
    -h|--help)
        help
        ;;
    *) 
        help
        ;;
esac

