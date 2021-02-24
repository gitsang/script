
## 关于 samba 多用户配置

- 在 [global] 下添加 `include = /etc/samba/%U.smb.conf`
- 用户在 `/etc/samba/` 目录下建立自己的配置文件，配置的目录仅自己可见
- 在 `/etc/samba/smb.conf` 下的目录即使设置了 `valid users`，其余人仍然能看到目录名
- 通过配置 `valid users` `write list` 来配置用户的读写权限
