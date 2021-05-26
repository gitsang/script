ROCKETMQ_VERSION=4.7.1
ROCKETMQ_HOME=/usr/local/rocketmq/rocketmq-${ROCKETMQ_VERSION}
NAMESRV_ADDR="10.120.25.173:9876"
MEM_OPT="-Xms1g -Xmx2g -Xmn1g"
NAME=rocketmq-broker

docker rm -f ${NAME}
docker run -d \
    --name ${NAME} \
    --restart always \
    -p 10909:10909 \
    -p 10911:10911 \
    -p 10912:10912 \
    -v `pwd`/data/${NAME}/store:${ROCKETMQ_HOME}/store/ \
    -v `pwd`/data/${NAME}/logs:${ROCKEMQ_HOME}/logs/ \
    -v `pwd`/data/${NAME}/broker.properties:${ROCKETMQ_HOME}/conf/broker.properties \
    -e "JAVA_OPT_EXT=-server ${MEM_OPT}" \
    hub.l7i.top:5000/rocketmq:${ROCKETMQ_VERSION} \
    sh mqbroker -c ${ROCKETMQ_HOME}/conf/broker.properties
