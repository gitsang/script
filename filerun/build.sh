
mkdir -p /filerun/{html,user-files}
docker-compose up -d

# Username: superuser
# Password: superuser

cp chinese.php /data/filerun/html/system/data/translations
