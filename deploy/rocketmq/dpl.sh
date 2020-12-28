
# ----------------------------------------------------------------------------------------------------------------------
# download and make
# ----------------------------------------------------------------------------------------------------------------------

rocketmq_build() {
    ROCKETMQ_VERSION=4.7.1
    ROCKETMQ_ZIP=rocketmq-all-${ROCKETMQ_VERSION}-source-release.zip
    ROCKETMQ_DIR=rocketmq-all-${ROCKETMQ_VERSION}-source-release
    ROCKETMQ_TARGET_DIR=distribution/target/rocketmq-${ROCKETMQ_VERSION}/rocketmq-${ROCKETMQ_VERSION}
    APACHE_DIST=https://archive.apache.org/dist/rocketmq
    TSINGHUA_DIST=https://mirrors.tuna.tsinghua.edu.cn/apache/rocketmq
    ZIP_URL=${APACHE_DIST}/${ROCKETMQ_VERSION}/${ROCKETMQ_ZIP}
    SRC_PATH=./src
    EXEC_PATH=`pwd`

    mkdir -p ${SRC_PATH}
    cd ${SRC_PATH}
    if [ ! -f "${ROCKETMQ_ZIP}" ]; then
        wget ${ZIP_URL}
    fi
    if [ ! -d "${ROCKETMQ_DIR}" ]; then
        unzip ${ROCKETMQ_ZIP}
    fi

    cd ${ROCKETMQ_DIR}
    if [ ! -d "${ROCKETMQ_TARGET_DIR}" ]; then
        mvn -Prelease-all -DskipTests clean install -U
    fi
    if [ ! -d "${EXEC_PATH}/rocketmq" ]; then
        cp -r ${ROCKETMQ_TARGET_DIR} ${EXEC_PATH}/rocketmq
    fi
    cd ${EXEC_PATH}
}

download_console() {
    CONSOLE_TGZ=rocketmq-console-1.0.0.tar.gz
    CONSOLE_DIR=rocketmq-externals-rocketmq-console-1.0.0
    CONSOLE_JAR=console.jar
    TGZ_URL=https://github.com/apache/rocketmq-externals/archive/rocketmq-console-1.0.0.tar.gz
    SRC_PATH=./src
    EXEC_PATH=`pwd`

    mkdir -p ${SRC_PATH}
    cd ${SRC_PATH}
    if [ ! -f "${CONSOLE_TGZ}" ]; then
        wget ${TGZ_URL}
    fi
    if [ ! -d "${CONSOLE_DIR}" ]; then
        tar zxvf ${CONSOLE_TGZ}
    fi
    if [ ! -f "${CONSOLE_DIR}/rocketmq-console/target/rocketmq-console-ng-1.0.0.jar" ]; then
        cd ${CONSOLE_DIR}/rocketmq-console
        mvn clean package -Dmaven.test.skip=true
        cd -
    fi
    if [ ! -f "${EXEC_PATH}/${CONSOLE_JAR}" ]; then
        cp ${CONSOLE_DIR}/rocketmq-console/target/rocketmq-console-ng-1.0.0.jar ${EXEC_PATH}/console.jar
    fi
    cd ${EXEC_PATH}
}

# ----------------------------------------------------------------------------------------------------------------------
# init
# ----------------------------------------------------------------------------------------------------------------------

init_running_memory() {
    echo "init_running_memory"
    sed -i '/-server/{ s/Xms.g/Xms1g/g; s/Xmx.g/Xmx1g/g; s/Xmn.g/Xmn1g/g;}' rocketmq/bin/runbroker.sh
    sed -i '/-server/{ s/Xms.g/Xms1g/g; s/Xmx.g/Xmx1g/g; s/Xmn.g/Xmn1g/g;}' rocketmq/bin/runserver.sh
}

init_namesrv() {
    echo "init_namesrv ${NAMESRV_NAME}"
    DATA_PATH=data/${NAMESRV_NAME}
    CONF_PATH=data/${NAMESRV_NAME}/${NAMESRV_NAME}.properties
    rm -fr ${DATA_PATH}
    mkdir -p ${DATA_PATH}

    echo "listenPort=${NAMESRV_PORT}" > ${CONF_PATH}
}

