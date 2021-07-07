
VERSION=0.37.0
FRP=frp_${VERSION}_linux_amd64

# download --------------------------------------------------------------------------

download() {
    if [ ! -f "${FRP}.tar.gz" ]; then
	wget https://github.com/fatedier/frp/releases/download/v${VERSION}/frp_${VERSION}_linux_amd64.tar.gz
    fi
    if [ ! -d "${FRP}" ]; then
        tar zxvf frp_${VERSION}_linux_amd64.tar.gz
    fi
}

# frpc -------------------------------------------------------------------------

frpc() {
    # bin
    if [ ! -f "/usr/bin/frpc" ]; then
        cp ${FRP}/frpc /usr/bin/
    fi

    cp frpc.ini /etc/frp/frpc.ini
    cp frpc.service /usr/lib/systemd/system/frpc.service
    systemctl enable frpc
    systemctl restart frpc
    systemctl status frpc
}

# frps -------------------------------------------------------------------------

frps() {
    if [ ! -f "/usr/bin/frps" ]; then
        cp ${FRP}/frps /usr/bin/
    fi
    mkdir -p /etc/frp
    touch /var/log/frps.log
    cp frps.ini /etc/frp/frps.ini
    cp frps.service /usr/lib/systemd/system/frps.service
    systemctl enable frps
    systemctl restart frps
    systemctl status frps
}

# opts -------------------------------------------------------------------------

case $1 in
    "frpc")
    	download
        frpc
        ;;
    "frps")
    	download
        frps
        ;;
    *)
        echo "usage $0 frpc / frps"
esac
