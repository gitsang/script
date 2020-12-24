apt_init() {
    apt update
    apt upgrade -y
    apt autoremove -y
    apt install -y \
        net-tools iftop \
        git vim \
        zip unzip \
        apache2 \
        docker.io
}

apt_init

