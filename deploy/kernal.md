# CentOS7 kernel update

## 1. kernel update

### 1.1 checking command

remenber to check before every steps and then continue.

```sh
# check for yum repo list
yum repolist
# check for kernel info
yum info --enablerepo=elrepo-kernel kernel-lt kernel-ml
# check for installed kernel
rpm -qa | grep kernel
# check for grub2 option
egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
# check for linux and kernel version
uname -a
# check for centos release version
cat /etc/centos-release
```

### 1.2 install repo and install kernel

```sh
yum install https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml -y
```

### 1.3 set grub2 and reboot

```sh
grub2-set-default 0
reboot
```

### 1.4 remove old kernel

```sh
yum remove kernel-3.10.0-1127.el7.x86_64 \
           kernel-3.10.0-1127.13.1.el7.x86_64 \
           kernel-headers-3.10.0-1127.18.2.el7.x86_64 \
           kernel-tools-3.10.0-1127.18.2.el7.x86_64 \
           kernel-tools-libs-3.10.0-1127.18.2.el7.x86_64 \
           kernel-3.10.0-1127.18.2.el7.x86_64
```

### 1.5 install new kernel tools

```sh
yum install --enablerepo=elrepo-kernel -y \
    kernel-ml kernel-ml-headers kernel-ml-devel \
    kernel-ml-tools kernel-ml-tools-libs
```

### 1.6 exclude kernel update when yum update

```sh
echo "exclude=kernel*" >> /etc/yum.conf
```

## 2. bbr

### 2.1 bbr setting

```sh
echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
sysctl -p
```

### 2.2 check

```bash
$ sysctl net.ipv4.tcp_available_congestion_control
net.ipv4.tcp_available_congestion_control = bbr cubic ren
$ lsmod | grep bbr
tcp_bbr 16384  1
```

## 3. v2ray

### 3.1 install

```sh
bash <(curl -L -s https://install.direct/go.sh)
```

### 3.2 config

config reference to `github.com/gitsang/script/network/v2ray-*-config.json`

## 4. firewalld

```sh
systemctl status firewalld
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --reload
firewall-cmd --zone=public --list-ports
```

## 5. vim update

```sh
git clone https://github.com/vim/vim.git && cd vim
./configure --enable-python3interp=yes
make -j8
make install
```

## reference

[^1]: [V2Ray完全使用教程](https://yuan.ga/v2ray-complete-tutorial/)

[^2]: [在 v2ray 中同时开启 socks 和 http 代理](https://iitii.github.io/2020/02/04/1/#routing-%e4%b8%8b-rule-%e7%9a%84-ip-%e6%88%96%e5%9f%9f%e5%90%8d%e4%b9%a6%e5%86%99%e8%a7%84%e8%8c%83)

[^3]: [开启v2ray代理服务器详细使用教程](https://www.rultr.com/tutorials/proxy/2268.html)

[^4]: [Project V](https://v2ray.com/)

[^5]: [V2Ray客户端配置指南](https://blog.seanchao.xyz/2018/08/v2ray-guide)

[^6]: [v2ray完全配置指南](https://ailitonia.com/archives/v2ray%E5%AE%8C%E5%85%A8%E9%85%8D%E7%BD%AE%E6%8C%87%E5%8D%97/#routing)

[^7]: [CentOS7内核升级、降级、指定内核版本，查看内核信息教程](https://sleele.com/2019/04/29/kernel/)
