
kill_all() {
    ps aux | grep namesrv | grep -v grep | awk '{print $2}' | xargs -i -t kill -9 {}
    ps aux | grep broker | grep -v grep | awk '{print $2}' | xargs -i -t kill -9 {}
    ps aux | grep mq | grep -v grep | awk '{print $2}' | xargs -i -t kill -9 {}
    ps aux | grep rocketmq-console | grep -v grep | awk '{print $2}' | xargs -i -t kill -9 {}
}

reset_data() {
    rm data/${BROKER_PATH} -fr
    mkdir -p data
    mkdir -p data/${BROKER_PATH}
}

config_namesrv() {
    mkdir -p conf
    mkdir -p conf/namesrv
    echo "" > conf/${NAMESRV_NAME}.conf
    echo "listenPort=${listenPort}" >> conf/${NAMESRV_NAME}.conf
}

config_broker() {
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
    echo "dLegerGroup=${dlegerGroup}"    >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "dLegerPeers=${dLegerPeers}"    >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "namesrvAddr=${namesrvAddr}"    >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "listenPort=${listenPort}"      >> conf/${BROKER_PATH}/${BROKER_NAME}.properties

    echo "storePathRootDir      = data/${BROKER_PATH}/${BROKER_NAME}/store" >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "storePathCommitLog    = data/${BROKER_PATH}/${BROKER_NAME}/log"   >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "storePathConsumeQueue = data/${BROKER_PATH}/${BROKER_NAME}/queue" >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "storePathIndex        = data/${BROKER_PATH}/${BROKER_NAME}/index" >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "storeCheckpoint       = data/${BROKER_PATH}/${BROKER_NAME}/ckp"   >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
    echo "abortFile             = data/${BROKER_PATH}/${BROKER_NAME}/abort" >> conf/${BROKER_PATH}/${BROKER_NAME}.properties
}

run_namesrv() {
    nohup sh bin/mqnamesrv -c conf/namesrv/${NAMESRV_NAME}.conf > data/${BROKER_PATH}/${NAMESRV_NAME}.log 2>&1 &
}

run_broker() {
    echo "run ${BROKER_PATH}/${BROKER_NAME}"
    nohup sh bin/mqbroker -c conf/${BROKER_PATH}/${BROKER_NAME}.properties > data/${BROKER_PATH}/${BROKER_NAME}.log 2>&1 &
}

reboot_broker() {
    ps aux | grep ${BROKER_NAME} | grep -v grep | awk '{print $2}' | xargs -i -t kill -9 {}
    sleep 10
    nohup sh bin/mqbroker -c conf/${BROKER_PATH}/${BROKER_NAME}.properties > data/${BROKER_PATH}/${BROKER_NAME}.log 2>&1 &
}

run_console() {
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
        --rocketmq.config.namesrvAddr='localhost:9876;localhost:9877' \
        2>&1 &
}

r_2m-2s-async() {
    BROKER_PATH=2m-2s-async

    # init
    kill_all
    reset_data

    # namesrv
    NAMESRV_CONF=namesrv-a
    listenPort=9876
    config_namesrv
    run_namesrv
    
    NAMESRV_CONF=namesrv-b
    listenPort=9877
    config_namesrv
    run_namesrv

    # broker-a
    BROKER_PATH=2m-2s-async
    BROKER_NAME=broker-a
    brokerName=broker-a
    brokerId=0
    brokerRole=ASYNC_MASTER
    namesrvAddr="localhost:9876;localhost:9877"
    listenPort=10010
    config_broker
    run_broker
    
    # broker-a-s
    BROKER_PATH=2m-2s-async
    BROKER_NAME=broker-a-s
    brokerName=broker-a
    brokerId=1
    brokerRole=SLAVE
    namesrvAddr="localhost:9876;localhost:9877"
    listenPort=10020
    config_broker
    run_broker

    # broker-b
    BROKER_PATH=2m-2s-async
    BROKER_NAME=broker-b
    brokerName=broker-b
    brokerId=0
    brokerRole=ASYNC_MASTER
    namesrvAddr="localhost:9876;localhost:9877"
    listenPort=20010
    config_broker
    run_broker
    
    # broker-b-s
    BROKER_PATH=2m-2s-async
    BROKER_NAME=broker-b-s
    brokerName=broker-b
    brokerId=1
    brokerRole=SLAVE
    namesrvAddr="localhost:9876;localhost:9877"
    listenPort=20020
    config_broker
    run_broker
    
    # console
    run_console
}

