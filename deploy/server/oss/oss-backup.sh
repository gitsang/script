
date >> /var/log/oss.package.log
nohup /usr/local/bin/ossutil64 cp -r /home/sang/package oss://sang-repo/package -u >> /var/log/oss.package.log 2>&1 &

date >> /var/log/oss.project.log
nohup /usr/local/bin/ossutil64 cp -r /home/sang/project oss://sang-repo/project -u >> /var/log/oss.project.log 2>&1 &

date >> /var/log/oss.sda1.log
nohup /usr/local/bin/ossutil64 cp -r /mnt/sda1 oss://sang-mnt/sda1 -u >> /var/log/oss.sda1.log 2>&1 &

date >> /var/log/oss.sda2.log
nohup /usr/local/bin/ossutil64 cp -r /mnt/sda2 oss://sang-mnt/sda2 -u >> /var/log/oss.sda2.log 2>&1 &
