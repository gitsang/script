#!/bin/bash

# =============== Environment Variable =============== #

# path
export PATH=$PATH:.
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./lib:./libs:.

# java
#export JAVA_HOME=/usr/local/java/jdk1.8.0_281
#export JRE_HOME=${JAVA_HOME}/jre
#export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
#export PATH=$PATH:${JAVA_HOME}/bin

# golang
export GOROOT=/usr/local/go
export GOPATH=/go
export GOBIN=$GOPATH/bin
export GOPROXY=https://goproxy.cn
export GO111MODULE=on
export PATH=$PATH:$GOROOT/bin:$GOBIN

# golang private
export GONOPROXY=*.sang.ink
export GONOSUMDB=*.sang.ink
export GOPRIVATE=gitcode.sang.ink

# libreoffice
export LibreOffice_PATH=/opt/libreoffice7.1/program
export PATH=$PATH:$LibreOffice_PATH

# =============== Color Option =============== #

PS1="\n\[\e[32m\]\u\[\e[37m\]@\h \[\e[35m\]\d \t \[\e[36m\]\w\[\e[0m\] \n\\$ "

LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=30;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

# =============== Common specific aliases and functions =============== #

# fuck
fuck() {
    if [ $# -eq 1 ] && [ "$1" == "-" ]; then
        su - root
    elif [ $# -gt 0 ]; then
        sudo $@
    else
        su root
    fi
}

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
alias ..5='cd ../../../../../'
alias ......='cd ../../../../../'
alias ..6='cd ../../../../../../'
alias ......='cd ../../../../../../'

# other
alias wip='curl cip.cc'
alias ports='netstat -ntlp | sort'
alias pss='ps auxf --sort=cmd | grep -v "\[*\]$" | grep -v -E "bash|ps -ef|grep"'
alias eplib='export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./lib && echo $LD_LIBRARY_PATH'
alias tailf='tail -f'
alias disk='df -h | grep -vE "overlay|tmpfs|shm|udev|efi"'
fixmod() {
    chmod 0644 `find ./ -type f`
    chmod 0755 `find ./ -type d`
}

# docker
alias drst='docker stop $(docker ps -aq) && docker rm $(docker ps -aq)'
alias dps='docker ps --format "{{.Names}}:\n\tid: {{.ID}}\n\timage: {{.Image}}\n\tcommand: {{.Command}}\n\tnetwork: {{.Networks}}\n\tmount: {{.Mounts}}\n\tports: {{.Ports}}\n\tstatus: {{.Status}}\n\tcreated: {{.RunningFor}}\n\tstatus: {{.State}}\n\tsize: {{.Size}}\n"'
alias rekcod="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nexdrew/rekcod"

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
    echo "gb      git branch"
    echo "gd      git diff"
    echo "gdt     git difftool"
    echo "gl      git log"
    echo "gls     git log --stat"
    echo "glp     git log -p"
    echo "ga      git add"
    echo "gaa     git add --all ."
    echo "gcm     git commit -m"
    echo "gps     git push"
    echo "gpl     git pull"
    echo "gf      git fetch"
    echo ""
    echo "gau     auto push"
    echo "gsubm   auto submit"
    echo "gpst    git push to new branch"
    echo "grb     git rebase -i [HEAD~]"
    echo "grst    git reset [-h cmtid] [-s cmtid]"
}
alias gs='git status'
alias gb='git branch'
alias gd='git diff'
alias gdt='git difftool'
alias gl='git log'
alias gls='git log --stat'
alias glp='git log -p'
alias ga='git add'
alias gaa='git add --all .'
alias gcm='git commit -m'
alias gps='git push'
alias gpl='git pull'
alias gf='git fetch'
gau() {
    BRANCH=`git branch | grep "*" | awk '{print $2}'`
    UPDATED=`git status | grep -E "modified|deleted|new file|renamed" | awk '{print $NF}' | xargs`

    git add --all ${UPDATED}
    git commit -m "update ${UPDATED}"
    git push origin ${BRANCH}
    git status
}
gsubm() {
    USER=chensx
    DATE=`date '+%Y%m%d_%H%M'`
    SRC_BRANCH=`git branch | grep "*" | awk '{print $2}'`
    SUBMIT_BRANCH=${1:-${SRC_BRANCH}}
    DST_BRANCH=${SUBMIT_BRANCH}_submit_${DATE}_${USER}
    while true; do
        echo -e "submit to branch \e[31m${SUBMIT_BRANCH}\e[0m_submit_${DATE}_\e[31m${USER}\e[0m, \c"
        read -r -p "continue? (Default:Y) [Y/n] " input
        case $input in
            [yY][eE][sS]|[yY]|"")
                git push origin ${SRC_BRANCH}:${DST_BRANCH}
                break
                ;;
            [nN][oO]|[nN])
                break
                ;;
            *)
                echo "Invalid input..." ;;
        esac
    done
}
gpst() {
    TYPE=${1}
    SUBJ=${2}
    USER=chensx
    SRC_BRANCH=`git branch | grep "*" | awk '{print $2}'`
    DST_BRANCH=${TYPE}-${SUBJ}-${USER}
    while true; do
        echo -e "submit to branch \e[31m${DST_BRANCH}\e[0m, \c"
        read -r -p "continue? (Default:Y) [Y/n] " input
        case $input in
            [yY][eE][sS]|[yY]|"")
                git push origin ${SRC_BRANCH}:${DST_BRANCH}
                break
                ;;
            [nN][oO]|[nN])
                break
                ;;
            *)
                echo "Invalid input..." ;;
        esac
    done
}
grb() {
    if [ ${#1} -gt 3 ]; then
        git rebase -i ${1}
    else
        git rebase -i HEAD~${1}
    fi
}
grst() {
    if [ ${1} == "-h" ]; then
        git reset --hard ${2}
    elif [ ${1} == "-s" ]; then
        git reset --soft ${2}
    else
        git reset $@
    fi
}

# trash
alias del='trash'
trash() {
    case "$1" in
        "help"|"-h")
            echo "usage: trash [ clean(-c) | recover(-r) | backup(-b) | help(-h) ]"
            ;;
        "recover"|"-r")
            TRASH_DIR=~/.trash
            REAL_PATH=`echo $@ | awk -F'-%TRASH%-' '{print $2}' | sed 's/##/\//g'`

            if [ -f "$REAL_PATH" ]; then
                echo "file exist: $REAL_PATH"
            elif [ -d "$REAL_PATH" ]; then
                echo "folder exist: $REAL_PATH"
            else
                mv $@ $REAL_PATH
                echo "recover $@ to $REAL_PATH"
            fi
            ;;
        "clean"|"-c")
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
            ;;
        "backup"|"-b")
            BACKUP_DIR=~/.trash
            REAL_PATH=`realpath $2`
            BACKUP_NAME=`realpath $2 | sed 's/\//##/g'`
            TIME=`date "+%Y%m%d-%H%M%S"`
            BACKUP_PATH=$BACKUP_DIR/$TIME-%BACKUP%-$BACKUP_NAME

            if [ "$REAL_PATH" != "/" ]; then
                mkdir -p $BACKUP_DIR
                cp -r $REAL_PATH $BACKUP_PATH
                echo "backup $REAL_PATH to $BACKUP_PATH"
            fi
            ;;
        *)
            TRASH_DIR=~/.trash
            REAL_PATH=`realpath $@`
            TRASH_NAME=`realpath $@ | sed 's/\//##/g'`
            TIME=`date "+%Y%m%d-%H%M%S"`
            TRASH_PATH=$TRASH_DIR/$TIME-%TRASH%-$TRASH_NAME

            if [ "$REAL_PATH" != "/" ]; then
                mkdir -p $TRASH_DIR
                mv $REAL_PATH $TRASH_PATH
                echo "del $REAL_PATH to $TRASH_PATH"
            fi
            ;;
    esac
}

