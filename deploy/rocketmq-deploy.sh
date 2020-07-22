
kill_namesrv() {
    ps aux | grep namesrv | grep -v grep | awk '{print $2}' | xargs -i -t kill -9 {}
}

kill_broker() {
    ps aux | grep broker | grep -v grep | awk '{print $2}' | xargs -i -t kill -9 {}
}

kill_console() {
    ps aux | grep rocketmq-console | grep -v grep | awk '{print $2}' | xargs -i -t kill -9 {}
}

kill_all() {
    kill_namesrv
    kill_broker
    kill_console
}

clean_data_console() {
    rm -fr /tmp/tomcat*
    rm -fr /tmp/keyutil_example*
    rm -fr data/rocketmq-console
}

reset_data() {
    rm data/ -fr
    mkdir -p data
    clean_data_console
}

drop_caches() {
    free -h | grep Mem
    sync; echo 1 > /proc/sys/vm/drop_caches
    sync; echo 2 > /proc/sys/vm/drop_caches
    sync; echo 3 > /proc/sys/vm/drop_caches
    free -h | grep Mem
}

config_loglevel() {
    sed -i 's/INFO/DEBUG/g' conf/logback_namesrv.xml
    sed -i 's/INFO/DEBUG/g' conf/logback_broker.xml
}

config_running() {
    sed -i '/-server/{ s/Xms.g/Xms2g/g; s/Xmx.g/Xmx2g/g; s/Xmn.g/Xmn1g/g;}' bin/runbroker.sh
    sed -i '/-server/{ s/Xms.g/Xms2g/g; s/Xmx.g/Xmx2g/g; s/Xmn.g/Xmn1g/g;}' bin/runserver.sh
}

config_namesrv() {
    mkdir -p conf
    mkdir -p conf/namesrv
    echo "listenPort=${listenPort}" > conf/namesrv/${NAMESRV_NAME}.conf
}

config_broker_master_slave() {
    mkdir -p conf
    mkdir -p conf/${BROKER_PATH}
    echo "" > conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "brokerClusterName=DefaultCluster" >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "brokerName=${brokerName}"         >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "brokerId=${brokerId}"             >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "deleteWhen=04"                    >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "fileReservedTime=48"              >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "brokerRole=${brokerRole}"         >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "flushDiskType=ASYNC_FLUSH"        >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "namesrvAddr=${namesrvAddr}"       >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "listenPort=${listenPort}"         >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "brokerIP1=${brokerIP1}"        >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    
    echo "storePathRootDir      = data/${BROKER_PATH}/${BROKER_NAME}/store" >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "storePathCommitLog    = data/${BROKER_PATH}/${BROKER_NAME}/log"   >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "storePathConsumeQueue = data/${BROKER_PATH}/${BROKER_NAME}/queue" >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "storePathIndex        = data/${BROKER_PATH}/${BROKER_NAME}/index" >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "storeCheckpoint       = data/${BROKER_PATH}/${BROKER_NAME}/ckp"   >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "abortFile             = data/${BROKER_PATH}/${BROKER_NAME}/abort" >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
}

config_broker_dledger() {
    mkdir -p conf
    mkdir -p conf/${BROKER_PATH}
    echo "" > conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "brokerClusterName=RaftCluster" >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "enableDLegerCommitLog=true"    >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "sendMessageThreadPoolNums=16"  >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "brokerName=${brokerName}"      >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "dLegerSelfId=${dLegerSelfId}"  >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "dLegerGroup=${dLegerGroup}"    >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "dLegerPeers=${dLegerPeers}"    >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "namesrvAddr=${namesrvAddr}"    >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "listenPort=${listenPort}"      >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "brokerIP1=${brokerIP1}"        >> conf/${BROKER_PATH}/${BROKER_NAME}.properties

    echo "storePathRootDir      = data/${BROKER_PATH}/${BROKER_NAME}/store" >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "storePathCommitLog    = data/${BROKER_PATH}/${BROKER_NAME}/log"   >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "storePathConsumeQueue = data/${BROKER_PATH}/${BROKER_NAME}/queue" >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "storePathIndex        = data/${BROKER_PATH}/${BROKER_NAME}/index" >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "storeCheckpoint       = data/${BROKER_PATH}/${BROKER_NAME}/ckp"   >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "abortFile             = data/${BROKER_PATH}/${BROKER_NAME}/abort" >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
}

run_namesrv_core() {
    mkdir -p data/namesrv/
    echo "run namesrv/${NAMESRV_NAME} ${listenPort}"
    nohup sh bin/mqnamesrv -c conf/namesrv/${NAMESRV_NAME}.conf > data/namesrv/${NAMESRV_NAME}.log 2>&1 &
}

run_broker() {
    mkdir -p data/${BROKER_PATH}/
    echo "run ${BROKER_PATH}/${BROKER_NAME}"
    nohup sh bin/mqbroker -c conf/${BROKER_PATH}/${BROKER_NAME}.properties > data/${BROKER_PATH}/${BROKER_NAME}.log 2>&1 &
}

