rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml -y




exit


rpm -qa | grep kernel
egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
grub2-set-default 0


exit


reboot


