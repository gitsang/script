
mkdir -p /data/filerun/html
mkdir -p /data/filerun/db
mkdir -p /mnt

docker-compose up -d

# Username: superuser
# Password: superuser

cp chinese.php /data/filerun/html/system/data/translations