run_namesrv() {
    NAMESRV_NAME=namesrv-a
    listenPort=9876
    config_namesrv
    run_namesrv_core
}

run_2m2s_async() {
    BROKER_PATH=2m-2s-async
    brokerIP1=10.200.112.67

    if [[ "$1" == "a" ]] || [[ "$1" == "" ]]; then
        # Cluster a
        BROKER_PATH=2m-2s-async
        brokerName=broker-a
        namesrvAddr="10.200.112.67:9876"

        # broker-a
        BROKER_NAME=broker-a
        brokerId=0
        brokerRole=ASYNC_MASTER
        listenPort=10010
        config_broker_master_slave
        run_broker
        
        # broker-a-s
        BROKER_NAME=broker-a-s
        brokerId=1
        brokerRole=SLAVE
        listenPort=10020
        config_broker_master_slave
        run_broker
    fi

    if [[ "$1" == "b" ]] || [[ "$1" == "" ]]; then
        # Cluster b
        BROKER_PATH=2m-2s-async
        brokerName=broker-b
        namesrvAddr="10.200.112.67:9876"

        # broker-b
        BROKER_NAME=broker-b
        brokerId=0
        brokerRole=ASYNC_MASTER
        listenPort=20010
        config_broker_master_slave
        run_broker
        
        # broker-b-s
        BROKER_NAME=broker-b-s
        brokerId=1
        brokerRole=SLAVE
        listenPort=20020
        config_broker_master_slave
        run_broker
    fi
}

run_dledger() {
    NODE=$1
    BROKER_PATH=dledger
    
    # Node n
    brokerName=RaftNode0${NODE}
    dLegerGroup=RaftNode0${NODE}
    brokerIP1=10.200.112.67
    namesrvAddr="10.200.112.67:9876"
    dLegerPeers="n0-${brokerIP1}:49${NODE}00;n1-${brokerIP1}:49${NODE}10;n2-${brokerIP1}:49${NODE}20"
    
    # n0
    BROKER_NAME=broker-n${NODE}0
    dLegerSelfId=n0
    listenPort=39${NODE}00
    config_broker_dledger
    run_broker

    # n1
    BROKER_NAME=broker-n${NODE}1
    dLegerSelfId=n1
    listenPort=39${NODE}10
    config_broker_dledger
    run_broker
    
    # n2
    BROKER_NAME=broker-n${NODE}2
    dLegerSelfId=n2
    listenPort=39${NODE}20
    config_broker_dledger
    run_broker
}

run_console() {
    PORT=$1
    mkdir -p data/rocketmq-console/
    if [ ! -f "rocketmq-console-1.0.0.tar.gz" ]; then
        wget https://github.com/apache/rocketmq-externals/archive/rocketmq-console-1.0.0.tar.gz
    fi
    if [ ! -d "rocketmq-externals-rocketmq-console-1.0.0" ]; then
        tar zxvf rocketmq-console-1.0.0.tar.gz
        cd rocketmq-externals-rocketmq-console-1.0.0/rocketmq-console
        mvn clean package -Dmaven.test.skip=true
        cd -
    fi
    nohup java -jar \
        rocketmq-externals-rocketmq-console-1.0.0/rocketmq-console/target/rocketmq-console-ng-1.0.0.jar \
        --server.port=${PORT} \
        --rocketmq.config.namesrvAddr='10.200.112.67:9876' \
        --rocketmq.config.dataPath='data/rocketmq-console' \
        > data/rocketmq-console/console.log 2>&1 &
    echo rocketmq-console at http://10.200.112.67:${PORT}/
}

case "$1" in
    "help")
        echo "usage: $0 init/namesrv/async/dledger/console/kill/reboot/auto"
        ;;
    "init")
        config_running
        config_loglevel
        kill_all
        reset_data
        drop_caches
        ;;
    "run")
        case "$2" in
            "namesrv")
                run_namesrv
                ;;
            "broker")
                case "$3" in
                    "async")
                        run_2m2s_async $4
                        ;;
                    "dledger")
                        run_dledger $4
                        ;;
                    *)
                        $0 help
                        ;;
                esac
                ;;
            "console")
                run_console 8080
                ;;
            *)
                $0 help
                ;;
        esac
        ;;
    "kill")
        case "$2" in
            "all")
                kill_all
                ;;
            "namesrv")
                kill_namesrv
                ;;
            "broker")
                kill_broker
                ;;
            "console")
                kill_console
                ;;
            *)
                $0 help
                ;;
        esac
        ;;
    "reboot")
        BROKER_PATH=dledger
        if [ "$2" == "n0" ]; then
            BROKER_NAME=broker-n0
        elif [ "$2" == "n1" ]; then
            BROKER_NAME=broker-n1
        elif [ "$2" == "n2" ]; then
            BROKER_NAME=broker-n2
        else
            echo "usage $0 reboot n0/n1/n2"
            exit
        fi
        reboot_broker
        ;;
    "auto")
        $0 init
        $0 run namesrv
        $0 run broker dledger 0
        $0 run broker dledger 1
        $0 run console
        ;;
    *)
        $0 help
        bash -x $0 auto
esac
