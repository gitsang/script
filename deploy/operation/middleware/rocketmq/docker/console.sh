#!/bin/bash

docker rm -f rocketmq-console
docker run -d \
    --name rocketmq-console \
    --restart always \
    -e "JAVA_OPTS=-Drocketmq.namesrv.addr=cn.sang.ink:9876 -Dcom.rocketmq.sendMessageWithVIPChannel=false" \
    -p 8081:8080 \
    apacherocketmq/rocketmq-console:2.0.0

