#!/bin/bash

# dockerd proxy
mkdir -p /etc/systemd/system/docker.service.d
tee /etc/systemd/system/docker.service.d/proxy.conf <<-'EOF'
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:1081/"
Environment="HTTPS_PROXY=http://127.0.0.1:1081/"
Environment="NO_PROXY=localhost,127.0.0.1,.example.com"
EOF

# docker runtime proxy
mkdir ~/.docker
tee ~/.docker/config.json <<-'EOF'
{
  "proxies": {
    "default": {
      "httpProxy": "http://127.0.0.1:1081",
      "httpsProxy": "http://127.0.0.1:1081",
      "noProxy": "localhost,127.0.0.1,.example.com"
    }
  }
}
EOF

# reload
systemctl daemon-reload
systemctl restart docker
