# ~/.bash_aliases

# =============== Common specific aliases and functions =============== #

# file
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

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

# system
alias vi='vim'
alias ports='netstat -ntlp'

# cd
alias ..='cd ../'
alias ...='cd ../../'
alias ..3='cd ../../../'
alias ....='cd ../../../'
alias ..4='cd ../../../../'
alias .....='cd ../../../../'
alias ..5='cd ../../../../'
alias ......='cd ../../../../'

# process
alias pss='ps -ef | grep -v "\[*\]" | grep -v sshd | grep -v bash | grep -v "ps -ef"'

# docker
alias dreset='docker stop $(docker ps -aq) && docker rm $(docker ps -aq)'

# PS1
PS1="\n\[\e[32m\]\u\[\e[37m\]@\h \[\e[35m\]\d \t \[\e[36m\]\w\[\e[0m\] \n\\$ "

# =============== User specific aliases and functions =============== #

# git-hugo-blog
hpull() {
    git pull
    cd gitsang.github.io
    git pull
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
    git push
    hugo
    cd gitsang.github.io
    git add --all
    git commit -m "$COMMIT"
    git push
}

# =============== Source global definitions =============== #
