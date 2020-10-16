#!/bin/bash

init() {
    apt update
    apt upgrade -y
    apt autoremove -y
    apt install -y \
        net-tools iftop \
        git vim \
        zip unzip

    git config --global user.email "sang.chen@outlook.com"
    git config --global user.name "gitsang"
    git clone https://github.com/gitsang/script.git
    echo "init finished."
}

config() {
    # bashrc
    cp script/config/bash/.bash_aliases ~/
    echo "update bash_alias finish, using source ~/.bashrc to reload"

    # vim
    cp script/config/vim/.vimrc ~/
    mkdir -p ~/.vim/autoload
    wget http://aliyun.sang.pp.ua:8080/share/package/vim-plug.tar.gz
    tar zxvf vim-plug.tar.gz -C ~/.vim/autoload/
    echo "source vimrc finish, using :PlugInstall to install plugin"
    echo "config finished."
}

samba() {
    # samba
    apt install -y samba
    cp script/deploy/samba/smb.conf /etc/samba/
    mkdir -p /share
    smbpasswd -a root
    systemctl restart smbd
    echo "samba install finished."
}

h5ai() {
    # h5ai
    apt install -y \
        apache2 \
        php php-gd \
        ffmpeg graphicsmagick

    wget https://release.larsjung.de/h5ai/h5ai-0.29.2.zip
    rm -fr /var/www/html/_h5ai
    unzip h5ai-0.29.2.zip -d /var/www/html/
    chmod 0777 -R /var/www/html/_h5ai
    rm /var/www/html/index.html -f
    cp script/deploy/h5ai/options.json /var/www/html/_h5ai/private/conf/options.json
    echo "DirectoryIndex index.html index.php /_h5ai/public/index.php" >> /etc/apache2/apache2.conf
    systemctl restart apache2
    echo "h5ai install finished."
}

# filerun
# http://blog.filerun.com/
# http://blog.filerun.com/how-to-install-filerun-on-ubuntu-20/

filerun_db() {
    ## database
    apt install -y mysql-server
    mysql -u root -e 'CREATE DATABASE filerun;'
    echo ""
    echo "add filerun user by:"
    echo "    CREATE USER 'filerun'@'localhost' IDENTIFIED BY 'filerun';"
    echo "    GRANT ALL ON filerun.* TO 'filerun'@'localhost';"
    echo "    FLUSH PRIVILEGES;"
    echo ""
    mysql
}

filerun_php() {
    ## php
    apt install -y \
        php php-cli \
        libapache2-mod-php php-mysql \
        php-mbstring php-zip php-curl php-gd \
        php-ldap php-xml php-imagick

    PHP_VERSION=`php -v | awk 'NR==1' | awk -F ' ' '{print substr($2,1,3)}'`
    IONCUBE=ioncube_loader_lin_${PHP_VERSION}
    EXFILE=`ls /usr/lib/php/ | awk 'NR==1 {print $1}'`

    ## ioncube
    # wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
    wget http://aliyun.sang.pp.ua:8080/share/package/filesystem/ioncube_loaders_lin_x86-64.tar.gz
    tar zxvf ioncube_loaders_lin_x86-64.tar.gz
    cp ioncube/${IONCUBE}.so /usr/lib/php/${EXFILE}
    echo "zend_extension = /usr/lib/php/${EXFILE}/${IONCUBE}.so" > \
        /etc/php/${PHP_VERSION}/apache2/conf.d/00-ioncube.ini

    ## php-apache config
    cp script/deploy/filerun/filerun.ini /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
}

filerun_install() {
    ## install filerun
    #wget -O FileRun.zip http://www.filerun.com/download-latest
    wget http://aliyun.sang.pp.ua:8080/share/package/filesystem/FileRun.zip
    rm -fr /var/www/html/filerun
    unzip FileRun.zip -d /var/www/html/filerun
    chown -R www-data:www-data /var/www/html/
    echo "visit http://server-ip/filerun to install"

    systemctl restart apache2
}

v2ray() {
    wget http://aliyun.sang.pp.ua:8080/share/package/v2ray/v2ray-linux-64.zip
    #cp script/deploy/v2ray/install-release.sh ./
    wget https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
    sh install-release -l v2ray-linux-64.zip
    rm -fr /usr/local/etc/v2ray/config.json
    unzip script/deploy/v2ray/config.zip -d /usr/local/etc/v2ray/
    systemctl enable v2ray
    systemctl restart v2ray
}

init
config
samba
h5ai
filerun_db
filerun_php
filerun_install
v2ray
