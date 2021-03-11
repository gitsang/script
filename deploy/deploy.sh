
DOMAIN=${DOMAIN:-us.sang.pp.ua}
FRP_DOMAIN=${FRP_DOMAIN:-frp-us.sang.pp.ua}
APACHE_PORT=${APACHE_PORT:-80}

deploy_init() {
    cd init
    ./apt-init.sh
    ./git-init.sh
    cd -
}

deploy_h5ai() {
    cd h5ai
    ./deploy h5ai
    ./deploy apache2
    cd -
}

case $1 in
    # basic
    "init") deploy_init ;;
    "h5ai") deploy_h5ai ;;
    "samba") deploy_samba ;;
    "filerun") deploy_filerun ;;
    "v2ray") deploy_v2ray ;;
    "aria2") deploy_aria2 ;;
    "frp") deploy_frp ;;
    "apache2") deploy_apache2 ;;
    "html") deploy_html ;;
    "oss") deploy_oss ;;
    "network") deploy_network ;;

    # game
    "minecraft") deploy_minecraft ;;

    # tool
    "registry") deploy_registry ;;
    "gitlab") deploy_gitlab ;;

    # middleware
    "rocketmq") deploy_rocketmq ;;
    "redis") deploy_redis ;;

    # auto
    "auto")
        deploy_network
        deploy_samba
        deploy_v2ray
        deploy_apache2
        deploy_h5ai
        deploy_filerun
        deploy_frp
        deploy_oss
        deploy_aria2
        ;;

    # help
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
