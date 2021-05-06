.PHONY: default rocketmq docker

SERVICE_NAME=rocketmq
DOCKER_REPO=rocketmq
ROCKETMQ_VERSION=4.7.1
DOCKER_IMG=${DOCKER_REPO}/${SERVICE_NAME}:${ROCKETMQ_VERSION}
ROCKETMQ_TARGET_DIR=../distribution/target/rocketmq-${ROCKETMQ_VERSION}/rocketmq-${ROCKETMQ_VERSION}

default: help

help:
	# Usage: make [option]
	#
	# Options:
	#   rocketmq  mvn install
	#   docker    make docker and push to repository
	#   run       run docker with docker-compose (default: 2n-2m-2s)
	#   stop      stop docker with docker-compose (default: 2n-2m-2s)

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

run:
	chown -R 3000:3000 docker-compose/data
	docker-compose -f docker-compose/single-2n-2m-2s.yml up -d

stop:
	docker-compose -f docker-compose/single-2n-2m-2s.yml down

