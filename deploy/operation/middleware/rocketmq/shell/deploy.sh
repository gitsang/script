
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
        cp ${CONSOLE_DIR}/rocketmq-console/target/rocketmq-console-ng-1.0.0.jar ${EXEC_PATH}/src/console.jar
    fi
    cd ${EXEC_PATH}
}

# ----------------------------------------------------------------------------------------------------------------------
# init
# ----------------------------------------------------------------------------------------------------------------------

init_running_memory() {
    echo "init_running_memory"
    sed -i '/Xms/cJAVA_OPT="${JAVA_OPT} -server -Xms512m -Xmx512m -Xmn256m -XX:PermSize=32m -XX:MaxPermSize=64m"' rocketmq/bin/runbroker.sh
    sed -i '/Xms/cJAVA_OPT="${JAVA_OPT} -server -Xms512m -Xmx512m -Xmn256m -XX:PermSize=32m -XX:MaxPermSize=64m"' rocketmq/bin/runserver.sh
}

init_logback() {
    echo "init_logback"
    if [ ! -f "rocketmq/conf/logback_broker.bak" ]; then
        cp rocketmq/conf/logback_broker.xml rocketmq/conf/logback_broker.bak
    fi
    cp rocketmq/conf/logback_broker.bak rocketmq/conf/logback_broker.xml
    sed -i "s/\${user.home}/data/" rocketmq/conf/logback_broker.xml

    if [ ! -f "rocketmq/conf/logback_namesrv.bak" ]; then
        cp rocketmq/conf/logback_namesrv.xml rocketmq/conf/logback_namesrv.bak
    fi
    cp rocketmq/conf/logback_namesrv.bak rocketmq/conf/logback_namesrv.xml
    sed -i "s/\${user.home}/data/" rocketmq/conf/logback_namesrv.xml

    if [ ! -f "rocketmq/conf/logback_tools.bak" ]; then
        cp rocketmq/conf/logback_tools.xml rocketmq/conf/logback_tools.bak
    fi
    cp rocketmq/conf/logback_namesrv.bak rocketmq/conf/logback_namesrv.xml
    sed -i "s/\${user.home}/data/" rocketmq/conf/logback_namesrv.xml
}

init_namesrv() {
    echo "init_namesrv ${NAMESRV_NAME}"
    DATA_PATH=`pwd`/data/${NAMESRV_NAME}
    CONF_PATH=data/${NAMESRV_NAME}/${NAMESRV_NAME}.properties
    rm -fr ${DATA_PATH}
    mkdir -p ${DATA_PATH}

    echo "listenPort=${NAMESRV_PORT}" > ${CONF_PATH}
}

init_broker() {
    echo "init_broker ${BROKER_NAME}-${BROKER_ROLE}"
    DATA_PATH=`pwd`/data/${BROKER_NAME}-${BROKER_ROLE}
    CONF_PATH=${DATA_PATH}/${BROKER_NAME}-${BROKER_ROLE}.properties

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
    echo "run_broker ${BROKER_NAME}-${BROKER_ROLE}"
    DATA_PATH=data/${BROKER_NAME}-${BROKER_ROLE}
    CONF_PATH=${DATA_PATH}/${BROKER_NAME}-${BROKER_ROLE}.properties
    LOG_PATH=${DATA_PATH}/${BROKER_NAME}-${BROKER_ROLE}.log
    nohup sh rocketmq/bin/mqbroker -c ${CONF_PATH} > ${LOG_PATH} 2>&1 &
}

run_console() {
    CONSOLE_PORT=${CONSOLE_PORT:-8080}
    CONSOLE_NAMESRV=${CONSOLE_NAMESRV:-10.200.112.67:9876}
    DATA_PATH=data/console

    if [ ! -f "${EXEC_PATH}/${CONSOLE_JAR}" ]; then
        download_console
    fi
    mkdir -p ${DATA_PATH}

    nohup java -jar ./src/console.jar \
        --server.port=${CONSOLE_PORT} \
        --rocketmq.config.namesrvAddr=${CONSOLE_NAMESRV} \
        --rocketmq.config.dataPath=${DATA_PATH} \
        > ${DATA_PATH}/console.log 2>&1 &

    echo rocketmq-console at http://127.0.0.1:${CONSOLE_PORT}/
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
    echo "USER       PID %CPU %MEM     VSZ    RSS   TTY  STAT START   TIME COMMAND"
    ps -auxf | grep "$1\." | grep -v grep | grep -v " sh "
}

# ----------------------------------------------------------------------------------------------------------------------
# running config
# ----------------------------------------------------------------------------------------------------------------------

rocketmq_clean() {
    rm data -fr
    mkdir -p data
}

rocketmq_init_namesrv_a() {
    NAMESRV_NAME=namesrv-a
    NAMESRV_PORT=19876
    init_namesrv
}

rocketmq_run_namesrv_a() {
    NAMESRV_NAME=namesrv-a
    NAMESRV_PORT=19876
    run_namesrv
}

