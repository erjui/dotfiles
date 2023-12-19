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
        vim neovim tmux \
        tig gh \
        bat ripgrep fzf duf exa \
        direnv \
        asciinema neofetch \
        ncal \
        rsync \
        tldr \
        git git-lfs wget \
        node \
        iterm2 \
        visual-studio-code \
        nano \
        fasd \
        watch \
    )
    # Install Homebrew packages
    for package in ${packages[@]}; do
        brew install $package
    done
}

install_anaconda() {
    # https://repo.anaconda.com/archive/
    echo -e "Install Anaconda..."

    # For intel MAC
    # wget https://repo.anaconda.com/archive/Anaconda3-2023.03-MacOSX-x86_64.sh
    # bash Anaconda3-2023.03-MacOSX-x86_64.sh
    # rm -rf Anaconda3-2023.03-MacOSX-x86_64.sh

    # For M1 MAC
    wget https://repo.anaconda.com/archive/Anaconda3-2023.03-MacOSX-arm64.sh
    bash Anaconda3-2023.03-MacOSX-arm64.sh
    rm -rf Anaconda3-2023.03-MacOSX-arm64.sh
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
