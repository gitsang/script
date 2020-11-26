
build() {
    REDIS_VERSION=5.0.10
    FILE_NAME=redis-${REDIS_VERSION}
    TGZ_NAME=${FILE_NAME}.tar.gz
    if [ ! -f "${TGZ_NAME}" ]; then
        wget https://download.redis.io/releases/${TGZ_NAME}
    fi
    if [ ! -d "${FILE_NAME}" ]; then
        tar xzf ${TGZ_NAME}
    fi
    cd ${FILE_NAME}
    make
}

DEFAULT_CONF=templates/redis.conf
REDIS_SERVER=redis-5.0.10/src/redis-server

init_redis() {
    ROLE=$1
    PORT=$2
    DATA_PATH=data/${ROLE}-${PORT}
    CONF=${DATA_PATH}/${ROLE}.conf

    rm -fr ${DATA_PATH}
    mkdir -p ${DATA_PATH}
    cp ${DEFAULT_CONF} ${CONF}
    sed -i -e '/port/d' ${CONF}
    echo "port ${PORT}" >> ${CONF}
    echo "dir ${DATA_PATH}" >> ${CONF}
}

run_redis() {
    ROLE=$1
    PORT=$2
    MASTER_HOST=$3
    MASTER_PORT=$4
    QUORUN=$5
    DATA_PATH=data/${ROLE}-${PORT}
    CONF=${DATA_PATH}/${ROLE}.conf
    LOG=${DATA_PATH}/${ROLE}.log

    case ${ROLE} in
        "master")
            nohup ${REDIS_SERVER} ${CONF} > ${LOG} 2>&1 &
            ;;
        "slave")
            sed -i -e '/slaveof/d' ${CONF}
            echo "slaveof ${MASTER_HOST} ${MASTER_PORT}" >> ${CONF}
            nohup ${REDIS_SERVER} ${CONF} > ${LOG} 2>&1 &
            ;;
        "sentinel")
            sed -i -e '/sentinel monitor/d' ${CONF}
            echo "sentinel monitor mymaster ${MASTER_HOST} ${MASTER_PORT} ${QUORUN}" >> ${CONF}
            nohup ${REDIS_SERVER} ${CONF} > ${LOG} --sentinel 2>&1 &
            ;;
    esac
}

kill_redis() {
    PORT=$1
    ps -ef | grep -v grep | grep redis-server | grep ${PORT} | awk '{print $2}' | xargs -i -t kill -9 {}
}

init_redis_with_id() {
    ID=$1
    case ${ID} in
        "1") init_redis master 63790 ;;
        "2") init_redis slave 63791 ;;
        "3") init_redis slave 63792 ;;
        "4") init_redis sentinel 63800 ;;
        "5") init_redis sentinel 63801 ;;
        "6") init_redis sentinel 63802 ;;
    esac
}

run_redis_with_id() {
    ID=$1
    case ${ID} in
        "1") run_redis master 63790 ;;
        "2") run_redis slave 63791 127.0.0.1 63790 ;;
        "3") run_redis slave 63792 127.0.0.1 63790 ;;
        "4") run_redis sentinel 63800 127.0.0.1 63790 2 ;;
        "5") run_redis sentinel 63801 127.0.0.1 63790 2 ;;
        "6") run_redis sentinel 63802 127.0.0.1 63790 2 ;;
    esac
}

kill_redis_with_id() {
    ID=$1
    case ${ID} in
        "1") kill_redis 63790 ;;
        "2") kill_redis 63791 ;;
        "3") kill_redis 63792 ;;
        "4") kill_redis 63800 ;;
        "5") kill_redis 63801 ;;
        "6") kill_redis 63802 ;;
    esac
}

case $1 in
    "-b"|"build")
        build
        ;;
    "-i"|"init")
        init_redis_with_id $2
        ;;
    "-r"|"run")
        run_redis_with_id $2
        ;;
    "-k"|"kill")
        kill_redis_with_id $2
        ;;
    "-a"|"all")
        ;;
    *)
        echo "usage $0 option"
        echo ""
        ;;
esac
