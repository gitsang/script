#!/bin/bash

init() {
    apt update
    apt upgrade -y
    apt autoremove -y
    apt install -y \
        net-tools iftop \
        git vim \
        zip unzip \
        docker.io

    git config --global user.email "sang.chen@outlook.com"
    git config --global user.name "gitsang"
    git clone https://github.com/gitsang/script.git
}

config() {
    # bashrc
    cp script/config/bash/.bash_aliases ~/

    # vim
    cp script/config/vim/.vimrc ~/
}

samba() {
    apt install -y samba
    cp script/deploy/samba/smb.conf /etc/samba/
    mkdir -p /share
    smbpasswd -a root
    systemctl restart smbd
}

h5ai() {
    # 1. apache virtual host
    apt install -y apache2 php php-gd ffmpeg graphicsmagick
    rm -fr /var/www/h5ai/
    mkdir -p /var/www/h5ai/
    grep -q -e "Listen 8081" /etc/apache2/ports.conf || echo "Listen 8081" >> /etc/apache2/ports.conf
    echo "<VirtualHost *:8081>"                                            >  /etc/apache2/sites-available/h5ai.conf
    echo "    ServerName 47.103.32.175"                                    >> /etc/apache2/sites-available/h5ai.conf
    echo "    DirectoryIndex index.html index.php /_h5ai/public/index.php" >> /etc/apache2/sites-available/h5ai.conf
    echo "    DocumentRoot /var/www/h5ai"                                  >> /etc/apache2/sites-available/h5ai.conf
    echo "</VirtualHost>"                                                  >> /etc/apache2/sites-available/h5ai.conf
    a2ensite h5ai
    apache2ctl configtest
    systemctl reload apache2

    # 2. h5ai
    wget https://release.larsjung.de/h5ai/h5ai-0.29.2.zip
    unzip h5ai-0.29.2.zip -d /var/www/h5ai/
    chmod 0777 -R /var/www/h5ai/_h5ai
    cp script/deploy/h5ai/options.json /var/www/h5ai/_h5ai/private/conf/options.json
    systemctl restart apache2
    
    mkdir -p /share
    ln -s /share /var/www/h5ai/share
}

filerun() {
    # 1. apache virtual host
    apt install -y apache2
    mkdir -p /var/www/filerun/
    grep -q -e "Listen 8082" /etc/apache2/ports.conf || echo "Listen 8082" >> /etc/apache2/ports.conf
    echo "<VirtualHost *:8082>"                    >  /etc/apache2/sites-available/filerun.conf
    echo "    ServerName 47.103.32.175"            >> /etc/apache2/sites-available/filerun.conf
    echo "    DirectoryIndex index.php index.html" >> /etc/apache2/sites-available/filerun.conf
    echo "    DocumentRoot /var/www/filerun"       >> /etc/apache2/sites-available/filerun.conf
    echo "</VirtualHost>"                          >> /etc/apache2/sites-available/filerun.conf
    a2ensite filerun
    apache2ctl configtest
    systemctl reload apache2

    # 2. setting up database
    apt install -y mysql-server
    echo "drop database IF EXISTS filerun" | mysql
    echo "create database filerun;" | mysql
    echo "CREATE USER 'filerun'@'localhost' IDENTIFIED BY 'filerun';" | mysql
    echo "GRANT ALL ON filerun.* TO 'filerun'@'localhost';" | mysql
    echo "FLUSH PRIVILEGES;" | mysql
    
    # 3. php config
    apt install -y php php-cli \
        libapache2-mod-php php-mysql \
        php-mbstring php-zip php-curl php-gd \
        php-ldap php-xml php-imagick

    PHP_VERSION=`php -v | awk 'NR==1' | awk -F ' ' '{print substr($2,1,3)}'`
    IONCUBE=ioncube_loader_lin_${PHP_VERSION}
    EXFILE=`ls /usr/lib/php/ | awk 'NR==1 {print $1}'`
    wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
    tar zxvf ioncube_loaders_lin_x86-64.tar.gz
    cp ioncube/${IONCUBE}.so /usr/lib/php/${EXFILE}
    echo "zend_extension = /usr/lib/php/${EXFILE}/${IONCUBE}.so" > \
        /etc/php/${PHP_VERSION}/apache2/conf.d/00-ioncube.ini
    
    cp script/deploy/filerun/filerun.ini /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "expose_php              = Off"               >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "error_reporting         = E_ALL & ~E_NOTICE" >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "display_errors          = Off"               >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "display_startup_errors  = Off"               >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "log_errors              = On"                >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "ignore_repeated_errors  = Off"               >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "allow_url_fopen         = On"                >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "allow_url_include       = Off"               >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "variables_order         = \"GPCS\""          >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "allow_webdav_methods    = On"                >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "memory_limit            = 128M"              >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "max_execution_time      = 300"               >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "output_buffering        = Off"               >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "output_handler          = \"\""              >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "zlib.output_compression = Off"               >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "zlib.output_handler     = \"\""              >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "safe_mode               = Off"               >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "register_globals        = Off"               >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "magic_quotes_gpc        = Off"               >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "upload_max_filesize     = 20M"               >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "post_max_size           = 20M"               >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "enable_dl               = Off"               >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "disable_functions       = \"\""              >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "disable_classes         = \"\""              >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "session.save_handler     = files"            >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "session.use_cookies      = 1"                >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "session.use_only_cookies = 1"                >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "session.auto_start       = 0"                >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "session.cookie_lifetime  = 0"                >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "session.cookie_httponly  = 1"                >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
    echo "date.timezone            = \"UTC\""          >> /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini

    # 4. install filerun
    rm -fr /var/www/filerun/*
    wget -O FileRun.zip http://www.filerun.com/download-latest
    unzip FileRun.zip -d /var/www/filerun
    chown -R www-data:www-data /var/www/filerun/
    mkdir -p /share
    chmod 0777 /share
    systemctl restart apache2

    # 5. install plugin
    apt install -y imagemagick ffmpeg
    
    docker pull onlyoffice/documentserver
    docker run --name onlyoffice \
        --restart=always \
        -p 10080:80 -p 10443:443 \
        -d onlyoffice/documentserver
}

v2ray() {
    wget https://github.com/v2fly/v2ray-core/releases/download/v4.31.0/v2ray-linux-64.zip
    wget https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
    chmod +x install-release.sh && ./install-release.sh -l v2ray-linux-64.zip
    rm -fr /usr/local/etc/v2ray/config.json
    unzip script/deploy/v2ray/config.zip -d /usr/local/etc/v2ray/
    systemctl enable v2ray
    systemctl restart v2ray
}

init
config

samba
h5ai
filerun
