docker rm -f transfer
docker run -d \
    --name transfer \
    --restart=always \
    -p 8080:8080 \
    -v /share/transit/:/transit/ \
    dutchcoders/transfer.sh \
    --provider local \
    --basedir /transit/
