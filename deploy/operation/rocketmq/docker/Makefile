.PHONY: default help rocketmq docker

SERVICE_NAME=rocketmq
DOCKER_REPO=gitsang
ROCKETMQ_VERSION=4.9.0
DOCKER_IMG=$(DOCKER_REPO)/$(SERVICE_NAME):$(ROCKETMQ_VERSION)
ROCKETMQ_TARGET_DIR=distribution/target/rocketmq-$(ROCKETMQ_VERSION)/rocketmq-$(ROCKETMQ_VERSION)
ROCKETMQ_BIN_RELEASE=rocketmq-all-$(ROCKETMQ_VERSION)-bin-release
DOWNLOAD_URL=https://mirrors.tuna.tsinghua.edu.cn/apache/$(SERVICE_NAME)/$(ROCKETMQ_VERSION)/$(ROCKETMQ_BIN_RELEASE).zip

default: help

help:
	# Usage: make [option]
	#
	# Options:
	#   rocketmq  mvn install
	#   download  download rocketmq bin release pkg
	#   build     make docker (need `make download` or `make rocketmq` first)
	#   push      push docker to repository (need `make build` first)
	#
	# Download and push image:
	#   make download
	#   make build
	#   make push

rocketmq:

	mkdir -p pkg

	@if [ ! -d "src" ]; then \
		git clone https://github.com/apache/rocketmq.git src; \
	fi
	cd src && \
		git checkout release-$(ROCKETMQ_VERSION) && \
		mvn -Prelease-all -DskipTests clean install -U && \
	cd -

	rm -fr pkg/$(ROCKETMQ_BIN_RELEASE)
	mv src/$(ROCKETMQ_TARGET_DIR) pkg/$(ROCKETMQ_BIN_RELEASE)

download:

	mkdir -p pkg
	wget -c $(DOWNLOAD_URL) -O pkg/$(ROCKETMQ_BIN_RELEASE).zip

	rm -fr pkg/$(ROCKETMQ_BIN_RELEASE)
	unzip pkg/$(ROCKETMQ_BIN_RELEASE).zip -d pkg/

build:

	docker build . \
		--no-cache \
		--build-arg "HTTP_PROXY=http://127.0.0.1:1081/" \
    	--build-arg "HTTPS_PROXY=http://127.0.0.1:1081/" \
    	--build-arg "NO_PROXY=localhost,127.0.0.1,.example.com" \
		--build-arg ROCKETMQ_VERSION=$(ROCKETMQ_VERSION) \
		-t $(DOCKER_IMG)

push:
	
	docker push $(DOCKER_IMG)

