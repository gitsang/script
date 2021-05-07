#!/bin/bash

#===========================================================
# config
#===========================================================

# for local/outer host
DOMAIN=${DOMAIN:-home.sang.pp.ua}
PORT=${PORT:-80}

# for inner server
FRPC_DOMAIN=${FRPC_DOMAIN:-home.frp-sh.sang.pp.ua}
FRPC_PORT=${FRPC_PORT:-8080}

# for frps
FRPS_DOMAIN=${FRPS_DOMAIN:-frp-sh.sang.pp.ua}
FRPS_PORT=${FRPS_PORT:-8080}

#===========================================================
# function
#===========================================================

deploy_init() {
    cd init
    ./apt-init.sh
    ./git-init.sh
    cd -
}

deploy_h5ai() {
    cd h5ai
    ./deploy.sh h5ai
    ./deploy.sh apache2
    cd -
}

deploy_filerun() {
    cd filerun
    ./deploy.sh filerun
    ./deploy.sh apache2
    ./deploy.sh plugin
    cd -
}

#===========================================================
# option
#===========================================================

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
	echo DOMAIN=${DOMAIN}
	echo PORT=${PORT}
	echo FRPC_DOMAIN=${FRPC_DOMAIN}
	echo FRPC_PORT=${FRPC_PORT}
	echo FRPS_DOMAIN=${FRPS_DOMAIN}
	echo FRPS_PORT=${FRPS_PORT}
	echo ""
        echo "usage: $0 service"
        echo "services:"
        echo "    h5ai"
        echo "    filerun"
        ;;
esac