init_broker() {
    echo "init_broker ${BROKER_NAME}"
    DATA_PATH=data/${BROKER_NAME}
    CONF_PATH=data/${BROKER_NAME}/${BROKER_NAME}.properties
    rm -fr ${DATA_PATH}
    mkdir -p ${DATA_PATH}

    echo > ${CONF_PATH}
    echo "deleteWhen         = 04"                   >> ${CONF_PATH}
    echo "fileReservedTime   = 48"                   >> ${CONF_PATH} 
    echo "brokerClusterName  = ${CLUSTER_NAME}"      >> ${CONF_PATH} 
    echo "brokerName         = ${BROKER_NAME}"       >> ${CONF_PATH}
    echo "brokerId           = ${BROKER_ID}"         >> ${CONF_PATH}
    echo "flushDiskType      = ${BROKER_FLUSH_TYPE}" >> ${CONF_PATH}
    echo "brokerRole         = ${BROKER_ROLE}"       >> ${CONF_PATH}
    echo "namesrvAddr        = ${NAMESRV_ADDR}"      >> ${CONF_PATH}
    echo "listenPort         = ${BROKER_PORT}"       >> ${CONF_PATH}
    echo "brokerIP1          = ${BROKER_IP1}"        >> ${CONF_PATH}
    echo "aclEnable          = ${ACL_ENABLE}"        >> ${CONF_PATH}
    echo "storePathRootDir   = ${DATA_PATH}/store"   >> ${CONF_PATH}
    echo "storePathCommitLog = ${DATA_PATH}/log"     >> ${CONF_PATH}
}

# ----------------------------------------------------------------------------------------------------------------------
# run
# ----------------------------------------------------------------------------------------------------------------------

run_namesrv() {
    echo "run_namesrv ${NAMESRV_NAME}"
    DATA_PATH=data/${NAMESRV_NAME}
    CONF_PATH=data/${NAMESRV_NAME}/${NAMESRV_NAME}.properties
    nohup sh rocketmq/bin/mqnamesrv -c ${CONF_PATH} > ${DATA_PATH}/${NAMESRV_NAME}.log 2>&1 &
}

run_broker() {
    echo "run_broker ${BROKER_NAME}"
    DATA_PATH=data/${BROKER_NAME}
    CONF_PATH=data/${BROKER_NAME}/${BROKER_NAME}.properties
    nohup sh rocketmq/bin/mqbroker -c ${CONF_PATH} > ${DATA_PATH}/${BROKER_NAME}.log 2>&1 &
}

run_console() {
    PORT=${1:-8080}
    NAMESRV=${2:-10.200.112.67:9876}
    DATA_PATH=data/console

    if [ ! -f "${EXEC_PATH}/${CONSOLE_JAR}" ]; then
        download_console
    fi
    mkdir -p ${DATA_PATH}

    nohup java -jar console.jar \
        --server.port=${PORT} \
        --rocketmq.config.namesrvAddr=${NAMESRV} \
        --rocketmq.config.dataPath=${DATA_PATH} \
        > ${DATA_PATH}/console.log 2>&1 &

    echo rocketmq-console at http://127.0.0.1:${PORT}/
}

# ----------------------------------------------------------------------------------------------------------------------
# kill
# ----------------------------------------------------------------------------------------------------------------------

kill_by_key() {
    echo "kill_by_key $1."
    ps -ef | grep "$1\." | grep -v grep | awk '{print $2}' | xargs -i -t kill -9 {}
}

status_by_key() {
    echo "status_by_key $1."
    ps -ef | grep "$1\." | grep -v grep | grep -v " sh "
}

# ----------------------------------------------------------------------------------------------------------------------
# running config
# ----------------------------------------------------------------------------------------------------------------------

rocketmq_init() {
    rm data -fr
    mkdir -p data
    init_running_memory

    NAMESRV_NAME=namesrv-a
    NAMESRV_PORT=9876
    init_namesrv

    BROKER_NAME=broker-a
    BROKER_ID=0
    BROKER_PORT=10010
    CLUSTER_NAME=DefaultCluster
    BROKER_FLUSH_TYPE=ASYNC_FLUSH
    BROKER_ROLE=ASYNC_MASTER
    NAMESRV_ADDR="10.200.112.67:9876"
    BROKER_IP1=10.200.112.67
    ACL_ENABLE=true
    init_broker
    
    BROKER_NAME=broker-a-s
    BROKER_ID=0
    BROKER_PORT=10020
    CLUSTER_NAME=DefaultCluster
    BROKER_FLUSH_TYPE=ASYNC_FLUSH
    BROKER_ROLE=ASYNC_MASTER
    NAMESRV_ADDR="10.200.112.67:9876"
    BROKER_IP1=10.200.112.67
    ACL_ENABLE=true
    init_broker
}

rocketmq_run() {
    NAMESRV_NAME=namesrv-a
    run_namesrv

    BROKER_NAME=broker-a
    run_broker

    BROKER_NAME=broker-a-s
    run_broker
                
    run_console
}

rocketmq_kill() {
    kill_by_key namesrv-a
    kill_by_key broker-a
    kill_by_key broker-a-s
    kill_by_key console
}

rocketmq_status() {
    status_by_key namesrv-a
    status_by_key broker-a
    status_by_key broker-a-s
    status_by_key console
}

case $1 in 
    "build")
        rocketmq_build ;;
    "kill") 
        rocketmq_kill ;;
    "init") 
        rocketmq_init ;;
    "run") 
        rocketmq_run ;;
    "status") 
        rocketmq_status ;;
    *) 
        echo "usage $0 build | kill | init | run | status" ;;
esac

