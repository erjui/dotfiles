#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

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
        tig gh \
        bat fd-find ripgrep fzf duf \
        direnv sshpass \
        asciinema neofetch \
        ncal \
        rsync \
        tldr \
    )

    # system update
    sudo apt update
    sudo apt upgrade
    for package in ${packages[@]}; do
        sudo apt install -y $package
    done
}

install_desktop_packages() {
    echo -e "Install Desktop Packages..."
    local packages=( \
        peek xclip
    )

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
    sudo apt update
    sudo apt install -y fasd
}

install_exa() {
    # REMIND: need version update
    echo -e "Install EXA..."
    wget https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip -P exa/
    cd exa && unzip -o exa-linux-x86_64-v0.10.1.zip

    sudo cp bin/exa /usr/local/bin
    sudo cp completions/exa.zsh /usr/local/share/zsh/site-functions/_exa
    sudo cp man/exa.1 /usr/share/man/man1/exa.1
    sudo cp man/exa_colors.5 /usr/share/man/man5/exa_colors.5

    cd .. && rm -rf exa
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

install_zsh() {
    # install zsh
    sudo apt install -y zsh

    # install oh-my zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # install zsh theme: powerlevel10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

    sudo mkdir -p /home/seongjae/.local/share/fonts
    sudo mv MesloLGS* /home/seongjae/.local/share/fonts/

    fc-cache -f -v
    fc-list | grep -i MesloLGS

    # install zsh plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    # setup default shell
    sudo chsh -s $(which zsh)
}

install_cargo() {
    # install rust package manager
    curl https://sh.rustup.rs -sSf | sh
    source "$HOME/.cargo/env"
}

install_sd() {
    # install sd (sed alternative)
    cargo install sd
}

install_guake() {
    # install guake
    sudo apt install -y guake
    sudo cp -P /usr/share/applications/guake.desktop /etc/xdg/autostart/
}

install_node() {
    # install node
    # @https://github.com/nodesource/distributions#debinstall
    sudo curl -fsSL https://deb.nodesource.com/setup_19.x | bash -
    sudo apt-get install -y nodejs
}

install_desktop() {
    system_check
    install_basic_packages
    install_git
    install_neovim
    install_fasd
    install_exa
    install_anaconda
    install_zsh
    install_cargo
    install_sd
    install_guake # guake only needed for Desktop
    install_desktop_packages # desktop packages
    install_node
    set_python_symlink
}

install_server() {
    system_check
    install_basic_packages
    install_git
    install_neovim
    install_fasd
    install_exa
    install_anaconda
    install_zsh
    install_cargo
    install_sd
    install_node
    set_python_symlink
}

case $1
in
    de|desktop)
        echo -e "${RED}| ${YELLOW}linux-setup.sh desktop begin ${RED}| ${NC}\n"
        install_desktop
        echo -e "${RED}| ${YELLOW}linux-setup.sh desktop done ${RED}| ${NC}"
        echo -e "Type any keyboard input to continue...\n"
        ;;
    s*|server)
        echo -e "${RED}| ${YELLOW}linux-setup.sh server begin ${RED}| ${NC}\n"
        install_server
        echo -e "${RED}| ${YELLOW}linux-setup.sh server done ${RED}| ${NC}"
        echo -e "Type any keyboard input to continue...\n"
        ;;
    dl)
        bash dl-setup.sh
        ;;
    h*|help|*)
        echo "Usage: bash linux-setup.sh [OPTION]"
        echo "Options:"
        echo ""
        echo "  desktop    Install linux/ubuntu for Desktop"
        echo "  server     Install linux/ubuntu for Server"
        echo "  dl         Install deep learning nvidia environment"
        echo "  help       Print this help"
        echo ""
esac

# TODO: fzf custom install
# TODO: git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# TODO: ~/.fzf/install
