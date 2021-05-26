.PHONY: default rocketmq docker

SERVICE_NAME=rocketmq
DOCKER_REPO=hub.l7i.top:5000
ROCKETMQ_VERSION=4.7.1
DOCKER_IMG=$(DOCKER_REPO)/$(SERVICE_NAME):$(ROCKETMQ_VERSION)
ROCKETMQ_TARGET_DIR=distribution/target/rocketmq-$(ROCKETMQ_VERSION)/rocketmq-$(ROCKETMQ_VERSION)
ROCKETMQ_BIN_RELEASE=rocketmq-all-$(ROCKETMQ_VERSION)-bin-release
DOWNLOAD_URL=http://file.ymw.pp.ua/package/rocketmq/rocketmq-all-$(ROCKETMQ_VERSION)-bin-release.zip

default: help

help:
	# Usage: make [option]
	#
	# Options:
	#   rocketmq  mvn install
	#   download  download rocketmq bin release pkg
	#   docker    make docker and push to repository (need `make download` or `make rocketmq` first)

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

	@if [ ! -f "pkg/$(ROCKETMQ_BIN_RELEASE).zip" ]; then \
		wget $(DOWNLOAD_URL) -O pkg/$(ROCKETMQ_BIN_RELEASE).zip; \
	fi

	rm -fr pkg/$(ROCKETMQ_BIN_RELEASE)
	unzip pkg/$(ROCKETMQ_BIN_RELEASE).zip -d pkg/$(ROCKETMQ_BIN_RELEASE)

docker:

	docker build . \
		--no-cache \
		--build-arg ROCKETMQ_VERSION=$(ROCKETMQ_VERSION) \
		-t $(DOCKER_IMG)

	docker push $(DOCKER_IMG)

