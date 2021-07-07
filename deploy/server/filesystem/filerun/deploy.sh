
filerun() {
    rm -fr /var/www/filerun/
    mkdir -p /var/www/filerun/

    wget -O FileRun.zip http://www.filerun.com/download-latest
    unzip FileRun.zip -d /var/www/filerun
    chown -R www-data:www-data /var/www/filerun/
}

install_database() {
    # install
    apt install -y mysql-server

    # config
    echo "drop database IF EXISTS filerun" | mysql
    echo "create database filerun;" | mysql
    echo "CREATE USER 'filerun'@'localhost' IDENTIFIED BY 'filerun';" | mysql
    echo "GRANT ALL ON filerun.* TO 'filerun'@'localhost';" | mysql
    echo "FLUSH PRIVILEGES;" | mysql
}

install_php() {
    # install
    apt install -y php php-cli \
        libapache2-mod-php php-mysql \
        php-mbstring php-zip php-curl php-gd \
        php-ldap php-xml php-imagick

    PHP_VERSION=`php -v | awk 'NR==1' | awk -F ' ' '{print substr($2,1,3)}'`
    IONCUBE=ioncube_loader_lin_${PHP_VERSION}
    EXFILE=`ls /usr/lib/php/ | awk 'NR==1 {print $1}'`
    echo $PHP_VERSION $IONCUBE $EXFILE

    # ioncube
    wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
    tar zxvf ioncube_loaders_lin_x86-64.tar.gz
    cp ioncube/${IONCUBE}.so /usr/lib/php/${EXFILE}
    echo "zend_extension = /usr/lib/php/${EXFILE}/${IONCUBE}.so" > \
        /etc/php/${PHP_VERSION}/apache2/conf.d/00-ioncube.ini

    # config
    cp filerun.ini /etc/php/${PHP_VERSION}/apache2/conf.d/filerun.ini
}

apache2() {
    cd ../apache2
    ./configure filerun
    cd -
}

plugin() {
    apt install -y imagemagick ffmpeg

    docker pull onlyoffice/documentserver
    docker run --name onlyoffice \
        --restart=always \
        -p 2080:80 -p 2443:443 \
        -d onlyoffice/documentserver
}

case $1 in
    "filerun")
        filerun
        cat README.md
        ;;
    "database")
        install_database
        ;;
    "php")
        install_php
        ;;
    "apache2")
        apache2
        ;;
    "plugin")
        plugin
        ;;
    *)
        echo "usage $0 [filerun | database | php | apache2 | plugin]"
        cat README.md
        ;;
esac
