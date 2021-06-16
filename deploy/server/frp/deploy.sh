
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

    cp frpc.ini.example /etc/frp/frpc.ini
    cp frpc.service.example /usr/lib/systemd/system/frpc.service
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
    cp frps.ini.example /etc/frp/frps.ini
    cp frps.service.example /usr/lib/systemd/system/frps.service
    systemctl enable frps
    systemctl restart frps
    systemctl status frps
}

# apache2 -------------------------------------------------------------------------

DOMAIN=us.sang.pp.ua
FRP_DOMAIN=frp-us.sang.pp.ua
apache2() {
    grep -q -e "Listen 80" /etc/apache2/ports.conf || echo "Listen 80" >> /etc/apache2/ports.conf

    cp frp.apache2.conf.example frp.apache2.conf
    sed -i "s/%DOMAIN%/${DOMAIN}/g" frp.apache2.conf
    sed -i "s/%FRP_DOMAIN%/${FRP_DOMAIN}/g" frp.apache2.conf
    cp frp.apache2.conf /etc/apache2/sites-available/frp.conf

    a2ensite frp
    a2enmod proxy_http
    apache2ctl configtest
    systemctl restart apache2
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
