docker pull postgres
docker pull nextcloud

docker stop $(docker ps -aq) && docker rm $(docker ps -aq)
docker run -d --restart=always --name postgres -p 5432:5432 -v /data/postgresql:/var/lib/postgresql/data -e POSTGRES_PASSWORD=postgres postgres
docker run -d --restart=always --name nextcloud -p 8080:80 -v /data/nextcloud:/var/www/html -v /mnt:/mnt --link postgres:postgres nextcloud

#sudo autossh -fNR :18080:0.0.0.0:8080 root@aliyun.sang.pp.ua
