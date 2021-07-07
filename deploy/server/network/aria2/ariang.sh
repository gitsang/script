#!/bin/bash

docker run -d \
    --name ariang \
    --restart always \
    --log-opt max-size=1m \
    -p 6880:6880 \
    p3terx/ariang
