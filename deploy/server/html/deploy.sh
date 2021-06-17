
case $1 in
    "cn")
        rm -fr /var/www/html
        cp -r html-cn/ /var/www/html
        echo "deploy cn success"
        ;;
    "us")
        rm -fr /var/www/html
        cp -r html-us/ /var/www/html
        echo "deploy us success"
        ;;
    "home")
        rm -fr /var/www/html
        cp -r html-home/ /var/www/html
        echo "deploy local success"
        ;;
    *)
        echo "usage $0 region"
esac
