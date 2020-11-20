
DOMAIN=us.sang.pp.ua
FRP_DOMAIN=frp-us.sang.pp.ua

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
    cp ${FRP}/frpc /usr/bin/
    cp ${FRP}/frps /usr/bin/
}

frpc_us() {
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

frps() {
    cp frps.ini.example /etc/frp/frps.ini
    systemctl enable frps
    systemctl restart frps
    systemctl status frps
}

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

case $1 in
    "frp")
        frp
        ;;
    "frpc-sz")
        frp
        frpc_sz
        ;;
    "frpc-us")
        frp
        frpc_us
        ;;
    "frps")
        frp
        frps
        apache2
        ;;
    "apache2")
        apache2
        ;;
    "all")
        frp
        frpc
        frps
        apache2
        ;;
    *)
        echo "usage $0 frpc-[us|sz] | frps"
esac
