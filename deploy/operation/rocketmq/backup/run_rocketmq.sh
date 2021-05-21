
NAME=$1
./run_rocketmq_namesrv.sh
./run_rocketmq_broker.sh broker-${NAME}
./run_rocketmq_proxy.sh

