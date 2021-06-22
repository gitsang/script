
cp php-cgi.service /usr/lib/systemd/system/php-cgi.service

rm /etc/nginx/sites-enabled/default
cp *.conf /etc/nginx/conf.d/
