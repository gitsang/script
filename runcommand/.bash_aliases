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
