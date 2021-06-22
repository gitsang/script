#!/bin/bash

# registry mirrors
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://57qfh1yo.mirror.aliyuncs.com"]
}
EOF

# reload
systemctl daemon-reload
systemctl restart docker
