
DOMAIN=${DOMAIN:-us.sang.pp.ua}

h5ai() {
    # install
    apt install -y php php-gd ffmpeg graphicsmagick
    # file
    rm -fr /var/www/h5ai/
    mkdir -p /var/www/h5ai/
    mkdir -p /share
    ln -s /share /var/www/h5ai/share
    # h5ai
    if [ ! -f "h5ai-0.29.2.zip" ]; then
    	wget https://release.larsjung.de/h5ai/h5ai-0.29.2.zip
    fi
    if [ ! -d "/var/www/h5ai/_h5ai" ]; then
    	unzip h5ai-0.29.2.zip -d /var/www/h5ai/
    	chmod 0777 -R /var/www/h5ai/_h5ai
    fi
    # config
    cp options.json /var/www/h5ai/_h5ai/private/conf/options.json
}

apache2() {
    cd ../apache2
    ./configure h5ai
    cd -
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
