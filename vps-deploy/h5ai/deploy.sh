
DOMAIN=us.sang.pp.ua

h5ai() {
    # install
    apt install -y php php-gd ffmpeg graphicsmagick

    # file
    rm -fr /var/www/h5ai/
    mkdir -p /var/www/h5ai/
    mkdir -p /share
    ln -s /share /var/www/h5ai/share

    # h5ai
    wget https://release.larsjung.de/h5ai/h5ai-0.29.2.zip
    unzip h5ai-0.29.2.zip -d /var/www/h5ai/
    chmod 0777 -R /var/www/h5ai/_h5ai

    # config
    cp options.json /var/www/h5ai/_h5ai/private/conf/options.json
}

apache2() {
    grep -q -e "Listen 80" /etc/apache2/ports.conf || echo "Listen 80" >> /etc/apache2/ports.conf

    sed "s/%DOMAIN%/${DOMAIN}/g" h5ai.apache2.conf.example > h5ai.apache2.conf
    cp h5ai.apache2.conf /etc/apache2/sites-available/h5ai.conf

    a2ensite h5ai
    apache2ctl configtest
    systemctl restart apache2
}

case $1 in
    "h5ai")
        h5ai
        ;;
    "apache2")
        apache2
        ;;
    *)
        h5ai
        apache2
esac
