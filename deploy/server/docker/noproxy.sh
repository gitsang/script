#!/bin/bash

# delete config
rm -f /etc/systemd/system/docker.service.d/proxy.conf
rm -f ~/.docker/config.json

# reload
systemctl daemon-reload
systemctl restart docker
