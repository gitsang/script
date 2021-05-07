
cat > /etc/netplan/00-installer-config.yaml << EOF
network:
  ethernets:
    enp1s0:
      addresses: [192.168.5.100/24]
      gateway4: 192.168.5.1
  version: 2
EOF

netplan apply
