#!/bin/bash

# =============== Common specific aliases and functions =============== #

# trash
trash-clean() {
    TRASH_DIR=~/.trash
    MAX_TRASH_SIZE=20000000
    TRASH_SIZE=`du --max-depth=0 $TRASH_DIR | awk '{print $1}'`
    while [ $TRASH_SIZE -gt $MAX_TRASH_SIZE ]
    do
        echo "trash-size: $TRASH_SIZE > $MAX_TRASH_SIZE clean up:" && ls $TRASH_DIR | grep -v total | head -1
        ls $TRASH_DIR | grep -v total | head -1 | xargs -i -n1 rm -fr $TRASH_DIR/{}
        TRASH_SIZE=`du --max-depth=0 $TRASH_DIR | awk '{print $1}'`
    done
    echo "trash-size: $TRASH_SIZE"
}
trash-recover() {
    TRASH_DIR=~/.trash
    REAL_PATH=`echo $@ | awk -F'-%trash%-' '{ print $2 }' | sed 's/^^/\//g'`
    if [ -f "$REAL_PATH" ]; then
        echo "file exist: $REAL_PATH"
    elif [ -d "$REAL_PATH" ]; then
        echo "folder exist: $REAL_PATH"
    else
        mv $@ $REAL_PATH
    fi
}
trash() {
    TRASH_DIR=~/.trash
    REAL_PATH=`realpath $@`
    TRASH_NAME=`realpath $@ | sed 's/\//^^/g'`
    TIME=`date "+%Y-%m-%d-%H:%M:%S"`
    TRASH_PATH=$TRASH_DIR/$TIME-%trash%-$TRASH_NAME

    if [ "$REAL_PATH" != "/" ]; then
        mkdir -p $TRASH_DIR
        mv $REAL_PATH $TRASH_PATH
        echo "del $REAL_PATH to $TRASH_PATH"
    fi
    trash-clean
}
alias del='trash'
alias tcl='trash-clean'
alias tre='trash-recover'

# list
alias l='ls'
alias ll='ls -l'
alias la='ls -a'
alias lh='ls -lh'
alias lla='ls -la'

# file system
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# change dir
alias ..='cd ../'
alias ...='cd ../../'
alias ..3='cd ../../../'
alias ....='cd ../../../'
alias ..4='cd ../../../../'
alias .....='cd ../../../../'
alias ..5='cd ../../../../'
alias ......='cd ../../../../'

# other
alias vi='vim'
alias ports='netstat -ntlp'
alias pss='ps -ef --sort=cmd | grep -v "\[*\]" | grep -v -E "sshd|sftp" | grep -v -E "/usr/sbin/crond|/usr/lib/systemd" | grep -v -E "bash|ps -ef"'
alias eplib='export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./lib && echo $LD_LIBRARY_PATH'
alias dreset='docker stop $(docker ps -aq) && docker rm $(docker ps -aq)'

# jobs
alias j='jobs'
kj() {
    kill -9 %$@
}

# proxy
alias myproxyhttp='export {http,https,ftp}_proxy="http://localhost:1080"'
alias myproxysocks='export {http,https,ftp}_proxy="socks5://localhost:1081"'
alias netproxyhttp='export {http,https,ftp}_proxy="http://localhost:1090"'
alias netproxysocks='export {http,https,ftp}_proxy="socks5://localhost:1091"'
alias ylproxyhttp='export {http,https,ftp}_proxy="http://localhost:1070"'
alias ylproxysocks='export {http,https,ftp}_proxy="socks5://localhost:1071"'
alias ylproxy='export {http,https,ftp}_proxy="netproxy.yealinkops.com:8123"'
alias nproxy='export {http,https,ftp}_proxy=""'
alias eproxy='echo http_proxy=$http_proxy && echo https_proxy=$https_proxy && echo ftp_proxy=$ftp_proxy'

# autossh-tunnel
build_autossh_tunnel() {
    USER=$1
    REMOTE_ADDR=$2
    REMOTE_PORT=$3
    LOCAL_PORT=$4
    PID=`ps -ef | grep "autossh -NR" | grep ":${REMOTE_PORT}:0.0.0.0:${LOCAL_PORT}" | awk '{printf $2}'`
    if [ ! -n "$PID" ]; then
        su - $USER -c "autossh -fNR :${REMOTE_PORT}:0.0.0.0:${LOCAL_PORT} ${REMOTE_ADDR}"
    fi
}
autossh_tunnel() {
    if [ "$1" == "build" ]; then
        if [ $# -lt 3 ]; then
            echo "usage: autunn remote_port local_port"
        else
            build_autossh_tunnel root root@47.103.32.175 $2 $3
        fi
    elif [ "$1" == "kill" ]; then
        ps -ef --sort=cmd | grep autossh | grep -v grep | awk '{print $2}' | xargs -i -t kill -9 {}
    else
        ps -ef --sort=cmd | grep autossh | grep -v grep
    fi
}
alias autunn='autossh_tunnel'

# ssh-tunnel
build_ssh_tunnel() {
    USER=$1
    REMOTE_ADDR=$2
    REMOTE_PORT=$3
    LOCAL_PORT=$4
    PID=`ps -ef | grep ssh | grep fNR | grep ":${REMOTE_PORT}:0.0.0.0:${LOCAL_PORT}" | awk '{printf $2}'`
    if [ ! -n "$PID" ]; then
        su - $USER -c "ssh -fNR :${REMOTE_PORT}:0.0.0.0:${LOCAL_PORT} ${REMOTE_ADDR}"
    fi
}
ssh_tunnel() {
    if [ "$1" == "build" ]; then
        if [ $# -lt 3 ]; then
            echo "usage: tunn remote_port local_port"
        else
            build_ssh_tunnel root root@47.103.32.175 $2 $3
        fi
    elif [ "$1" == "kill" ]; then
        ps -ef --sort=cmd | grep ssh | grep fNR | grep -v grep | awk '{print $2}' | xargs -i -t kill -9 {}
    else
        ps -ef --sort=cmd | grep ssh | grep fNR | grep -v grep
    fi
}
alias tunn='ssh_tunnel'

# =============== User specific aliases and functions =============== #

# gitlab
alias upimg='git add image.yaml && git commit -m "update image.yaml" && git push'

# postgres
alias pp='/usr/local/pgsql/bin/psql -U postgres -d testdb -h localhost -p'
alias psql='/usr/local/pgsql/bin/psql -U postgres'

# redis
alias rc='/root/project/nredis/src/redis-cli'
alias rcr='/root/project/nredis/src/redis-cli -h 10.120.0.178 -p 9079'

# mq
mq() {
    /root/jrmqtg/bin/mqadmin $@ -n localhost:9876
}
