
BROKER_NAME=${1:-broker-a}
docker stop ${BROKER_NAME}
docker rm ${BROKER_NAME}
docker run -itd \
    --name ${BROKER_NAME} \
    --restart always \
    -p 10909:10909 \
    -p 10911:10911 \
    -p 10912:10912 \
    -v /usr/local/rocketmq/store:/root/store/ \
    -v /usr/local/rocketmq/logs:/root/logs/ \
    -v `pwd`/${BROKER_NAME}.properties:/usr/local/rocketmq/rocketmq-all-4.7.1-bin-release/conf/2m-noslave/${BROKER_NAME}.properties \
    -e NAMESRV_ADDR="10.200.112.158:9876;10.200.112.159:9876" \
    -e CFG_FILE=/usr/local/rocketmq/rocketmq-all-4.7.1-bin-release/conf/2m-noslave/${BROKER_NAME}.properties \
    -e "JAVA_OPT_EXT=-server -Xms1g -Xmx2g -Xmn1g" \
    hub.l7i.top:5000/rocketmq-broker:4.7.1
