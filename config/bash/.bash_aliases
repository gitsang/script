#!/bin/bash

# =============== Environment Variable =============== #

export GOROOT=/usr/local/go
export GOPATH=/root/go
export GOBIN=$GOPATH/bin
export GOPROXY=https://goproxy.cn
export GO111MODULE=on
export GONOPROXY=*.sang.pp.ua
export GONOSUMDB=*.sang.pp.ua
export GOPRIVATE=gitcode.sang.pp.ua
export PATH=$PATH:$GOROOT/bin:$GOBIN

# =============== Color Option =============== #

PS1="\n\[\e[32m\]\u\[\e[37m\]@\h \[\e[35m\]\d \t \[\e[36m\]\w\[\e[0m\] \n\\$ "

LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=30;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

# =============== Common specific aliases and functions =============== #

# list
alias l='ls'
alias ll='ls -l'
alias lh='ls -lh'
alias la='ls -la'

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
alias wip='curl ifconfig.me'
alias ports='netstat -ntlp'
alias pss='ps auxf --sort=cmd | grep -v "\[*\]$" | grep -v -E "bash|ps -ef|grep"'
alias eplib='export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./lib && echo $LD_LIBRARY_PATH'
alias drst='docker stop $(docker ps -aq) && docker rm $(docker ps -aq)'

# vim
alias vi='vim'
alias vnp='vim --noplugin'
alias vit='vim --startuptime startuptime.log'

# cache
dropcaches() {
    free -h | grep Mem
    sync; echo 1 > /proc/sys/vm/drop_caches
    sync; echo 2 > /proc/sys/vm/drop_caches
    sync; echo 3 > /proc/sys/vm/drop_caches
    free -h | grep Mem
}

# jobs
alias j='jobs'
kj() {
    kill -9 %$@
}

# git
gh() {
    echo "gh      help"
    echo "gs      git status"
    echo "gd      git diff"
    echo "gl      git log"
    echo "ga      git add"
    echo "gaa     git add --all ."
    echo "gcm     git commit -m"
    echo "gps     git push"
    echo "gpl     git pull"
    echo "gau     auto push"
    echo "gsubmit auto submit"
}
alias gs='git status'
alias gd='git diff'
alias gl='git log'
alias ga='git add'
alias gaa='git add --all .'
alias gcm='git commit -m'
alias gps='git push'
alias gpl='git pull'
gau() {
    BRANCH=`git branch | grep "*" | awk '{print $2}'`
    UPDATED=`git status | grep -E "modified|deleted|new file|renamed" | awk '{print $NF}' | xargs`

    git add --all ${UPDATED}
    git commit -m "update ${UPDATED}"
    git push origin ${BRANCH}
    git status
}
gsubmit() {
    BRANCH=`git branch | grep "*" | awk '{print $2}'`
    DATE=`date '+%Y%m%d_%H%M'`
    USER=chensx
    git push origin ${BRANCH}:master-dev_submit_${DATE}_${USER}
}

# trash
alias del='trash'
trash() {
    T_DIR=~/.trash
    case "$1" in 
        "help"|"-h")
            echo "usage: trash [ clean(-c) | recover(-r) | backup(-b) | help(-h) ]"
            ;;
        "recover"|"-r")
            T_NAME=$2
            if [ "${T_NAME}" == "" ]; then
                T_NAME=`ls ${T_DIR} | grep -v total | tail -1`
            fi
            T_REAL=`echo ${T_NAME} | awk -F'-%TRASH%-' '{print $2}' | sed 's/##/\//g'`
            T_REAL_DIR=`dirname ${T_REAL}`
            if [ -f "${T_REAL}" ]; then
                echo "file exist: ${T_REAL}"
            elif [ -d "${T_REAL}" ]; then
                echo "folder exist: ${T_REAL}"
            else
                mkdir -p ${T_REAL_DIR}
                mv ${T_DIR}/${T_NAME} ${T_REAL}
                echo "recover ${T_NAME} to ${T_REAL}"
            fi
            ;;
        "clean"|"-c")
            T_MAX=20000000
            T_SIZE=`du --max-depth=0 ${T_DIR} | awk '{print $1}'`
            while [ ${T_SIZE} -gt ${T_MAX} ]
            do
                echo "trash-size: ${T_SIZE} > ${T_MAX} clean up:" && ls ${T_DIR} | grep -v total | head -1
                ls ${T_DIR} | grep -v total | head -1 | xargs -i -n1 rm -fr ${T_DIR}/{}
                T_SIZE=`du --max-depth=0 ${T_DIR} | awk '{print $1}'`
            done
            echo "trash-size: ${T_SIZE}"
            ;;
        "backup"|"-b")
            T_ORIGIN=$2
            T_FLAG=%BACKUP%
            T_REAL=`realpath ${T_ORIGIN}`
            T_NAME=`realpath ${T_ORIGIN} | sed 's/\//##/g'`
            T_TIME=`date "+%Y%m%d-%H%M%S"`
            T_PATH=${T_DIR}/${T_TIME}-${T_FLAG}-${T_NAME}
            if [ "${T_REAL}" != "/" ]; then
                mkdir -p ${T_DIR}
                mv ${T_REAL} ${T_PATH}
                echo "del ${T_REAL} to ${T_PATH}"
            fi
            ;;
        *)
            T_ORIGIN=$1
            T_FLAG=%TRASH%
            T_REAL=`realpath ${T_ORIGIN}`
            T_NAME=`realpath ${T_ORIGIN} | sed 's/\//##/g'`
            T_TIME=`date "+%Y%m%d-%H%M%S"`
            T_PATH=${T_DIR}/${T_TIME}-${T_FLAG}-${T_NAME}
            if [ "${T_REAL}" != "/" ]; then
                mkdir -p ${T_DIR}
                mv ${T_REAL} ${T_PATH}
                echo "del ${T_REAL} to ${T_PATH}"
            fi
            ;;
    esac
}

# proxy
proxy() {
    PROXY_HOST=127.0.0.1
    echo "PROXY_HOST=${PROXY_HOST}"
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
                        "h"|"http") export {http,https,ftp}_proxy="http://${PROXY_HOST}:1080";;
                        "s"|"socks") export {http,https,ftp}_proxy="socks5://${PROXY_HOST}:1081";;
                        *) echo "type error";;
                    esac;;
                "yl")
                    case "$3" in
                        "h"|"http") export {http,https,ftp}_proxy="http://${PROXY_HOST}:1070";;
                        "s"|"socks") export {http,https,ftp}_proxy="socks5://${PROXY_HOST}:1071";;
                        "l"|"lan") export {http,https,ftp}_proxy="netproxy.yealinkops.com:8123";;
                        *) echo "type error";;
                    esac;;
                *)
                    ;;
            esac;;
        *)
            echo "help:"
            echo "    -h, --help                     help"
            echo "    -l, --list                     list current proxy"
            echo "    -c, --clean                    clean proxy"
            echo "    -s, --set [location] [type]    set proxy"
            echo "              location:"
            echo "                  la          Los Angeles"
            echo "                  yl          yealink"
            echo "              type:"
            echo "                  h, http     http proxy"
            echo "                  s, socks    socks proxy"
            echo "                  l, lan      internal proxy"
            ;;
    esac
}

