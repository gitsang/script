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

aria2() {
    apt install -y aria2 nodejs
    mkdir /etc/aria2
    touch /etc/aria2/aria2.session
    chmod 0777 /etc/aria2/aria2.session

    echo ""                                      > /etc/aria2/aria2.conf
    echo "# default"                             >> /etc/aria2/aria2.conf
    echo "dir=/share/download"                   >> /etc/aria2/aria2.conf
    echo "disk-cache=16M"                        >> /etc/aria2/aria2.conf
    echo "continue=true"                         >> /etc/aria2/aria2.conf
    echo "log=aria2.log"                         >> /etc/aria2/aria2.conf
    echo "file-allocation=prealloc"              >> /etc/aria2/aria2.conf
    echo "# limit"                               >> /etc/aria2/aria2.conf
    echo "max-concurrent-downloads=100"          >> /etc/aria2/aria2.conf
    echo "max-connection-per-server=16"          >> /etc/aria2/aria2.conf
    echo "max-overall-download-limit=0"          >> /etc/aria2/aria2.conf
    echo "max-download-limit=0"                  >> /etc/aria2/aria2.conf
    echo "max-overall-upload-limit=0"            >> /etc/aria2/aria2.conf
    echo "max-upload-limit=0"                    >> /etc/aria2/aria2.conf
    echo "disable-ipv6=false"                    >> /etc/aria2/aria2.conf
    echo "# split"                               >> /etc/aria2/aria2.conf
    echo "min-split-size=10M"                    >> /etc/aria2/aria2.conf
    echo "split=16"                              >> /etc/aria2/aria2.conf
    echo "# session"                             >> /etc/aria2/aria2.conf
    echo "input-file=/etc/aria2/aria2.session"   >> /etc/aria2/aria2.conf
    echo "save-session=/etc/aria2/aria2.session" >> /etc/aria2/aria2.conf
    echo "save-session-interval=60"              >> /etc/aria2/aria2.conf
    echo "# rpc"                                 >> /etc/aria2/aria2.conf
    echo "enable-rpc=true"                       >> /etc/aria2/aria2.conf
    echo "rpc-allow-origin-all=true"             >> /etc/aria2/aria2.conf
    echo "rpc-listen-all=true"                   >> /etc/aria2/aria2.conf
    echo "rpc-listen-port=6800"                  >> /etc/aria2/aria2.conf
    echo "rpc-secret=123456"                     >> /etc/aria2/aria2.conf
    echo "# bt"                                  >> /etc/aria2/aria2.conf
    echo "follow-torrent=true"                   >> /etc/aria2/aria2.conf
    echo "listen-port=51413"                     >> /etc/aria2/aria2.conf
    echo "#bt-max-peers=55"                      >> /etc/aria2/aria2.conf
    echo "enable-dht=true"                       >> /etc/aria2/aria2.conf
    echo "enable-dht6=true"                      >> /etc/aria2/aria2.conf
    echo "dht-listen-port=6881-6999"             >> /etc/aria2/aria2.conf
    echo "bt-enable-lpd=true"                    >> /etc/aria2/aria2.conf
    echo "enable-peer-exchange=true"             >> /etc/aria2/aria2.conf
    echo "bt-request-peer-speed-limit=50K"       >> /etc/aria2/aria2.conf
    echo "# pt"                                  >> /etc/aria2/aria2.conf
    echo "peer-id-prefix=-TR2770-"               >> /etc/aria2/aria2.conf
    echo "user-agent=Transmission/2.77"          >> /etc/aria2/aria2.conf
    echo "# seed"                                >> /etc/aria2/aria2.conf
    echo "seed-ratio=0"                          >> /etc/aria2/aria2.conf
    echo "force-save=true"                       >> /etc/aria2/aria2.conf
    echo "#bt-hash-check-seed=true"              >> /etc/aria2/aria2.conf
    echo "bt-seed-unverified=true"               >> /etc/aria2/aria2.conf
    echo "bt-save-metadata=true"                 >> /etc/aria2/aria2.conf
    echo "bt-max-peers=0"                        >> /etc/aria2/aria2.conf
    echo "#seed-time = 60"                       >> /etc/aria2/aria2.conf
    echo "bt-detach-seed-only=true"              >> /etc/aria2/aria2.conf
    echo "bt-tracker=" \
        "udp://tracker.coppersurfer.tk:6969/announce," \
        "udp://tracker.internetwarriors.net:1337/announce," \
        "udp://tracker.opentrackr.org:1337/announce" >> /etc/aria2/aria2.conf

    aria2c --conf-path=/etc/aria2/aria2.conf -D

    # webui
    cd /etc/aria2 && git clone https://github.com/ziahamza/webui-aria2.git
    cd /etc/aria2/webui-aria2/ && nohup node node-server.js &
}

