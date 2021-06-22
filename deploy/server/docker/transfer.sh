docker rm -f transfer
docker run -d \
    -p 10081:8080 \
    --name transfer \
    -v /share/transit/:/transit/ \
    dutchcoders/transfer.sh \
    --provider local \
    --basedir /transit/
