docker run \
    --name registry \
    --restart always \
    -p 5000:5000 \
    -d registry.docker-cn.com/library/registry