r_2m-2s-sync() {
    BROKER_PATH=2m-2s-async

    # init
    kill_all
    reset_data

    # namesrv
    NAMESRV_CONF=namesrv-a
    listenPort=9876
    config_namesrv
    run_namesrv
    
    NAMESRV_CONF=namesrv-b
    listenPort=9877
    config_namesrv
    run_namesrv

    # broker-a
    BROKER_PATH=2m-2s-sync
    BROKER_NAME=broker-a
    brokerName=broker-a
    brokerId=0
    brokerRole=SYNC_MASTER
    namesrvAddr="localhost:9876;localhost:9877"
    listenPort=10010
    config_broker
    run_broker
    
    # broker-a-s
    BROKER_PATH=2m-2s-sync
    BROKER_NAME=broker-a-s
    brokerName=broker-a
    brokerId=1
    brokerRole=SLAVE
    namesrvAddr="localhost:9876;localhost:9877"
    listenPort=10020
    config_broker
    run_broker

    # broker-b
    BROKER_PATH=2m-2s-sync
    BROKER_NAME=broker-b
    brokerName=broker-b
    brokerId=0
    brokerRole=SYNC_MASTER
    namesrvAddr="localhost:9876;localhost:9877"
    listenPort=20010
    config_broker
    run_broker
    
    # broker-b-s
    BROKER_PATH=2m-2s-sync
    BROKER_NAME=broker-b-s
    brokerName=broker-b
    brokerId=1
    brokerRole=SLAVE
    namesrvAddr="localhost:9876;localhost:9877"
    listenPort=20020
    config_broker
    run_broker
    
    # console
    run_console
}

r_dledger() {
    BROKER_PATH=dledger
    
    # init
    kill_all
    reset_data

    # namesrv
    NAMESRV_CONF=namesrv-a
    listenPort=9876
    config_namesrv
    run_namesrv
    
    NAMESRV_CONF=namesrv-b
    listenPort=9877
    config_namesrv
    run_namesrv

    # Node 0
    brokerName=RaftNode00
    dLegerGroup=RaftNode00
    dLegerPeers="n0-127.0.0.1:39000;n1-127.0.0.1:39010;n2-127.0.0.1:39020;"
    namesrvAddr="localhost:9876;localhost:9877"

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
    
    # Node 1
    brokerName=RaftNode01
    dLegerGroup=RaftNode01
    dLegerPeers="n3-127.0.0.1:39030;n4-127.0.0.1:39040;n5-127.0.0.1:39050;"
    namesrvAddr="localhost:9876;localhost:9877"
    
    # n3
    BROKER_NAME=broker-n3
    dLegerSelfId=n3
    listenPort=39030
    config_broker_dledger
    run_broker

    # n4
    BROKER_NAME=broker-n4
    dLegerSelfId=n4
    listenPort=39040
    config_broker_dledger
    run_broker
    
    # n5
    BROKER_NAME=broker-n5
    dLegerSelfId=n5
    listenPort=39050
    config_broker_dledger
    run_broker
    
    # console
    run_console
}

if [ "$1" == "quick" ]; then
    r_1m
elif [ "$1" == "async" ]; then
    r_2m-2s-async
elif [ "$1" == "sync" ]; then
    r_2m-2s-sync
elif [ "$1" == "dledger" ]; then
    r_dledger
elif [ "$1" == "kill" ]; then
    kill_all
elif [ "$1" == "reboot" ]; then
    BROKER_PATH=dledger
    if [ "$2" == "n0" ]; then
        BROKER_NAME=broker-n0
    elif [ "$2" == "n1" ]; then
        BROKER_NAME=broker-n1
    elif [ "$2" == "n2" ]; then
        BROKER_NAME=broker-n2
    elif [ "$2" == "n3" ]; then
        BROKER_NAME=broker-n3
    elif [ "$2" == "n4" ]; then
        BROKER_NAME=broker-n4
    elif [ "$2" == "n5" ]; then
        BROKER_NAME=broker-n5
    else
        exit
    fi
    reboot_broker
else
    echo "usage: $0 async/sync/dledger/kill/reboot [n0-n5]"
fi
