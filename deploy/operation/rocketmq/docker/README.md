
## Usage

### init

```
git clone https://github.com/apache/rocketmq.git -b release-4.7.1
git clone https://github.com/gitsang/script.git
cp -r script/deploy/operation/rocketmq/docker rocketmq/build
cd rocketmq/build
```

### make docker

```
make docker
```

### docker-compose up

1. single-2m-2s

```
make run-2m-2s
```

2. run broker-a-master

```
make run-broker-a-master
```
