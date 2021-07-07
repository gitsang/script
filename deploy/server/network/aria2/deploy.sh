#!/bin/bash

aria2() {
    # install
    apt install -y aria2 nodejs

    # config
    mkdir /etc/aria2
    touch /etc/aria2/aria2.session
    chmod 0777 /etc/aria2/aria2.session
    cp aria2.conf /etc/aria2/aria2.conf
    mkdir -p /share/download

    # systemd
    cp aria2.service /usr/lib/systemd/system/
    systemctl enable aria2
    systemctl start aria2
    systemctl status aria2

}

webui() {
    # webui
    cd /etc/aria2 && git clone https://github.com/ziahamza/webui-aria2.git
    cd -

    # systemd
    cp aria2-webui.service /usr/lib/systemd/system/
    systemctl enable aria2-webui
    systemctl start aria2-webui
    systemctl status aria2-webui
}

aria2
