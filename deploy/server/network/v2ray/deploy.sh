v2ray() {
    set -e
    if [ ! -f "v2ray-linux-64.zip" ]; then
        wget https://github.com/v2fly/v2ray-core/releases/download/v4.39.2/v2ray-linux-64.zip
    fi
    if [ ! -f "install-release.sh" ]; then
        wget https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
    fi

    chmod +x install-release.sh && ./install-release.sh -l v2ray-linux-64.zip
    rm -fr /usr/local/etc/v2ray/config.json
    unzip config.zip -d /usr/local/etc/v2ray/

    ./bbr.sh

    systemctl enable v2ray
    systemctl restart v2ray
}

v2ray
