
# crontab

## ssh-tunnel

1. `/etc/cron.d/ssh-tunnel`

```
@reboot /etc/cron.hourly/ssh-tunnel
05 08-20 * * * /etc/cron.hourly/ssh-tunnel
```

2. `/etc/cron.hourly/ssh-tunnel`

```
#!/bin/sh
#
# check and reboot ssh tunnel

# log-start
date >> /var/log/ssh_tunnel.log

# function
ssh_tunnel() {
    REMOTE_ADDR=$1
    REMOTE_PORT=$2
    LOCAL_PORT=$3

    PID=`ps -ef | grep "ssh -fNR" | grep ":${REMOTE_PORT}:0.0.0.0:${LOCAL_PORT}" | awk '{printf $2}'`
    if [ ! -n "$PID" ]; then
        su - pi -c "ssh -fNR :${REMOTE_PORT}:0.0.0.0:${LOCAL_PORT} ${REMOTE_ADDR}"
    fi
}

# sshd
ssh_tunnel root@47.103.32.175 10022 22

# samba
ssh_tunnel root@47.103.32.175 10139 139
ssh_tunnel root@47.103.32.175 10445 445

# vnc
ssh_tunnel root@47.103.32.175 15900 5900
ssh_tunnel root@47.103.32.175 15901 5901
ssh_tunnel root@47.103.32.175 15902 5902
ssh_tunnel root@47.103.32.175 16001 6001
ssh_tunnel root@47.103.32.175 16002 6002

# log-finish
ps -ef | grep -v "ps -ef" | grep "ssh -fNR" | grep -v grep >> /var/log/ssh_tunnel.log

exit

# vncserver
su - pi   -c "vncserver"
su - root -c "vncserver"
```

3. view log

`vi /var/log/ssh_tunnel.log`
