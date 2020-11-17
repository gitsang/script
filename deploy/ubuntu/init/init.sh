init() {
    apt update
    apt upgrade -y
    apt autoremove -y
    apt install -y \
        net-tools iftop \
        git vim \
        zip unzip \
        docker.io

    git config --global user.email "sang.chen@outlook.com"
    git config --global user.name "gitsang"
    git config --global core.editor "vim"
    git config --global push.default simple
}
