#!/bin/bash

PWD=`pwd`

# build image

VERSION=4.7.1
IMAGE=centos

if [ ! -d "./src/rocketmq-docker" ]; then
    cd src
    git clone https://github.com/apache/rocketmq-docker.git

    DOCKER_IMG=`docker images | grep apacherocketmq/rocketmq | grep ${VERSION}`
    if [ "${DOCKER_IMG}" == "" ]; then
        cd rocketmq-docker/image-build
        sh build-image.sh ${VERSION} ${IMAGE}
    fi
fi

cd ${PWD}

# init broker.conf

ETH0_IP=`ifconfig | grep eth0 -A1 | grep inet | awk '{print $2}'`
IP=${1-$ETH0_IP}

if [ ! -f "./data/broker/conf/broker.conf" ]; then
    mkdir -p ./data/broker/

cat >> ./data/broker/conf/broker.conf << EOF
brokerClusterName = DefaultCluster
brokerName        = broker-a
brokerId          = 0
deleteWhen        = 04
fileReservedTime  = 48
brokerRole        = ASYNC_MASTER
flushDiskType     = ASYNC_FLUSH
brokerIP1         = ${IP}
EOF

fi

docker-compose down
docker-compose up -d
