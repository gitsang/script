#!/bin/bash

PS1="\n\[\e[32m\]\u\[\e[37m\]@\h \[\e[35m\]\d \t \[\e[36m\]\w\[\e[0m\] \n\\$ "

# =============== Common specific aliases and functions =============== #

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
alias pss='ps auxf --sort=cmd | grep -v "\[*\]$" | grep -v -E "bash|ps -ef|grep"'
alias eplib='export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./lib && echo $LD_LIBRARY_PATH'
alias drst='docker stop $(docker ps -aq) && docker rm $(docker ps -aq)'

# jobs
alias j='jobs'
kj() {
    kill -9 %$@
}

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

# proxy
proxy() {
    case "$1" in 
        "-l"|"--list")
            echo http_proxy=$http_proxy
            echo https_proxy=$https_proxy
            echo ftp_proxy=$ftp_proxy
            ;;
        "-c"|"--clean")
            export {http,https,ftp}_proxy=""
            ;;
        "-s"|"--set")
            case "$2" in
                "la")
                    case "$3" in
                        "h"|"http") export {http,https,ftp}_proxy="http://localhost:1080";;
                        "s"|"socks") export {http,https,ftp}_proxy="http://localhost:1081";;
                        *) echo "type error";;
                    esac;;
                "hk")
                    case "$3" in
                        "h"|"http") export {http,https,ftp}_proxy="http://localhost:1090";;
                        "s"|"socks") export {http,https,ftp}_proxy="http://localhost:1091";;
                        *) echo "type error";;
                    esac;;
                "yl")
                    case "$3" in
                        "h"|"http") export {http,https,ftp}_proxy="http://localhost:1070";;
                        "s"|"socks") export {http,https,ftp}_proxy="http://localhost:1071";;
                        "l"|"lan") export {http,https,ftp}_proxy="netproxy.yealinkops.com:8123";;
                        *) echo "type error";;
                    esac;;
                *)
                    echo "set uasge:"
                    echo "    proxy --set [location] [type]"
                    echo "location:"
                    echo "    la          Los Angeles"
                    echo "    hk          HongKong"
                    echo "    yl          yealink"
                    echo "type:"
                    echo "    h, http     http_proxy"
                    echo "    s, socks    socks_proxy"
                    echo "    l, lan     only yealink lan proxy use it"
                    ;;
            esac;;
        *)
            echo "help:"
            echo "    -h, --help                  help"
            echo "    -l, --list                  list current proxy and optional proxy"
            echo "    -c, --clean                 clean proxy"
            echo "    -s, --set [location] [type] set proxy, type \`proxy -s\` for more help"
            echo "example:"
            echo "    proxy --set la http"
            ;;
    esac
}

tunnel() {
    SECTOR=x
    case "$1" in
        "init")
            yum install -y autossh
            ssh-keygen
            ssh-copy-id -i ~/.ssh/id_rsa.pub -p 22 root@aliyun.sang.pp.ua
            ;;
        "build")
            autossh -NR :${SECTOR}0022:0.0.0.0:22  -M ${SECTOR}0022:22  -f root@aliyun.sang.pp.ua
            autossh -NR :${SECTOR}0443:0.0.0.0:443 -M ${SECTOR}0443:443 -f root@aliyun.sang.pp.ua
            ;;
        "close")
            ps auxf | grep ssh | grep NR | grep -v grep | awk '{print $2}' | xargs -i -t kill -9 {}
            ;;
        *)
            echo "help:"
            echo "    tunnel [init|build|close]"
            ps auxf | grep ssh | grep NR | grep -v grep
            ;;
    esac
}

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
