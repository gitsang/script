#!/bin/bash

CLEAN=false
INIT=false
NAMESRV_ADDR="10.120.24.130:9876;10.120.26.60:9876;10.120.25.163:9876"
ROCKETMQ_VERSION=4.7.1
ROCKETMQ_HOME=/usr/local/rocketmq/rocketmq-${ROCKETMQ_VERSION}
MEM_OPT="-Xms1g -Xmx2g -Xmn1g"

init_broker() {
    BROKER_INDEX=${1}
    BROKER_ROLE=${2}
    DATA_PATH=`pwd`/data/${BROKER_NAME}
    CONF_PATH=${DATA_PATH}/broker.properties
    echo "CONFIGURE BROKER ${BROKER_NAME}, IDX:${BROKER_INDEX}, ROLE:${BROKER_ROLE}, DP:${DATA_PATH}, CP:${CONF_PATH}"
    
    CONF_BROKER_CLUSTER=DefaultCluster
    CONF_BROKER_FLUSH_TYPE=ASYNC_FLUSH
    CONF_BROKER_NAME=broker-${BROKER_INDEX}
    CONF_NAMESRV_ADDR=${NAMESRV_ADDR}
    if [ ${BROKER_ROLE} == "master" ]; then
        CONF_BROKER_ID=0
        CONF_BROKER_ROLE=ASYNC_MASTER
        CONF_BROKER_PORT=10911
        if [ ${BROKER_INDEX} == "a" ]; then
            CONF_BROKER_IP1=10.120.24.130
        elif [ ${BROKER_INDEX} == "b" ]; then
            CONF_BROKER_IP1=10.120.26.60
        elif [ ${BROKER_INDEX} == "c" ]; then
            CONF_BROKER_IP1=10.120.25.163
        fi
    elif [ ${BROKER_ROLE} == "slave" ]; then
        CONF_BROKER_ID=1
        CONF_BROKER_ROLE=SLAVE
        CONF_BROKER_PORT=10915
        if [ ${BROKER_INDEX} == "a" ]; then
            CONF_BROKER_IP1=10.120.25.163
        elif [ ${BROKER_INDEX} == "b" ]; then
            CONF_BROKER_IP1=10.120.24.130
        elif [ ${BROKER_INDEX} == "c" ]; then
            CONF_BROKER_IP1=10.120.26.60
        fi
    fi
    CONF_BROKER_IP2=${CONF_BROKER_IP1}
    CONF_ACL_ENABLE=false

    mkdir -p ${DATA_PATH}
    echo > ${CONF_PATH}
    echo "deleteWhen         = 04"                        >> ${CONF_PATH}
    echo "fileReservedTime   = 48"                        >> ${CONF_PATH}
    echo "brokerClusterName  = ${CONF_BROKER_CLUSTER}"    >> ${CONF_PATH}
    echo "brokerName         = ${CONF_BROKER_NAME}"       >> ${CONF_PATH}
    echo "brokerId           = ${CONF_BROKER_ID}"         >> ${CONF_PATH}
    echo "flushDiskType      = ${CONF_BROKER_FLUSH_TYPE}" >> ${CONF_PATH}
    echo "brokerRole         = ${CONF_BROKER_ROLE}"       >> ${CONF_PATH}
    echo "namesrvAddr        = ${CONF_NAMESRV_ADDR}"      >> ${CONF_PATH}
    echo "listenPort         = ${CONF_BROKER_PORT}"       >> ${CONF_PATH}
    echo "brokerIP1          = ${CONF_BROKER_IP1}"        >> ${CONF_PATH}
    echo "brokerIP2          = ${CONF_BROKER_IP2}"        >> ${CONF_PATH}
    echo "aclEnable          = ${CONF_ACL_ENABLE}"        >> ${CONF_PATH}
    echo "storePathRootDir   = ${ROCKETMQ_HOME}/store"    >> ${CONF_PATH}
    echo "storePathCommitLog = ${ROCKETMQ_HOME}/log"      >> ${CONF_PATH}
}

data_clean() {
    echo "REMOVE DATA ${BROKER_NAME}"
    rm -fr `pwd`/data/${BROKER_NAME}/store
    rm -fr `pwd`/data/${BROKER_NAME}/logs
}

deploy_namesrv() {
    NAMESRV_NAME=namesrv-${1}
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

deploy_broker_master() {
    BROKER_NAME=broker-${1}-master
    echo "deploy ${BROKER_NAME}"

    docker stop ${BROKER_NAME}
    docker rm ${BROKER_NAME}
    if [ $CLEAN == true ]; then
        data_clean
    fi
    if [ $INIT == true ]; then
        init_broker ${1} master
    fi

    docker run -itd \
        --name ${BROKER_NAME} \
        --restart always \
        -p 10909:10909 \
        -p 10911:10911 \
        -p 10912:10912 \
        -v `pwd`/data/${BROKER_NAME}/store:${ROCKETMQ_HOME}/store/ \
        -v `pwd`/data/${BROKER_NAME}/logs:${ROCKEMQ_HOME}/logs/ \
        -v `pwd`/data/${BROKER_NAME}/broker.properties:${ROCKETMQ_HOME}/conf/broker.properties \
        -e "JAVA_OPT_EXT=-server ${MEM_OPT}" \
        hub.l7i.top:5000/rocketmq:${ROCKETMQ_VERSION} \
        sh mqbroker -c ${ROCKETMQ_HOME}/conf/broker.properties
}

deploy_broker_slave() {
    BROKER_NAME=broker-${1}-slave
    echo "deploy ${BROKER_NAME}"

    docker stop ${BROKER_NAME}
    docker rm ${BROKER_NAME}
    if [ $CLEAN == true ]; then
        data_clean
    fi
    if [ $INIT == true ]; then
        init_broker ${1} slave
    fi

    docker run -itd \
        --name ${BROKER_NAME} \
        --restart always \
        -p 10913:10913 \
        -p 10915:10915 \
        -p 10916:10916 \
        -v `pwd`/data/${BROKER_NAME}/store:${ROCKETMQ_HOME}/store/ \
        -v `pwd`/data/${BROKER_NAME}/logs:${ROCKETMQ_HOME}/logs/ \
        -v `pwd`/data/${BROKER_NAME}/broker.properties:${ROCKETMQ_HOME}/conf/broker.properties \
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
    echo "    -c, --clean           : deploy with data clean"
    echo "    -i, --init            : deploy with config init"
    echo "    -n, --namesrv [a/b/c] : deploy namesrv"
    echo "    -m, --master  [a/b/c] : deploy broker-master"
    echo "    -s, --slave   [a/b/c] : deploy broker-slave"
    exit -1
}

ARGS=`getopt \
    -o c,i,n:,m:,s:,h \
    --long clean,init,namesrv:,master:,slave:,help \
    -n 'deploy_rocketmq.sh' \
    -- "$@"`
if [ $? != 0 ]; then 
    echo "Terminating..." >&2
    exit 1
fi
eval set -- "$ARGS"

while true
do
    case "$1" in
        -c|--clean) 
            CLEAN=true
            shift
            ;;
        -i|--init)
            INIT=true
            shift
            ;;
        -n|--namesrv) 
            deploy_namesrv $2
            shift 2
            ;;
        -m|--master)
            deploy_broker_master $2
            shift 2
            ;;
        -s|--slave)
            deploy_broker_slave $2
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

