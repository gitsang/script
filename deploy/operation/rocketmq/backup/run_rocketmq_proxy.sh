#!/bin/bash

# config
NAME=rocketmq-proxy
VERSION=${1:-"test-latest"}

# image
DEVELOP_IMAGE_URL=cr-dev.yealinkops.com/ybdp
RELEASE_IMAGE_URL=cr.yealinkops.com/ybdp
L7I_REPO=hub.l7i.top:5000

if [ "develop" == "${VERSION:0:7}" ]; then
    IMAGE=${DEVELOP_IMAGE_URL}/${NAME}:${VERSION#*-}
elif [ "release" == "${VERSION:0:7}" ]; then
    IMAGE=${RELEASE_IMAGE_URL}/${NAME}:${VERSION#*-}
elif [ "test" == "${VERSION:0:4}" ]; then
    IMAGE=${L7I_REPO}/${NAME}:${VERSION#*-}
else
    IMAGE=${L7I_REPO}/${NAME}:latest
fi

# docker
mkdir -p log
docker stop rocketmq-proxy
docker rm rocketmq-proxy
docker pull ${IMAGE}
docker run -it \
    --name rocketmq-proxy \
    --restart always \
    -p 9474:9474 \
    -p 9484:9484 \
    -p 9485:9485 \
    -v `pwd`/log:/usr/local/rocketmq-proxy/log \
    -e ENABLE_TCP=true \
    -e ENABLE_TLS=true \
    -e CERT_FILE="/usr/local/rocketmq-proxy/cert/server.crt" \
    -e KEY_FILE="/usr/local/rocketmq-proxy/cert/server.key" \
    -e CLIENT_CA_FILE="/usr/local/rocketmq-proxy/cert/client-ca.crt" \
    -e MQ_HOST_PORT="10.200.112.67:9876" \
    -d $IMAGE
