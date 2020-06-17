#!/bin/bash

#=================================#
OPT=$1
PORT=63790
HOST=127.0.0.1
REPO=/root/workspace/nredis-branch-test-dev
DATA=${REPO}/sentinel/data
SRV=${REPO}/src/redis-server
#=================================#

#===============================================#
# help:
#     
# use: `./r.sh config` to create config file
# use: `./r.sh clean` to run with clean up
# use: `./r.sh clean` to run without clean up
#===============================================#

ulimit -c unlimited
ulimit -s 102400

# create config file
if [ "${OPT}" == "config" ]
then
    rm -f redis.conf
    echo "port 6390" >> redis.conf
    echo "bind 0.0.0.0" >> redis.conf
    echo "appendonly yes" >> redis.conf
    echo "appendfilename \"nydbc.aof\"" >> redis.conf
    echo "auto-aof-rewrite-percentage 100" >> redis.conf
    echo "auto-aof-rewrite-min-size 64mb" >> redis.conf
    echo "aof-use-rdb-preamble yes" >> redis.conf
    echo "loadmodule \"${REPO}/ypushc/libypushc.so\"" >> redis.conf
    echo "loadmodule \"${REPO}/ym/libnym.so\"" >> redis.conf
    echo "loglevel debug" >> redis.conf
    echo "aof_pos 1" >> redis.conf
    echo "idc_flag 0" >> redis.conf
    echo "if_send_to_check 0" >> redis.conf
    echo "run_exphash 1" >> redis.conf
    cp -f redis.conf slave.conf
    echo "" > sentinel.conf
    exit
fi

# clean
if [ "${OPT}" == "clean" ]
then
    rm ${DATA} -fr
    ps aux | grep -E "redis-server|exphash|redis-sentinel" | grep -v grep | awk '{print $2}' | xargs -i -t kill -9 {}
fi
mkdir -p ${DATA}/

# master
    CONFIGFILE=${DATA}/${PORT}/${PORT}.conf
    NOHUPFILE=${DATA}/${PORT}/${PORT}.nohup
    LOGFILE=${DATA}/${PORT}/${PORT}.log
    mkdir -p ${DATA}/${PORT}
    cp -f redis.conf ${CONFIGFILE}
    echo "port ${PORT}" >> ${CONFIGFILE}
    echo "dir \"${DATA}/${PORT}\"" >> ${CONFIGFILE}
    echo "logfile \"${LOGFILE}\"" >> ${CONFIGFILE}
    nohup ${SRV} ${CONFIGFILE} > ${NOHUPFILE} 2>&1 &
    sleep 1

# slave
for PORTS in $[${PORT}+1] $[${PORT}+2]
do
    CONFIGFILE=${DATA}/${PORTS}/${PORTS}.conf
    NOHUPFILE=${DATA}/${PORTS}/${PORTS}.nohup
    LOGFILE=${DATA}/${PORTS}/${PORTS}.log
    mkdir -p ${DATA}/${PORTS}
    cp -f slave.conf ${CONFIGFILE}
    echo "port ${PORTS}" >> ${CONFIGFILE}
    echo "dir \"${DATA}/${PORTS}\"" >> ${CONFIGFILE}
    echo "logfile \"${LOGFILE}\"" >> ${CONFIGFILE}
    echo "replicaof ${HOST} ${PORT}" >> ${CONFIGFILE}
    nohup ${SRV} ${CONFIGFILE} > ${NOHUPFILE} 2>&1 &
    sleep 1
done

# sentinel
for PORTS in $[${PORT}+10] $[${PORT}+11] $[${PORT}+12] 
do
    CONFIGFILE=${DATA}/${PORTS}/${PORTS}.conf
    NOHUPFILE=${DATA}/${PORTS}/${PORTS}.nohup
    LOGFILE=${DATA}/${PORTS}/${PORTS}.log
    mkdir -p ${DATA}/${PORTS}
    cp -f sentinel.conf ${CONFIGFILE}
    echo "port ${PORTS}" >> ${CONFIGFILE}
    echo "dir \"${DATA}/${PORTS}\"" >> ${CONFIGFILE}
    echo "logfile \"${LOGFILE}\"" >> ${CONFIGFILE}
    echo "sentinel monitor master ${HOST} ${PORT} 2" >> ${CONFIGFILE}
    nohup ${SRV} ${CONFIGFILE} > ${NOHUPFILE} --sentinel 2>&1 &
    sleep 1
done

ps -ef | grep -E "redis-server|exphash|redis-sentinel" | grep -v grep
