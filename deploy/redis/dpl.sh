# ==============================================================================
# readme
# ==============================================================================
#
# 该脚本适配于 redis-v5，其他版本不一定适用
# 使用前请先确认 "running config" 项目下的配置正确，包括 redis-cli 位置，ip，端口等
#
# 使用方式：
# ./dpl option [id]
# option:
#     -b build
#     -i init [id]   初始化数据目录和配置文件
#     -r run [id]    运行 redis
#     -s status [id] 查看 redis 运行状态
#     -k kill [id]   结束 redis 进程
#     -l log [id]    监控日志文件
#
# 脚本使用 ID 来管理 redis 实例，如需添加新的实例，可在 check_id() 函数内添加对应参数
# id 值为 all 时，会将命令应用到所有已配置的实例，配置项为 ALL_INSTANCE
#
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

# redis-server path
REDIS_SERVER=redis-5.0.10/src/redis-server
ALL_INSTANCE=r0 r1 r2 s0 s1 s2

# redis instance manager
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

    echo "option: ${OPT}, role: ${ROLE}, port: ${PORT}, master_host: ${MASTER_HOST}, master_port: ${MASTER_PORT}, quorum: ${QUORUM}"
}

# shell param manager
if [ $# -gt 2 ]; then
    for id in $@
    do
        if [ $id != $1 ]; then
            $0 $1 $id
        fi
    done
elif [ $# -eq 2 ]; then
    OPT=$1
    ID=$2
    if [ ${ID} == "all" ]; then
        $0 ${OPT} ${ALL_INSTANCE}
        exit
    fi
    check_id
    case ${OPT} in
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
    case ${OPT} in
        "-b"|"build")
            build
            ;;
        *)
            echo "[warn] checkout config under 'running config' tag before using"
            echo "usage $0 option [id]"
            echo "option:"
            echo "    -b build"
            echo "    -i init [id]   init data path and config file"
            echo "    -r run [id]    run redis instance"
            echo "    -s status [id] get process status"
            echo "    -k kill [id]   kill process"
            echo "    -l log [id]    tail log"
            echo "id list is defined in check_id() function"
            echo "when id equal 'all', script will apply option at all id that config in ALL_INSTANCE"
            ;;
    esac
fi