# proxy
list_proxy() {
    echo http_proxy=$http_proxy
    echo https_proxy=$https_proxy
    echo ftp_proxy=$ftp_proxy
}
proxy() {
    PROXY_HOST=127.0.0.1
    case "$1" in
        "-l"|"--list")
            echo PROXY_HOST=$PROXY_HOST
            list_proxy
            ;;
        "-c"|"--clean")
            export {http,https,ftp}_proxy=""
            list_proxy
            ;;
        "-s"|"--set")
            case "$2" in
                "us")
                    export {http,https,ftp}_proxy="http://${PROXY_HOST}:1081";;
                "cn")
                    export {http,https,ftp}_proxy="http://${PROXY_HOST}:1082";;
                "co")
                    export {http,https,ftp}_proxy="http://${PROXY_HOST}:1083";;
                "hk")
                    export {http,https,ftp}_proxy="socks5://${PROXY_HOST}:1084";;
                *)
                    ;;
            esac
            list_proxy
            ;;
        *)
            echo "help:"
            echo "    -h, --help           help"
            echo "    -l, --list           list current proxy"
            echo "    -c, --clean          clean proxy"
            echo "    -s, --set [location] set proxy"
            echo "              us         Los Angeles"
            echo "              cn         Shanghai"
            echo "              co         Co."
            echo "              hk         Hong Kong"
            list_proxy
            ;;
    esac
}

dplhugo() {
    set -e
    npm run build
    rm -fr /var/www/home
    mv public /var/www/home
}
