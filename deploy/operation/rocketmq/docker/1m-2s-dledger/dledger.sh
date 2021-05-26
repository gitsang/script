#!/bin/bash

CLEAN=false
INIT=false
ROCKETMQ_VERSION=4.8.0
MEM_OPT="-Xms1g -Xmx2g -Xmn1g"
ROCKETMQ_HOME=/usr/local/rocketmq/rocketmq-${ROCKETMQ_VERSION}
NAMESRV_ADDR="10.120.24.130:9876;10.120.26.60:9876;10.120.25.163:9876"
DLEDGER_PEERS="n0-10.120.24.130:40911;n1-10.120.26.60:40912;n2-10.120.25.163:40913"

configure_dledger() {
    DLEDGER_NAME=rocketmq-raft-node-0${1}
    DATA_PATH=`pwd`/data/${DLEDGER_NAME}
    CONF_PATH=${DATA_PATH}/broker.properties
    if [ $1 -eq 0 ]; then
        LISTEN_PORT=30911
        BROKER_IP1=10.120.24.130
    elif [ $1 -eq 1 ]; then
        LISTEN_PORT=30921
        BROKER_IP1=10.120.26.60
    elif [ $1 -eq 2 ]; then
        LISTEN_PORT=30931
        BROKER_IP1=10.120.25.163
    fi

    mkdir -p ${DATA_PATH}
    echo > ${CONF_PATH}
    echo "enableDLegerCommitLog     = true"                   >> ${CONF_PATH}
    echo "sendMessageThreadPoolNums = 16"                     >> ${CONF_PATH}
    echo "brokerClusterName         = RaftCluster"            >> ${CONF_PATH}
    echo "brokerName                = RaftNode00"             >> ${CONF_PATH}
    echo "dLegerGroup               = RaftNode00"             >> ${CONF_PATH}
    echo "dLegerSelfId              = n${1}"                  >> ${CONF_PATH}
    echo "brokerIP1                 = ${BROKER_IP1}"          >> ${CONF_PATH}
    echo "listenPort                = ${LISTEN_PORT}"         >> ${CONF_PATH}
    echo "namesrvAddr               = ${NAMESRV_ADDR}"        >> ${CONF_PATH}
    echo "dLegerPeers               = ${DLEDGER_PEERS}"       >> ${CONF_PATH}
    echo "storePathRootDir          = ${ROCKETMQ_HOME}/store" >> ${CONF_PATH}
    echo "storePathCommitLog        = ${ROCKETMQ_HOME}/log"   >> ${CONF_PATH}
}

deploy_namesrv() {
    NAMESRV_NAME=rocketmq-namesrv-${1}
    echo "deploy ${NAMESRV_NAME}"

    docker stop ${NAMESRV_NAME}
    docker rm ${NAMESRV_NAME}

    docker run -itd \
        --name ${NAMESRV_NAME} \
        --restart always \
        -p 9876:9876 \
        -v `pwd`/data/${NAMESRV_NAME}/logs:${ROCKETMQ_HOME}/logs/ \
        -e "JAVA_OPT_EXT=-server ${MEM_OPT}" \
        hub.l7i.top:5000/rocketmq:${ROCKETMQ_VERSION} \
        sh mqnamesrv
}

deploy_broker_dledger() {
    DLEDGER_NAME=rocketmq-raft-node-0${1}
    if [ $1 -eq 0 ]; then
        EXPOSE_PORT1=30911
        EXPOSE_PORT2=30909
        EXPOSE_PORT3=40911
    elif [ $1 -eq 1 ]; then
        EXPOSE_PORT1=30921
        EXPOSE_PORT2=30919
        EXPOSE_PORT3=40912
    elif [ $1 -eq 2 ]; then
        EXPOSE_PORT1=30931
        EXPOSE_PORT2=30929
        EXPOSE_PORT3=40913
    fi
    echo "deploy ${DLEDGER_NAME}"
    docker rm -f ${DLEDGER_NAME}
    docker run -itd \
        --name ${DLEDGER_NAME} \
        --restart always \
        -p ${EXPOSE_PORT1}:${EXPOSE_PORT1} \
        -p ${EXPOSE_PORT2}:${EXPOSE_PORT2} \
        -p ${EXPOSE_PORT3}:${EXPOSE_PORT3} \
        -v `pwd`/data/${DLEDGER_NAME}/store:${ROCKETMQ_HOME}/store/ \
        -v `pwd`/data/${DLEDGER_NAME}/logs:${ROCKEMQ_HOME}/logs/ \
        -v `pwd`/data/${DLEDGER_NAME}/broker.properties:${ROCKETMQ_HOME}/conf/broker.properties \
        -e "JAVA_OPT_EXT=-server ${MEM_OPT}" \
        hub.l7i.top:5000/rocketmq:${ROCKETMQ_VERSION} \
        sh mqbroker -c ${ROCKETMQ_HOME}/conf/broker.properties
}

# ================================================= #
# ==================== options ==================== #
# ================================================= #

help() {
    echo "Usage:"
    echo "deploy.sh [options]"
    echo ""
    echo "Options:"
    echo "    -n, --namesrv [0|1|2] : deploy namesrv"
    echo "    -d, --dledger [0|1|2] : deploy broker-dledger"
    exit -1
}

ARGS=`getopt \
    -o c:,n:,d:,h \
    --long configure:,namesrv:,dledger:,help \
    -n 'dledger.sh' \
    -- "$@"`
if [ $? != 0 ]; then
    echo "Terminating..." >&2
    exit 1
fi
eval set -- "$ARGS"

while true
do
    case "$1" in
        -c|--configure)
            configure_dledger $2
            shift 2
            ;;
        -n|--namesrv)
            deploy_namesrv $2
            shift 2
            ;;
        -d|--dledger)
            deploy_broker_dledger $2
            shift 2
            ;;
        -h|--help)
            help
            ;;
        --)
            shift
            break
            ;;
        *)
            help
            ;;
    esac
done

