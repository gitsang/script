
ADMIN=./rocketmq/bin/mqadmin
NAMESRV_ADDR=10.200.112.67:19876
CLUSTER_NAME=DefaultCluster

getAccessConfigSubCommand() {
    FUNC=getAccessConfigSubCommand

    ${ADMIN} ${FUNC} \
        --clusterName ${CLUSTER_NAME} \
        --namesrvAddr ${NAMESRV_ADDR}
}

statsAll() {
    FUNC=statsAll

    ${ADMIN} ${FUNC} \
        --namesrvAddr ${NAMESRV_ADDR}
}

updateTopic() {
    FUNC=updateTopic
    TOPIC=${1:-EXAMPLE_TOPIC}
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

deleteTopic() {
    FUNC=deleteTopic
    TOPIC=${1:-EXAMPLE_TOPIC}

    ${ADMIN} ${FUNC} \
        --clusterName ${CLUSTER_NAME} \
        --namesrvAddr ${NAMESRV_ADDR} \
        --topic ${TOPIC} 
}

case $1 in
    "acl"|"getAcl"|"getacl")
        getAccessConfigSubCommand ;;
    "sa"|"statsAll"|"statsall")
        statsAll ;;
    "ut"|"updateTopic"|"updatetopic")
        updateTopic $2 ;;
    "dt"|"deleteTopic"|"deletetopic")
        deleteTopic $2 ;;
    *)
        echo "usage $0 getAcl/statsAll/updateTopic/deleteTopic"
        echo "options"
        echo "    acl/getAcl"
        echo "    sa/statsAll"
        echo "    ut/updateTopic [topic]"
        echo "    dt/deleteTopic [topic]"
esac
