#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'
echo -e "${RED}| ${YELLOW}01_basic_setup.sh begin ${RED}| ${NC}\n"

install_basic_packages() {
    local packages=( \
        build-essential man lspci curl less tree \
        htop nvtop \
        vim tmux \
        git tig \
        exa bat fd-find ripgrep fzf \
        direnv sshpass \
        asciinema neofetch \
        ncal xclip \
    )

    sudo apt update
    sudo apt upgrade
    for package in ${packages[@]}; do
        sudo apt install -y $package
    done
}


# system check
echo -e "${RED}uname -a\n${NC}`uname -a`\n"
echo -e "${RED}hostnamectl \n${NC}`hostnamectl`\n"
echo -e "${RED}lscpu\n${NC}`lscpu`\n"
echo -e "${RED}lsmem\n${NC}`lsmem`\n"
echo -e "${RED}lspci -vnn | grep VGA -A 12\n${NC}`lspci -vnn | grep VGA -A 12`\n"
# sudo dmidecode
echo -e "Type any keyboard input to continue...\n"
read

# system update
sudo apt update
sudo apt upgrade

# basic apt packages
echo -e "Start installing basic APT packages..."
# TODO: build exa with git feature
install_basic_packages

# python symbolic link
echo -e "Update python symbolic link..."
sudo ln -s /usr/bin/python3 /usr/bin/python

# anaconda
echo -e "Install Anaconda..."
wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh # REMIND: anaconda version update
bash Anaconda3-2021.11-Linux-x86_64.sh

echo -e "${RED}| ${YELLOW}01_basic_setup.sh done ${RED}| ${NC}"
echo -e "Type any keyboard input to continue...\n"
