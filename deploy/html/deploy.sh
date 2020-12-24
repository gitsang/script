
case $1 in
    "center")
        rm -fr /var/www/center
        cp -r html-center/ /var/www/center
        echo "deploy center success"
        ;;
    "sh")
        rm -fr /var/www/html
        cp -r html-sh/ /var/www/html
        echo "deploy shanghai success"
        ;;
    "sz")
        rm -fr /var/www/html
        cp -r html-sz/ /var/www/html
        echo "deploy shenzhen success"
        ;;
    "us")
        rm -fr /var/www/html
        cp -r html-us/ /var/www/html
        echo "deploy us success"
        ;;
    "local")
        rm -fr /var/www/html
        cp -r html-local/ /var/www/html
        echo "deploy local success"
        ;;
    *)
        echo "usage $0 region"
esac
