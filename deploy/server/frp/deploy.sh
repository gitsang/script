
# frp --------------------------------------------------------------------------

frp() {
    FRP=frp_0.34.2_linux_amd64

    # frp
    if [ ! -f "${FRP}.tar.gz" ]; then
        wget https://github.com/fatedier/frp/releases/download/v0.34.2/frp_0.34.2_linux_amd64.tar.gz
    fi
    if [ ! -d "${FRP}" ]; then
        tar zxvf frp_0.34.2_linux_amd64.tar.gz
    fi

    # bin
    if [ ! -f "/usr/bin/frpc" ]; then
        cp ${FRP}/frpc /usr/bin/
    fi
    if [ ! -f "/usr/bin/frps" ]; then
        cp ${FRP}/frps /usr/bin/
    fi
}

# frpc -------------------------------------------------------------------------

frpc_sh() {
    cp frpc-sh.ini.example /etc/frp/frpc-sh.ini
    cp frpc-sh.service.example /usr/lib/systemd/system/frpc-sh.service
    systemctl enable frpc-sh
    systemctl restart frpc-sh
    systemctl status frpc-sh
}

frpc_sz() {
    cp frpc-sz.ini.example /etc/frp/frpc-sz.ini
    cp frpc-sz.service.example /usr/lib/systemd/system/frpc-sz.service
    systemctl enable frpc-sz
    systemctl restart frpc-sz
    systemctl status frpc-sz
}

frpc_us() {
    cp frpc-us.ini.example /etc/frp/frpc-us.ini
    cp frpc-us.service.example /usr/lib/systemd/system/frpc-us.service
    systemctl enable frpc-us
    systemctl restart frpc-us
    systemctl status frpc-us
}

frpc() {
    frpc_sh
    #frpc_sz
    #frpc_us
}

# frps -------------------------------------------------------------------------

frps() {
    mkdir -p /etc/frp
    cp frps.ini.example /etc/frp/frps.ini
    cp frps.service.example /usr/lib/systemd/system/frps.service
    systemctl enable frps
    systemctl restart frps
    systemctl status frps
}

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
        frp
        frpc
        ;;
    "frps")
        frp
        frps
        apache2
        ;;
    *)
        echo "usage $0 frpc / frps"
esac
