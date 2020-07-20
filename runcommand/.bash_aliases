#!/bin/bash

# =============== Common specific aliases and functions =============== #

# trash
trash() {
    if [[ "$@" == "/" ]]; then
        echo "can not trash root path"
        return
    fi

    TRASH_DIR=~/.trash
    TIME=`date "+%Y-%m-%d-%H:%M:%S"`
    mkdir -p $TRASH_DIR
    mv "$@" $TRASH_DIR/$TIME-$@

    # clean up trash
    MAX_TRASH_SIZE=20000000
    TRASH_SIZE=`du --max-depth=0 ~/.trash | awk '{print $1}'`
    while [ $TRASH_SIZE -gt $MAX_TRASH_SIZE ]
    do
        echo "trash-size: $TRASH_SIZE > $MAX_TRASH_SIZE clean up:" && ls | grep -v total | head -1
        cd ~/.trash
        ls | grep -v total | head -1 | xargs -i -n1 rm -fr {}
        TRASH_SIZE=`du --max-depth=0 ~/.trash | awk '{print $1}'`
    done
    echo "trash-size: $TRASH_SIZE"
    cd -
}
alias del='trash'

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
alias eplib='export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./lib && echo $LD_LIBRARY_PATH'
alias pss='ps -ef | grep -v "\[*\]" | grep -v sshd | grep -v bash | grep -v "ps -ef" | grep -v cloudmonitor'
alias dreset='docker stop $(docker ps -aq) && docker rm $(docker ps -aq)'

# =============== User specific aliases and functions =============== #

# git-hugo-blog
hpull() {
    git pull origin master
    cd gitsang.github.io
    git pull origin master
    cd -
}
hpush() {
    if [ $# -lt 1 ]; then
        echo "usage: hpush <commit content>"
        return
    fi
    COMMIT=$1
    git add --all
    git commit -m "$COMMIT"
    git push origin master
    git push gitee master
    hugo
    cd gitsang.github.io
    git add --all
    git commit -m "$COMMIT"
    git push origin master
    git push gitee master
    cd -
}

# jobs
alias j='jobs'
kj() {
    kill -9 %$@
}

# socks5
alias mproxy='export {http,https,ftp}_proxy="socks5://10.71.2.110:10808"'
alias yproxy='export {http,https,ftp}_proxy="netproxy.yealinkops.com:8123" && export no_proxy="yealinkops.com, yealink.com, onylyum.com, 127.0.0.1, localhost, 0.0.0.0"'
alias nproxy='export {http,https,ftp}_proxy=""'

# postgres
alias pp='/usr/local/pgsql/bin/psql -U postgres -d testdb -h localhost -p'
alias psql='/usr/local/pgsql/bin/psql -U postgres'

# gitlab
alias upimg='git add image.yaml && git commit -m "update image.yaml" && git push'

# redis
alias rc='/root/project/nredis/src/redis-cli'
alias rcr='/root/project/nredis/src/redis-cli -h 10.120.0.178 -p 9079'

# mq
mq() {
    /root/jrmqtg/bin/mqadmin $@ -n localhost:9876
}
