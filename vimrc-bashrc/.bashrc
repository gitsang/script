# .bashrc

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
alias la='ls -a'
alias lh='ls -lh'
alias lla='ls -la'

# system
alias vi='vim'
alias ports='netstat -tlnpu'

# cd
alias ..='cd ../'
alias ...='cd ../../'
alias ..3='cd ../../../'
alias ....='cd ../../../'
alias ..4='cd ../../../../'
alias .....='cd ../../../../'
alias ..5='cd ../../../../'
alias ......='cd ../../../../'

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

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# envionment variables
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.252.b09-2.el7_8.x86_64
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin

