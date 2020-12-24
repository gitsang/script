
INTERVAL=monthly
SHNAME=oss-backup
CRON_PATH=/etc/cron.${INTERVAL}/${SHNAME}
LOG_PATH=/var/log/oss-backup

reset_crond() {
    > ${CRON_PATH}
    > ${LOG_PATH}
    chmod +x ${CRON_PATH}
}

add_date_log() {
    echo "date >> /var/log/oss-backup" >> ${CRON_PATH}
}

add_backup_path() {
    BKPATH=$1
    OSSPATH=$2
    echo "/usr/local/bin/ossutil64 cp -r ${BKPATH} ${OSSPATH} -u >> /var/log/oss-backup" >> ${CRON_PATH}
}

reset_crond
add_date_log
add_backup_path /share/package oss://sang-repo/package
add_backup_path /share/project oss://sang-repo/project
add_backup_path /share/books   oss://sang-repo/books
add_backup_path /mnt/sda1      oss://sang-repo/sda1
add_backup_path /mnt/sda2      oss://sang-repo/sda2

