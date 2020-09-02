# deb from https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/

wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/containerd.io_1.2.6-3_armhf.deb
wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/docker-ce-cli_19.03.9~3-0~debian-buster_armhf.deb
wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/docker-ce_19.03.9~3-0~debian-buster_armhf.deb

dpkg -i containerd.io_1.2.6-3_armhf.deb
dpkg -i docker-ce-cli_19.03.9~3-0~debian-buster_armhf.deb
dpkg -i docker-ce_19.03.9~3-0~debian-buster_armhf.deb
