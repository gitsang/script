#!/bin/bash

docker rm -f rocketmq-console
docker run -d \
    --name rocketmq-console \
    --restart always \
    -e "JAVA_OPTS=-Drocketmq.namesrv.addr=cn.ymw.pp.ua:9876 -Dcom.rocketmq.sendMessageWithVIPChannel=false" \
    -p 8080:8080 \
    apacherocketmq/rocketmq-console:2.0.0

