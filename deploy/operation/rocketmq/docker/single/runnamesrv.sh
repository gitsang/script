ROCKETMQ_VERSION=4.7.1
ROCKETMQ_HOME=/usr/local/rocketmq/rocketmq-${ROCKETMQ_VERSION}
MEM_OPT="-Xms1g -Xmx2g -Xmn1g"
NAME=rocketmq-namesrv

docker run -d \
    --name ${NAME} \
    --restart always \
    -p 9876:9876 \
    -v `pwd`/data/${NAME}/logs:${ROCKETMQ_HOME}/logs/ \
    -e "JAVA_OPT_EXT=-server ${MEM_OPT}" \
    hub.l7i.top:5000/rocketmq:${ROCKETMQ_VERSION} \
    sh mqnamesrv
