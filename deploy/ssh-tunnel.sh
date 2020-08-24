#!/bin/bash

cat>/etc/cron.hourly/ssh-tunnel<<EOF
#!/bin/bash
date >> /var/log/ssh_tunnel.log
build_autossh_tunnel() {
    USER=$1
    REMOTE_ADDR=$2
    REMOTE_PORT=$3
    LOCAL_PORT=$4
    PID=`ps -ef | grep "autossh -NR" | grep ":${REMOTE_PORT}:0.0.0.0:${LOCAL_PORT}" | awk '{printf $2}'`
    if [ ! -n "$PID" ]; then
        su - $USER -c "autossh -fNR :${REMOTE_PORT}:0.0.0.0:${LOCAL_PORT} ${REMOTE_ADDR}"
    fi
}
build_autossh_tunnel root root@47.103.32.175 10022 22
build_autossh_tunnel root root@47.103.32.175 10080 80
build_autossh_tunnel root root@47.103.32.175 10139 139
build_autossh_tunnel root root@47.103.32.175 10445 445
ps -ef | grep "autossh" | grep "-NR" | grep -v grep >> /var/log/ssh_tunnel.log
EOF

echo "@reboot /etc/cron.hourly/ssh-tunnel" >> /etc/cron.d/ssh-tunnel
echo "05 08-20 * * * /etc/cron.hourly/ssh-tunnel" >> /etc/cron.d/ssh-tunnel

