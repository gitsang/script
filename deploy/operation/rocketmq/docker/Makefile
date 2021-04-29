.PHONY: default rocketmq docker

SERVICE_NAME=rocketmq
DOCKER_REPO=rocketmq
ROCKETMQ_VERSION=4.7.1
DOCKER_IMG=${DOCKER_REPO}/${SERVICE_NAME}:${ROCKETMQ_VERSION}
ROCKETMQ_TARGET_DIR=../distribution/target/rocketmq-${ROCKETMQ_VERSION}/rocketmq-${ROCKETMQ_VERSION}

default: rocketmq

rocketmq:
	cd .. && mvn -Prelease-all -DskipTests clean install -U && cd -
	rm -fr rocketmq-${ROCKETMQ_VERSION}
	mv ${ROCKETMQ_TARGET_DIR} .

docker: rocketmq
	docker build . \
		--no-cache \
		--build-arg version=${ROCKETMQ_VERSION} \
		--build-arg "HTTP_PROXY=http://127.0.0.1:1081/" \
    	--build-arg "HTTPS_PROXY=http://127.0.0.1:1081/" \
    	--build-arg "NO_PROXY=localhost,127.0.0.1" \
		-t ${DOCKER_IMG}
	docker push ${DOCKER_IMG}

docker-compose-up:
	echo "do nothing"

test:
	docker run -d \
		--name rocketmq-namesrv-test-${ROCKETMQ_VERSION} \
		-p 9877:9876 \
		127.0.0.1:5000/rocketmq:${ROCKETMQ_VERSION} \
		sh mqnamesrv
