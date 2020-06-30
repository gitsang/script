
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

config_namesrv() {
    mkdir -p conf
    mkdir -p conf/namesrv
    echo "listenPort=${listenPort}" > conf/namesrv/${NAMESRV_NAME}.conf
}

config_broker_master-slave() {
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
    echo "dLegerGroup=${dLegerGroup}"          >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
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

run_namesrv() {
    mkdir -p data/namesrv/
    echo "run namesrv/${NAMESRV_NAME} ${listenPort}"
    nohup sh bin/mqnamesrv -c conf/namesrv/${NAMESRV_NAME}.conf > data/namesrv/${NAMESRV_NAME}.log 2>&1 &
}

run_broker() {
    mkdir -p data/${BROKER_PATH}/
    echo "run ${BROKER_PATH}/${BROKER_NAME}"
    nohup sh bin/mqbroker -c conf/${BROKER_PATH}/${BROKER_NAME}.properties > data/${BROKER_PATH}/${BROKER_NAME}.log 2>&1 &
}

reboot_broker() {
    ps aux | grep ${BROKER_NAME} | grep -v grep | awk '{print $2}' | xargs -i -t kill -9 {}
    sleep 1
    nohup sh bin/mqbroker -c conf/${BROKER_PATH}/${BROKER_NAME}.properties > data/${BROKER_PATH}/${BROKER_NAME}.log 2>&1 &
}

run_console() {
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
        --server.port=12581 \
        --rocketmq.config.namesrvAddr='10.200.112.67:9876' \
        --rocketmq.config.dataPath='data/rocketmq-console' \
        > data/rocketmq-console/console.log 2>&1 &
    echo rocketmq-console at http://10.200.112.67:12581/
}

r_2m-2s-async() {
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
        config_broker_master-slave
        run_broker
        
        # broker-a-s
        BROKER_NAME=broker-a-s
        brokerId=1
        brokerRole=SLAVE
        listenPort=10020
        config_broker_master-slave
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
        config_broker_master-slave
        run_broker
        
        # broker-b-s
        BROKER_NAME=broker-b-s
        brokerId=1
        brokerRole=SLAVE
        listenPort=20020
        config_broker_master-slave
        run_broker
    fi
}

r_dledger() {
    BROKER_PATH=dledger

    # Node 0
    brokerName=RaftNode00
    dLegerGroup=RaftNode00
    brokerIP1=10.200.112.67
    dLegerPeers="n0-${brokerIP1}:49000;n1-${brokerIP1}:49010;n2-${brokerIP1}:49020"
    namesrvAddr="10.200.112.67:9876"

    # n0
    BROKER_NAME=broker-n0
    dLegerSelfId=n0
    listenPort=39000
    config_broker_dledger
    run_broker

    # n1
    BROKER_NAME=broker-n1
    dLegerSelfId=n1
    listenPort=39010
    config_broker_dledger
    run_broker
    
    # n2
    BROKER_NAME=broker-n2
    dLegerSelfId=n2
    listenPort=39020
    config_broker_dledger
    run_broker
}

r_namesrv() {
    NAMESRV_NAME=namesrv-a
    listenPort=9876
    config_namesrv
    run_namesrv
}

if [ "$1" == "init" ]; then
    kill_all
    reset_data
    drop_caches
elif [ "$1" == "namesrv" ]; then
    r_namesrv
elif [ "$1" == "async" ]; then
    r_2m-2s-async $2
elif [ "$1" == "dledger" ]; then
    r_dledger
elif [ "$1" == "console" ]; then
    run_console
elif [ "$1" == "kill" ]; then
    if [ "$2" == "all" ]; then
        kill_all
    elif [ "$2" == "namesrv" ]; then
        kill_namesrv
    elif [ "$2" == "broker" ]; then
        kill_broker
    elif [ "$2" == "console" ]; then
        kill_console
    else
        echo "usage: $0 kill all/namesrv/broker/console"
        exit
    fi
elif [ "$1" == "reboot" ]; then
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
elif [ "$1" == "auto" ]; then
    $0 init
    $0 namesrv
    $0 async a
else
    echo "usage: $0 init/namesrv/async/dledger/console/kill/reboot/auto"
    echo "default auto"
    bash -x $0 auto
fi
