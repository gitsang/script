#!/bin/bash

# gen certs
mkdir -p certs
openssl req \
    -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key \
    -x509 -days 365 -out certs/domain.crt

# docker run
docker run -d \
    --name registry \
    --restart always \
    -p 5000:5000 \
    -v `pwd`certs:/certs \
    -v /mnt/docker/data/registry:/var/lib/registry \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
    registry:2
