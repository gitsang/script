
getAccessConfigSubCommand() {
    ADMIN=./rocketmq/bin/mqadmin
    FUNC=getAccessConfigSubCommand

    CLUSTER_NAME=DefaultCluster
    NAMESRV_ADDR=localhost:9876

    ${ADMIN} ${FUNC} \
        --clusterName ${CLUSTER_NAME} \
        --namesrvAddr ${NAMESRV_ADDR}
}

statsAll() {
    ADMIN=./rocketmq/bin/mqadmin
    FUNC=statsAll

    NAMESRV_ADDR=localhost:9876

    ${ADMIN} ${FUNC} --namesrvAddr ${NAMESRV_ADDR}
}

updateTopic() {
    ADMIN=./rocketmq/bin/mqadmin
    FUNC=updateTopic

    CLUSTER_NAME=DefaultCluster
    NAMESRV_ADDR=localhost:9876
    TOPIC=EXAMPLE_TOPIC
    PERM=6
    RQN=4
    WQN=4

    ${ADMIN} ${FUNC} \
        --clusterName ${CLUSTER_NAME} \
        --namesrvAddr ${NAMESRV_ADDR} \
        --perm ${PERM} \
        --readQueueNums ${RQN} \
        --writeQueueNums ${WQN} \
        --topic ${TOPIC} 
}

case $1 in
    "getAcl")
        getAccessConfigSubCommand ;;
    "statsAll")
        statsAll ;;
    "updateTopic")
        updateTopic ;;
    *)
        echo "usage $0 getAcl/statsAll/updateTopic"
esac
