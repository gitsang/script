
ROCKETMQ_VERSION=${1:-4.7.1}

if [ ! -d "rocketmq-all-${ROCKETMQ_VERSION}-bin-release" ]; then
    unzip rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip
fi

docker build --no-cache -t hub.l7i.top:5000/rocketmq:${ROCKETMQ_VERSION} --build-arg ROCKETMQ_VERSION=${ROCKETMQ_VERSION} .
docker push hub.l7i.top:5000/rocketmq:${ROCKETMQ_VERSION}
