#!/bin/bash

XMRIG=xmrig

run_xmrig() {
    PID=`ps -ef | grep $XMRIG | grep -vE 'grep|SCREEN|xmrig.sh' | awk '{printf $2}'`
    echo $PID
    if [ -n "$PID" ]; then
        echo "xmrig is running"
    else
        screen -R $XMRIG /usr/local/bin/xmrig -c /usr/local/etc/xmrig/config.json
    fi
}

kill_xmrig() {
    PID=`ps -ef | grep $XMRIG | grep -v -E 'grep|SCREEN' | awk '{printf $2}'`
    if [ -n "$PID" ]; then
        kill -9 $PID
        screen -X -S $XMRIG quit
    else
        echo "server is not running"
    fi
}

attach_screen() {
    SCREEN_CNT=`screen -ls | grep $XMRIG | wc -l`
    if [ $SCREEN_CNT -eq 1 ]; then
        screen -r $XMRIG
    elif [ $SCREEN_CNT -gt 1 ]; then
        echo "multi server screen"
        screen -ls | grep $XMRIG
    elif [ $SCREEN_CNT -lt 1 ]; then
        echo "server screen not running"
    fi
}


echo_help() {
    echo "Usage:"
    echo "    $0 [options...]"
    echo " -a, --attach         attach xmrig screen"
    echo " -r, --run            run xmrig"
    echo " -k, --kill           kill xmrig"
    echo " -h, --help           help"
}

OPT=$1
case "$OPT" in
    "-h");&
    "--help")
        echo_help
        ;;
    "-a");&
    "--attach")
        attach_screen
        ;;
    "-r");&
    "--run")
        run_xmrig
        ;;
    "-k");&
    "--kill")
        kill_xmrig
        ;;
    *)
        echo_help
        ;;
esac
