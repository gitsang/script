#!/bin/bash

# docker runtime proxy
mkdir -p ~/.docker
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
