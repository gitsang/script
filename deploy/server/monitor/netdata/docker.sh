#!/bin/bash

docker rm -f netdata
docker run -d \
    --name=netdata \
    -p 19999:19999 \
    -v /proc:/host/proc:ro \
    -v /sys:/host/sys:ro \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    --cap-add SYS_PTRACE \
    --security-opt apparmor=unconfined \
    netdata/netdata

#    -v `pwd`/web/dashboard_info.js:/usr/share/netdata/web/dashboard_info.js \
#    -v `pwd`/web/dashboard.js:/usr/share/netdata/web/dashboard.js \
#    -v `pwd`/web/index.html:/usr/share/netdata/web/index.html \
#    -v `pwd`/web/main.js:/usr/share/netdata/web/main.js \
