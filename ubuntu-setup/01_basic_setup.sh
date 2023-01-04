#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'
echo -e "${RED}| ${YELLOW}01_basic_setup.sh begin ${RED}| ${NC}\n"

system_check() {
    # system check
    echo -e "${RED}uname -a\n${NC}`uname -a`\n"
    echo -e "${RED}hostnamectl \n${NC}`hostnamectl`\n"
    echo -e "${RED}lscpu\n${NC}`lscpu`\n"
    echo -e "${RED}lsmem\n${NC}`lsmem`\n"
    echo -e "${RED}lspci -vnn | grep VGA -A 12\n${NC}`lspci -vnn | grep VGA -A 12`\n"
    # sudo dmidecode
    echo -e "Type any keyboard input to continue...\n"
    read
}

install_basic_packages() {
    echo -e "Install Basic Packages..."
    local packages=( \
        build-essential man lspci curl less tree \
        htop nvtop \
        vim tmux \
        tig \
        exa bat fd-find ripgrep fzf \
        direnv sshpass \
        asciinema neofetch \
        ncal xclip \
    )

    # system update
    sudo apt update
    sudo apt upgrade
    for package in ${packages[@]}; do
        sudo apt install -y $package
    done
}

install_anaconda() {
    # https://www.anaconda.com/products/distribution#linux
    echo -e "Install Anaconda..."
    wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh # REMIND: anaconda version update
    bash Anaconda3-2021.11-Linux-x86_64.sh
}

install_git() {
    # https://launchpad.net/~git-core/+archive/ubuntu/ppa
    echo -e "Install Git..."
    sudo add-apt-repository ppa:git-core/ppa
    sudo apt update
    sudo apt install -y git-all git-extras
}

install_neovim() {
    # https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable
    echo -e "Install Neovim..."
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt update
    sudo apt install -y neovim
}

install_fasd() {
    echo -e "Install FASD..."
    sudo add-apt-repository ppa:aacebedo/fasd
    sudo apt-get update
    sudo apt-get install fasd
}

set_python_symlink() {
    # python symbolic link
    echo -e "Set python symbolic link..."
    sudo ln -s /usr/bin/python3 /usr/bin/python
}

install_all() {
    system_check
    install_basic_packages
    install_git
    install_neovim
    install_fzf
    install_anaconda
    set_python_symlink
}

install_all

echo -e "${RED}| ${YELLOW}01_basic_setup.sh done ${RED}| ${NC}"
echo -e "Type any keyboard input to continue...\n"

# TODO: build exa with git feature