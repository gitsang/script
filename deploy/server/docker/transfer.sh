docker rm -f transfer
docker run -d \
    --name transfer \
    --restart=always \
    -p 8082:8080 \
    -v /share/transit/:/transit/ \
    dutchcoders/transfer.sh \
    --provider local \
    --basedir /transit/
