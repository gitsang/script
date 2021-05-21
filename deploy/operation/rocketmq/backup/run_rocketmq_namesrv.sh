
docker stop namesrv
docker rm namesrv
docker run -itd \
    --name namesrv \
    --restart always \
    -p 9876:9876 \
    -e "JAVA_OPT_EXT=-server -Xms1g -Xmx2g -Xmn1g" \
    hub.l7i.top:5000/rocketmq-namesrv:4.7.1
