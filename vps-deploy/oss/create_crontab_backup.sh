
INTERVAL=weekly
SHNAME=oss-backup
CRON_PATH=/etc/cron.${INTERVAL}/${SHNAME}
LOG_PATH=/var/log/oss-backup

> ${CRON_PATH}
> ${LOG_PATH}
chmod +x ${CRON_PATH}

echo "date >> /var/log/oss-backup" \
    >> ${CRON_PATH}
echo "/usr/local/bin/ossutil64 cp -r /share/package oss://sang-repo/package/ -u >> /var/log/oss-backup" \
    >> ${CRON_PATH}
echo "/usr/local/bin/ossutil64 cp -r /share/project oss://sang-repo/project/ -u >> /var/log/oss-backup" \
    >> ${CRON_PATH}
echo "/usr/local/bin/ossutil64 cp -r /share/books oss://sang-repo/books/ -u >> /var/log/oss-backup" \
    >> ${CRON_PATH}

