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
        htop iotop nvtop gpustat \
        vim tmux \
        tig \
        bat fd-find ripgrep fzf \
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

install_exa() {
    # REMIND: need version update
    echo -e "Install EXA..."
    wget https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip -P exa/
    cd exa && unzip -o exa-linux-x86_64-v0.10.1.zip

    cp bin/exa /usr/local/bin
    cp completions/exa.zsh /usr/local/share/zsh/site-functions/_exa
    cp man/exa.1 /usr/share/man/man1/exa.1
    cp man/exa_colors.5 /usr/share/man5/exa_colors.5
}

install_anaconda() {
    # https://www.anaconda.com/products/distribution#linux
    echo -e "Install Anaconda..."
    wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh # REMIND: anaconda version update
    bash Anaconda3-2021.11-Linux-x86_64.sh
    rm -rf Anaconda3-2021.11-Linux-x86_64.sh
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
    install_fasd
    install_exa
    install_anaconda
    set_python_symlink
}

install_all

echo -e "${RED}| ${YELLOW}01_basic_setup.sh done ${RED}| ${NC}"
echo -e "Type any keyboard input to continue...\n"
