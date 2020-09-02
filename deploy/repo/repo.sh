
# epel-release
yum install -y epel-release

# nux-dextop
rpm --import  http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
rpm -Uvh  http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm

# webstatic
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

yum repolist

