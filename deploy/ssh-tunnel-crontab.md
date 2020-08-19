
# crontab

## ssh-tunnel

1. `/etc/cron.d/ssh-tunnel`

```crontab
@reboot /etc/cron.hourly/ssh-tunnel
05 08-20 * * * /etc/cron.hourly/ssh-tunnel
```

2. `/etc/cron.hourly/ssh-tunnel`

```bash
#!/bin/bash

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

# log-finish
ps -ef | grep -v "ps -ef" | grep "ssh -fNR" | grep -v grep >> /var/log/ssh_tunnel.log
```
