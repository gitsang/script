#!/bin/bash

apt install samba -y

cp smb.conf /etc/samba/smb.conf

smbpasswd -a root

systemctl enable smbd
systemctl restart smbd

