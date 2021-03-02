ossutil() {
    wget http://gosspublic.alicdn.com/ossutil/1.6.19/ossutil64 -O /usr/local/bin/ossutil64
    chmod +x /usr/local/bin/ossutil64
    echo "use \`ossutil64 config\` to init ossutil"
}

cron() {
    mkdir -p /etc/cron.sh/
    cp ./oss-backup.sh /etc/cron.sh/
    echo "0 0 1 * * root /etc/cron.sh/oss-backup.sh" >> /etc/crontab
}

ossutil
cron

