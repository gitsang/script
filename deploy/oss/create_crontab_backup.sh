
echo "" > /etc/cron.daily/oss-backup
chmod +x /etc/cron.daily/oss-backup
echo "" > /var/log/oss-backup

echo "date >> /var/log/oss-backup" \
    >> /etc/cron.daily/oss-backup
echo "/usr/local/bin/ossutil64 ls oss:// >> /var/log/oss-backup" \
    >> /etc/cron.daily/oss-backup
echo "/usr/local/bin/ossutil64 cp -r /share/package oss://sang-repo/package/ -u >> /var/log/oss-backup" \
    >> /etc/cron.daily/oss-backup
echo "/usr/local/bin/ossutil64 cp -r /share/project oss://sang-repo/project/ -u >> /var/log/oss-backup" \
    >> /etc/cron.daily/oss-backup
echo "/usr/local/bin/ossutil64 cp -r /share/books oss://sang-repo/books/ -u >> /var/log/oss-backup" \
>> /etc/cron.daily/oss-backup

echo "0 6 * * * root /etc/cron.daily/oss-backup" > /etc/cron.d/oss-backup
echo "Create crontab finished! Will auto backup at 06:00am"

