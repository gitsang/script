
DOMAIN=${DOMAIN:-us.sang.pp.ua}
FRP_DOMAIN=${FRP_DOMAIN:-frp-us.sang.pp.ua}
APACHE_PORT=${APACHE_PORT:-80}

deploy_h5ai() {
    cd h5ai
    ./deploy h5ai
    ./deploy apache2
    cd - 
}

deploy_init() {
    cd init
    ./apt-init.sh
    ./git-init.sh
    cd -
}

case $1 in 
    "init")
        deploy_init
	    ;;
    "h5ai")
        deploy_h5ai
        ;;
    "samba");;
    "filerun");;
    "v2ray");;
    "aria2");;
    "frp");;

    "apache2");;
    "html");;

    "oss");;
    "wlan");;

    "minecraft");;
    "registry");;
    "gitlab");;

    "rocketmq");;
    "redis");;

    *)
        if [ "${DOMAIN}" == "" ]; then
            echo "set up DOMAIN before using this script"
            echo "using \`export DOMAIN={your domain}\` to set"
        fi
        echo "DOMAIN" ${DOMAIN}
        echo "usage: $0 option"
        echo "option:"
        echo "    h5ai"
        ;;
esac