rocketmq_init_namesrv_b() {
    NAMESRV_NAME=namesrv-b
    NAMESRV_PORT=29876
    init_namesrv
}

rocketmq_run_namesrv_b() {
    NAMESRV_NAME=namesrv-b
    NAMESRV_PORT=29876
    run_namesrv
}

rocketmq_init_broker_a_master() {
    BROKER_NAME=broker-a
    BROKER_ID=0
    BROKER_PORT=10010
    CLUSTER_NAME=DefaultCluster
    BROKER_FLUSH_TYPE=ASYNC_FLUSH
    BROKER_ROLE=ASYNC_MASTER
    NAMESRV_ADDR="10.200.112.67:19876;10.200.112.67:29876"
    BROKER_IP1=10.200.112.67
    ACL_ENABLE=false
    init_broker
}

rocketmq_run_broker_a_master() {
    BROKER_NAME=broker-a
    BROKER_ROLE=ASYNC_MASTER
    run_broker
}

rocketmq_init_broker_a_slave() {
    BROKER_NAME=broker-a
    BROKER_ID=1
    BROKER_PORT=10020
    CLUSTER_NAME=DefaultCluster
    BROKER_FLUSH_TYPE=ASYNC_FLUSH
    BROKER_ROLE=SLAVE
    NAMESRV_ADDR="10.200.112.67:19876;10.200.112.67:29876"
    BROKER_IP1=10.200.112.67
    ACL_ENABLE=false
    init_broker
}

rocketmq_run_broker_a_slave() {
    BROKER_NAME=broker-a
    BROKER_ROLE=SLAVE
    run_broker
}

rocketmq_init_broker_b_master() {
    BROKER_NAME=broker-b
    BROKER_ID=0
    BROKER_PORT=20010
    CLUSTER_NAME=DefaultCluster
    BROKER_FLUSH_TYPE=ASYNC_FLUSH
    BROKER_ROLE=ASYNC_MASTER
    NAMESRV_ADDR="10.200.112.67:19876;10.200.112.67:29876"
    BROKER_IP1=10.200.112.67
    ACL_ENABLE=false
    init_broker
}

rocketmq_run_broker_b_master() {
    BROKER_NAME=broker-b
    BROKER_ROLE=ASYNC_MASTER
    run_broker
}

rocketmq_init_broker_b_slave() {
    BROKER_NAME=broker-b
    BROKER_ID=1
    BROKER_PORT=20020
    CLUSTER_NAME=DefaultCluster
    BROKER_FLUSH_TYPE=ASYNC_FLUSH
    BROKER_ROLE=SLAVE
    NAMESRV_ADDR="10.200.112.67:19876;10.200.112.67:29876"
    BROKER_IP1=10.200.112.67
    ACL_ENABLE=false
    init_broker
}

rocketmq_run_broker_b_slave() {
    BROKER_NAME=broker-b
    BROKER_ROLE=SLAVE
    run_broker
}

rocketmq_run_console() {
    CONSOLE_PORT=8080
    CONSOLE_NAMESRV="10.200.112.67:19876;10.200.112.67:29876"
    run_console
}

rocketmq_kill_namesrv_a() {
    KEY=namesrv-a
    kill_by_key ${KEY}
}

rocketmq_kill_namesrv_b() {
    KEY=namesrv-b
    kill_by_key ${KEY}
}

rocketmq_kill_broker_a_master() {
    BROKER_NAME=broker-a
    BROKER_ROLE=ASYNC_MASTER
    KEY=${BROKER_NAME}-${BROKER_ROLE}
    kill_by_key ${KEY}
}

rocketmq_kill_broker_a_slave() {
    BROKER_NAME=broker-a
    BROKER_ROLE=SLAVE
    KEY=${BROKER_NAME}-${BROKER_ROLE}
    kill_by_key ${KEY}
}

rocketmq_kill_broker_b_master() {
    BROKER_NAME=broker-b
    BROKER_ROLE=ASYNC_MASTER
    KEY=${BROKER_NAME}-${BROKER_ROLE}
    kill_by_key ${KEY}
}

rocketmq_kill_broker_b_slave() {
    BROKER_NAME=broker-b
    BROKER_ROLE=SLAVE
    KEY=${BROKER_NAME}-${BROKER_ROLE}
    kill_by_key ${KEY}
}

rocketmq_kill_console() {
    KEY=console
    kill_by_key ${KEY}
}

rocketmq_status() {
    KEY=namesrv-a
    status_by_key ${KEY}

    KEY=namesrv-b
    status_by_key ${KEY}

    BROKER_NAME=broker-a
    BROKER_ROLE=ASYNC_MASTER
    KEY=${BROKER_NAME}-${BROKER_ROLE}
    status_by_key ${KEY}

    BROKER_NAME=broker-a
    BROKER_ROLE=SLAVE
    KEY=${BROKER_NAME}-${BROKER_ROLE}
    status_by_key ${KEY}

    BROKER_NAME=broker-b
    BROKER_ROLE=ASYNC_MASTER
    KEY=${BROKER_NAME}-${BROKER_ROLE}
    status_by_key ${KEY}

    BROKER_NAME=broker-b
    BROKER_ROLE=SLAVE
    KEY=${BROKER_NAME}-${BROKER_ROLE}
    status_by_key ${KEY}

    KEY=console
    status_by_key ${KEY}
}

