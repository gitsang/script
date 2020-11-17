
wget https://github.com/fatedier/frp/releases/download/v0.34.2/frp_0.34.2_linux_amd64.tar.gz
tar zxvf frp_0.34.2_linux_amd64.tar.gz
cd frp_0.34.2_linux_amd64.tar.gz

cp frpc /usr/bin/
cp frps /usr/bin/

mkdir -p /etc/frp/
cp frpc.ini /etc/frp/
cp frps.ini /etc/frp/

cp systemd/frpc.service /usr/lib/systemd/system/
cp systemd/frps.service /usr/lib/systemd/system/

systemctl status frpc
systemctl status frps
