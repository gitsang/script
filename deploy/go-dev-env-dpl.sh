# 1. Golang

## 1.1 install dependences

yum install wget git vim -y
wget https://golang.org/dl/go1.14.6.linux-amd64.tar.gz -O /root/package/
tar zxvf /root/package/go1.14.6.linux-amd64.tar.gz -C /usr/local/

# 1.2 make dir

mkdir -p /root/go/{src,pkg,bin}
mkdir -p /root/project/
mkdir -p /root/package/

## 1.3 GO env

echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export GOPATH=/root/go" >> ~/.bashrc
echo "export GOBIN=$GOPATH/bin" >> ~/.bashrc
echo "export GOPROXY=https://goproxy.cn" >> ~/.bashrc
echo "export GO111MODULE=auto" >> ~/.bashrc
echo "export PATH=$PATH:$GOROOT/bin:$GOBIN" >> ~/.bashrc

# 2. Vim

## 2.1 install python3

yum install -y python python3 python3-pip python3-devel

## 2.2 update to vim8

git clone https://github.com/vim/vim.git ~/package/vim
cd ~/package/vim
./configure  --enable-python3interp=yes
make -j 8
make install
vim --version

## 2.3 set vimrc

cd /root/project/
git clone http://github.com/gitsang/script
cp /root/project/script/runcommand/* /root/

## 2.4 install plugin

echo vim
echo :PluginInstall
echo :GoUpdateBinaries

## 2.4 install YCM

git clone https://github.com/Valloric/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe
cd .vim/bundle/YouCompleteMe/
git submodule update --init --recursive
python3 install.py --go-completer
cp ~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py ~/

# 3. Golang project

## 3.1 gRPC install

### 3.1.1 install protoc

wget https://github.com/protocolbuffers/protobuf/releases/download/v3.12.4/protoc-3.12.4-linux-x86_64.zip -O /root/package/
unzip /root/package/protoc-3.12.4-linux-x86_64.zip -d /root/package/protoc-3.12.4-linux-x86_64/
cp /root/package/protoc-3.12.4-linux-x86_64/bin/* /usr/local/bin/
cp /root/package/protoc-3.12.4-linux-x86_64/include/* /usr/local/include/
rm /root/package/protoc-3.12.4-linux-x86_64/ -fr
go get -u github.com/golang/protobuf/protoc-gen-go

### 3.1.2 go get grpc

go get -u google.golang.org/grpc

## 3.2 Tidb

### 3.2.1 tidb-docker-compose

git clone https://github.com/pingcap/tidb-docker-compose.git ~/project/tidb-docker-compose
cd ~/projec/tidb-docker-compose
docker-compose pull && docker-compose up -d

### 3.2.2 sql driver

go get -u github.com/go-sql-driver/mysql

### 3.2.3 install client

pip3 install mycli

