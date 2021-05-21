#!/bin/bash

# config
NAME=rocketmq-monitor
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
docker stop ${NAME}
docker rm ${NAME}
docker pull ${IMAGE}
docker run -it \
    --name ${NAME} \
    -p 9475:9475 \
    -v `pwd`/log:/opt/${NAME}/log \
    -v `pwd`/conf:/opt/${NAME}/conf \
    -d ${IMAGE}
