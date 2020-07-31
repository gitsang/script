# .bashrc

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

PS1="\n\[\e[32m\]\u\[\e[37m\]@\h \[\e[35m\]\d \t \[\e[36m\]\w\[\e[0m\] \n\\$ "

export GOROOT=/usr/local/go
export GOPATH=/root/go
export GOBIN=$GOPATH/bin
export GOPROXY=https://goproxy.cn
export GO111MODULE=on

export PATH=$PATH:$GOROOT/bin:$GOBIN
