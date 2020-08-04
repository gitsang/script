# import repo and install kernel-ml
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml -y

# check
rpm -qa | grep kernel
egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'

# set grub2
grub2-set-default 0
#reboot


