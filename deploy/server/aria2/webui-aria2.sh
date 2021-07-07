#!/bin/bash

docker run -d \
    --name webui-aria2 \
    --tty \
    --interactive \
    --restart always \
    -p 6881:80 \
    timonier/webui-aria2

