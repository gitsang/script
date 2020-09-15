# .bashrc

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

export GOROOT=/usr/local/go
export GOPATH=/root/go
export GOBIN=$GOPATH/bin
export GOPROXY=https://goproxy.cn
export GO111MODULE=on
export GONOPROXY=*.yealink.com
export GONOSUMDB=*.yealink.com
export GOPRIVATE=gitcode.yealink.com

export PATH=$PATH:$GOROOT/bin:$GOBIN
