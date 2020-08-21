# NextCloud Docker Install

## Install Docker

### 1. Using Aliyun Script

```sh
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```

### 2. install manually

```sh
# step 1: 安装必要的一些系统工具
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
# Step 2: 添加软件源信息
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# Step 3: 更新并安装 Docker-CE
sudo yum makecache fast
sudo yum -y install docker-ce
# Step 4: 开启Docker服务
sudo service docker start
```

### 3. 镜像加速

```sh
vi /etc/docker/daemon.json
```

```json
{
    "registry-mirrors": ["https://[系统分配前缀].mirror.aliyuncs.com"]
}
```

获取专属加速服务：https://cr.console.aliyun.com/?spm=a2c6h.12873639.0.0.5cc13b0c6McCDy

```sh
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## Docker Pull and Run

```sh
docker pull postgres
docker pull nextcloud
```

```sh
docker stop $(docker ps -aq) && docker rm $(docker ps -aq)
docker run -d --restart=always --name postgres -p 5432:5432 -v /data/postgresql:/var/lib/postgresql/data -e POSTGRES_PASSWORD=postgres postgres
docker run -d --restart=always --name nextcloud -p 8080:80 -v /data/nextcloud:/var/www/html --link postgres:postgres nextcloud
```

## ssh tunnel

```sh
sudo autossh -fNR :18080:0.0.0.0:8080 root@aliyun.sang.pp.ua
```
