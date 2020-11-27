
# ==============================================================================
# install redis
# ==============================================================================

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
    cp src/redis-client /usr/local/bin
    cp src/redis-server /usr/local/bin
    cd -
}

# ==============================================================================
# bases function
# ==============================================================================

init_redis() {
    DATA_PATH=data/${ROLE}-${PORT}
    CONF=${DATA_PATH}/${ROLE}.conf
    rm -fr ${DATA_PATH}
    mkdir -p ${DATA_PATH}

    # config
    echo > ${CONF}
    case ${ROLE} in
        "master")
            echo "port ${PORT}" >> ${CONF}
            echo "bind 0.0.0.0" >> ${CONF}
            echo "loglevel debug" >> ${CONF}
            echo "dir ${DATA_PATH}" >> ${CONF}
            echo "appendonly yes" >> ${CONF}
            echo "aof-use-rdb-preamble yes" >> ${CONF}
            ;;
        "slave")
            echo "port ${PORT}" >> ${CONF}
            echo "bind 0.0.0.0" >> ${CONF}
            echo "loglevel debug" >> ${CONF}
            echo "dir ${DATA_PATH}" >> ${CONF}
            echo "appendonly yes" >> ${CONF}
            echo "aof-use-rdb-preamble yes" >> ${CONF}
            echo "slaveof ${MASTER_HOST} ${MASTER_PORT}" >> ${CONF}
            ;;
        "sentinel")
            echo "port ${PORT}" >> ${CONF}
            echo "bind 0.0.0.0" >> ${CONF}
            echo "loglevel debug" >> ${CONF}
            echo "dir ${DATA_PATH}" >> ${CONF}
            echo "sentinel monitor mymaster ${MASTER_HOST} ${MASTER_PORT} ${QUORUM}" >> ${CONF}
            echo "sentinel down-after-milliseconds mymaster 500" >> ${CONF}
            ;;
    esac
}

run_redis() {
    DATA_PATH=data/${ROLE}-${PORT}
    CONF=${DATA_PATH}/${ROLE}.conf
    LOG=${DATA_PATH}/${ROLE}.log

    case ${ROLE} in
        "master"|"slave")
            nohup ${REDIS_SERVER} ${CONF} > ${LOG} 2>&1 &
            ;;
        "sentinel")
            nohup ${REDIS_SERVER} ${CONF} > ${LOG} --sentinel 2>&1 &
            ;;
    esac
}

kill_redis() {
    ps -ef | grep -v grep | grep redis-server | grep ${PORT} | awk '{print $2}' | xargs -i -t kill -9 {}
}

status_redis() {
    ps -ef | grep -v grep | grep redis-server | grep ${PORT}
}

log_redis() {
    DATA_PATH=data/${ROLE}-${PORT}
    LOG=${DATA_PATH}/${ROLE}.log
    tail -f -n 100 ${LOG}
}

# ==============================================================================
# running config
# ==============================================================================

DEFAULT_CONF=templates/redis.conf
REDIS_SERVER=redis-5.0.10/src/redis-server

check_id() {
    case ${ID} in
        "r0") 
            ROLE=master
            PORT=63790
            ;;
        "r1") 
            ROLE=slave
            PORT=63791
            MASTER_HOST=127.0.0.1
            MASTER_PORT=63790
            ;;
        "r2")
            ROLE=slave
            PORT=63792
            MASTER_HOST=127.0.0.1
            MASTER_PORT=63790
            ;;
        "s0") 
            ROLE=sentinel
            PORT=63800
            MASTER_HOST=127.0.0.1
            MASTER_PORT=63790
            QUORUM=2
            ;;
        "s1") 
            ROLE=sentinel
            PORT=63801
            MASTER_HOST=127.0.0.1
            MASTER_PORT=63790
            QUORUM=2
            ;;
        "s2")
            ROLE=sentinel
            PORT=63802
            MASTER_HOST=127.0.0.1
            MASTER_PORT=63790
            QUORUM=2
            ;;
    esac

    echo "func: ${FUNC}, role: ${ROLE}, port: ${PORT}, master_host: ${MASTER_HOST}, master_port: ${MASTER_PORT}, quorum: ${QUORUM}"
}

if [ $# -gt 2 ]; then
    for id in $@
    do
        if [ $id != $1 ]; then
            $0 $1 $id
        fi
    done
elif [ $# -eq 2 ]; then
    FUNC=$1
    ID=$2
    check_id
    case ${FUNC} in
        "-i"|"init")
            init_redis
            ;;
        "-r"|"run")
            run_redis
            ;;
        "-k"|"kill")
            kill_redis
            ;;
        "-s"|"status")
            status_redis
            ;;
        "-l"|"log")
            log_redis
            ;;
    esac
else
    case ${FUNC} in
        "-b"|"build")
            build
            ;;
        *)
            echo "usage $0"
            echo "    -b build"
            echo "    -i init (id)"
            echo "    -r run (id)"
            echo "    -s status (id)"
            echo "    -k kill (id)"
            ;;
    esac
fi