blog() {
    git clone https://github.com/gitsang/gitsang.github.io.git -b gh-pages /var/www/gitsang.github.io
    grep -q -e "Listen 8083" /etc/apache2/ports.conf || echo "Listen 8083" >> /etc/apache2/ports.conf
    echo "<VirtualHost *:8083>"                        >  /etc/apache2/sites-available/blog.conf
    echo "    ServerName 47.103.32.175"                >> /etc/apache2/sites-available/blog.conf
    echo "    DirectoryIndex index.html"               >> /etc/apache2/sites-available/blog.conf
    echo "    DocumentRoot /var/www/gitsang.github.io" >> /etc/apache2/sites-available/blog.conf
    echo "</VirtualHost>"                              >> /etc/apache2/sites-available/blog.conf
    a2ensite blog
    apache2ctl configtest
    systemctl reload apache2
}

index() {
    #apt install -y apache2
    mkdir -p /var/www/html/
    grep -q -e "Listen 8080" /etc/apache2/ports.conf || echo "Listen 8080" >> /etc/apache2/ports.conf
    echo "<VirtualHost *:8080>"            >  /etc/apache2/sites-available/index.conf
    echo "    ServerName 47.103.32.175"    >> /etc/apache2/sites-available/index.conf
    echo "    DirectoryIndex index.html"   >> /etc/apache2/sites-available/index.conf
    echo "    DocumentRoot /var/www/html"  >> /etc/apache2/sites-available/index.conf
    echo "</VirtualHost>"                  >> /etc/apache2/sites-available/index.conf
    a2ensite index
    apache2ctl configtest
    systemctl reload apache2

    echo ""                                                                   >  /var/www/html/index.html
    echo "<style>"                                                            >> /var/www/html/index.html
    echo "    .main{"                                                         >> /var/www/html/index.html
    echo "        text-align: center;"                                        >> /var/www/html/index.html
    echo "        background-color: #fff;"                                    >> /var/www/html/index.html
    echo "        border-radius: 20px;"                                       >> /var/www/html/index.html
    echo "        width: 300px;"                                              >> /var/www/html/index.html
    echo "        height: 300px;"                                             >> /var/www/html/index.html
    echo "        margin: auto;"                                              >> /var/www/html/index.html
    echo "        position: absolute;"                                        >> /var/www/html/index.html
    echo "        top: 0;"                                                    >> /var/www/html/index.html
    echo "        left: 0;"                                                   >> /var/www/html/index.html
    echo "        right: 0;"                                                  >> /var/www/html/index.html
    echo "        bottom: 0;"                                                 >> /var/www/html/index.html
    echo "        font-size:25px;"                                            >> /var/www/html/index.html
    echo "    }"                                                              >> /var/www/html/index.html
    echo "</style>"                                                           >> /var/www/html/index.html
    echo ""                                                                   >> /var/www/html/index.html
    echo "<body>"                                                             >> /var/www/html/index.html
    echo "	<div class="main">"                                               >> /var/www/html/index.html
    echo "        <a href="http://47.103.32.175:8080/">index</a></br></br>"   >> /var/www/html/index.html
    echo "        <a href="http://47.103.32.175:8081/">h5ai</a></br></br>"    >> /var/www/html/index.html
    echo "        <a href="http://47.103.32.175:8082/">filerun</a></br></br>" >> /var/www/html/index.html
    echo "        <a href="http://47.103.32.175:8083/">blog</a></br></br>"    >> /var/www/html/index.html
    echo "        <a href="http://47.103.32.175:8888/">aria2</a></br></br>"   >> /var/www/html/index.html
    echo "    </div>"                                                         >> /var/www/html/index.html
    echo "</body>"                                                            >> /var/www/html/index.html
}

oss() {
    wget http://gosspublic.alicdn.com/ossutil/1.6.19/ossutil64 -O /usr/local/bin/ossutil64
    chmod +x /usr/local/bin/ossutil64
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
aria2
oss
blog

index
