yum install samba -y

cp smb.conf /etc/samba/smb.conf

smbpasswd -a root

systemctl enable smb
systemctl restart smb