case $1 in
    "-b");&
    "--build")
        rocketmq_build ;;
    "-c");&
    "--clean")
        rocketmq_clean ;;
    "-i");&
    "--init")
        case $2 in
            "namesrv-a"|"nsa")
                rocketmq_init_namesrv_a
                ;;
            "namesrv-b"|"nsb")
                rocketmq_init_namesrv_b
                ;;
            "broker-a-master"|"bam")
                rocketmq_init_broker_a_master
                ;;
            "broker-a-slave"|"bas")
                rocketmq_init_broker_a_slave
                ;;
            "broker-b-master"|"bbm")
                rocketmq_init_broker_b_master
                ;;
            "broker-b-slave"|"bbs")
                rocketmq_init_broker_b_slave
                ;;
            "all"|"a")
                init_running_memory
                init_logback
                rocketmq_init_namesrv_a
                rocketmq_init_namesrv_b
                rocketmq_init_broker_a_master
                rocketmq_init_broker_a_slave
                rocketmq_init_broker_b_master
                rocketmq_init_broker_b_slave
                ;;
            *)
                echo "usage: $0 --init/-i [service]"
                echo "service:"
                echo "    all             | a"
                echo "    namesrv-a       | nsa"
                echo "    namesrv-b       | nsb"
                echo "    broker-a-master | bam"
                echo "    broker-a-slave  | bas"
                echo "    broker-b-master | bbm"
                echo "    broker-b-slave  | bbs"
                ;;
        esac
        ;;
    "-k");&
    "--kill")
        case $2 in
            "namesrv-a"|"nsa")
                rocketmq_kill_namesrv_a
                ;;
            "namesrv-b"|"nsb")
                rocketmq_kill_namesrv_b
                ;;
            "broker-a-master"|"bam")
                rocketmq_kill_broker_a_master
                ;;
            "broker-a-slave"|"bas")
                rocketmq_kill_broker_a_slave
                ;;
            "broker-b-master"|"bbm")
                rocketmq_kill_broker_b_master
                ;;
            "broker-b-slave"|"bbs")
                rocketmq_kill_broker_b_slave
                ;;
            "console"|"c")
                rocketmq_kill_console
                ;;
            "all"|"a")
                rocketmq_kill_namesrv_a
                rocketmq_kill_namesrv_b
                rocketmq_kill_broker_a_master
                rocketmq_kill_broker_a_slave
                rocketmq_kill_broker_b_master
                rocketmq_kill_broker_b_slave
                ;;
            *)
                echo "usage: $0 --kill/-k [service]"
                echo "service:"
                echo "    all             | a"
                echo "    namesrv-a       | nsa"
                echo "    namesrv-b       | nsb"
                echo "    broker-a-master | bam"
                echo "    broker-a-slave  | bas"
                echo "    broker-b-master | bbm"
                echo "    broker-b-slave  | bbs"
                echo "    console         | c"
                ;;
        esac
        ;;
    "-r");&
    "--run")
        case $2 in
            "namesrv-a"|"nsa")
                rocketmq_run_namesrv_a
                ;;
            "namesrv-b"|"nsb")
                rocketmq_run_namesrv_b
                ;;
            "broker-a-master"|"bam")
                rocketmq_run_broker_a_master
                ;;
            "broker-a-slave"|"bas")
                rocketmq_run_broker_a_slave
                ;;
            "broker-b-master"|"bbm")
                rocketmq_run_broker_b_master
                ;;
            "broker-b-slave"|"bbs")
                rocketmq_run_broker_b_slave
                ;;
            "console"|"c")
                rocketmq_run_console
                ;;
            "all"|"a")
                rocketmq_run_namesrv_a
                rocketmq_run_namesrv_b
                rocketmq_run_broker_a_master
                rocketmq_run_broker_a_slave
                rocketmq_run_broker_b_master
                rocketmq_run_broker_b_slave
                ;;
            *)
                echo "usage: $0 --run/-r [service]"
                echo "service:"
                echo "    all             | a"
                echo "    namesrv-a       | nsa"
                echo "    namesrv-b       | nsb"
                echo "    broker-a-master | bam"
                echo "    broker-a-slave  | bas"
                echo "    broker-b-master | bbm"
                echo "    broker-b-slave  | bbs"
                echo "    console         | c"
                ;;
        esac
        ;;
    "-s");&
    "--status")
        rocketmq_status ;;
    *)
        echo "usage $0 [option]"
        echo "option:"
        echo ""
        echo "    -b --build"
        echo "    -c --clean"
        echo "    -i --init [service]"
        echo "    -k --kill [service]"
        echo "    -r --run [service]"
        echo "    -s --status"
        ;;
esac

