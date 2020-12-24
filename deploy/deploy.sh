
DOMAIN=${DOMAIN:-us.sang.pp.ua}
FRP_DOMAIN=${FRP_DOMAIN:-frp-us.sang.pp.ua}
APACHE_PORT=${APACHE_PORT:-80}

deploy_h5ai() {
    cd h5ai
    ./deploy h5ai
    ./deploy apache2
    cd - 
}

case $1 in 
    "init")
	    ;;
    "h5ai")
        deploy_h5ai
        ;;
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
