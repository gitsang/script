
mkdir -p /srv/gitlab
export GITLAB_HOME=/srv/gitlab
docker run --detach \
  --hostname sh.sang.pp.ua \
  --publish 30443:443 --publish 30080:80 --publish 30022:22 \
  --name gitlab \
  --restart always \
  --volume $GITLAB_HOME/config:/etc/gitlab \
  --volume $GITLAB_HOME/logs:/var/log/gitlab \
  --volume $GITLAB_HOME/data:/var/opt/gitlab \
  gitlab/gitlab-ce:latest
