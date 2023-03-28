#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

system_check() {
    # system check
    echo -e "${RED}uname -a\n${NC}`uname -a`\n"
    echo -e "Type any keyboard input to continue...\n"
    read
}

install_homebrew() {
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    export PATH=/opt/homebrew/bin:$PATH
}

install_packages() {
    echo -e "Install Basic Packages..."
    local packages=( \
        curl less tree \
        htop \
        vim tmux \
        tig gh \
        bat ripgrep fzf duf exa \
        direnv \
        asciinema neofetch \
        ncal \
        rsync \
        tldr \
        git wget \
        node \
        iterm2 \
        visual-studio-code \
    )
    # Install Homebrew packages
    for package in ${packages[@]}; do
        brew install $package
    done
}

set_python_symlink() {
    # python symbolic link
    echo -e "Set python symbolic link..."
    sudo ln -s /usr/bin/python3 /usr/bin/python
}

install_desktop() {
    system_check
    install_homebrew
    install_packages
    install_node
    set_python_symlink
}

case $1
in
    de|desktop)
        echo -e "${RED}| ${YELLOW}mac-setup.sh desktop begin ${RED}| ${NC}\n"
        install_desktop
        echo -e "${RED}| ${YELLOW}mac-setup.sh desktop done ${RED}| ${NC}"
        echo -e "Type any keyboard input to continue...\n"
        ;;
    h*|help|*)
        echo "Usage: bash mac-setup.sh [OPTION]"
        echo "Options:"
        echo ""
        echo "  desktop    Install mac for Desktop"
        echo "  help       Print this help"
        echo ""
esac

# todo. exa, neovim, fasd, anaconda, node, fd-find custom install
