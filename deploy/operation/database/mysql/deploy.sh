#!/bin/bash

docker rm -f mysql
docker run -d \
    --name mysql \
    --restart=always \
    -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD=123456 \
    mysql
