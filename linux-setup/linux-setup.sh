#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

# system_check() {
#     # system check
#     echo -e "${RED}uname -a\n${NC}`uname -a`\n"
#     echo -e "${RED}hostnamectl \n${NC}`hostnamectl`\n"
#     echo -e "${RED}lscpu\n${NC}`lscpu`\n"
#     echo -e "${RED}lsmem\n${NC}`lsmem`\n"
#     echo -e "${RED}lspci -vnn | grep VGA -A 12\n${NC}`lspci -vnn | grep VGA -A 12`\n"
#     # sudo dmidecode
#     echo -e "Type any keyboard input to continue...\n"
#     read
# }

install_basic_packages() {
    echo -e "Install Basic Packages..."
    local basic_packages=( \
        build-essential man lspci curl less tree \
        vim tmux htop git htop iotop nvtop rsync tldr \
    )

    local extra_packages=( \
        bat fd-find ripgrep fzf duf direnv sshpass \
        asciinema neofetch ncal tig gh \
    )

    # system update
    apt update
    apt upgrade
    apt install -y sudo # install sudo if not exist
    for package in ${basic_packages[@]}; do
        sudo apt install -y $package
    done
    for package in ${extra_packages[@]}; do
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

# install_script_packages() {
#     # packages for custom script
#     echo -e "Install Script Packages..."
#     local packages=( \
#         cpufrequtils xclip lmsensor hwinfo sshpass \
#     )

#     for package in ${packages[@]}; do
#         sudo apt install -y $package
#     done
# }

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

install_neovim_manual() {
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    tar -xvzf nvim-linux64.tar.gz
    cd nvim-linux64
    cp -r * $HOME/
    cd.. && rm -rf nvim-linux64 && rm nvim-linux64.tar.gz
}

install_fasd() {
    echo -e "Install FASD..."
    sudo add-apt-repository ppa:aacebedo/fasd
    sudo apt update
    sudo apt install -y fasd
}

install_fasd_manual() {
    echo -e "Install FASD..."
    DIR=$(dirname $(readlink -f $0))
    NEWDIR="$DIR/.."

    wget https://github.com/clvv/fasd/tarball/1.0.1 -O fasd.tar.gz
    tar -xvzf fasd.tar.gz
    cd clvv-fasd-4822024 && PREFIX=$NEWDIR make install
    cd .. && rm -rf clvv-fasd-4822024 && rm -rf fasd.tar.gz
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

install_exa_manual() {
    echo -e "Install exa manually..."
    DIR=$(dirname $(readlink -f $0))
    NEWDIR="$DIR/.."

    wget https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip -P exa/
    cd exa && unzip -o exa-linux-x86_64-v0.10.1.zip

    cp bin/exa $NEWDIR/bin
    cp completions/exa.zsh $NEWDIR/zsh/zfunc/
    cp man/exa.1 $NEWDIR/man/man1/exa.1
    cp man/exa_colors.5 $NEWDIR/man/man5/exa_colors.5

    cd .. && rm -rf exa
}

install_anaconda() {
    # https://www.anaconda.com/products/distribution#linux
    echo -e "Install Anaconda..."
    [ ! -f Anaconda3-2021.11-Linux-x86_64.sh ] && wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh # REMIND: anaconda version update
    bash Anaconda3-2021.11-Linux-x86_64.sh
    # rm -rf Anaconda3-2021.11-Linux-x86_64.sh
}

install_zsh() {
    # install zsh
    sudo apt install -y zsh

    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

    sudo mkdir -p ${HOME}/.local/share/fonts
    sudo mv MesloLGS* ${HOME}/.local/share/fonts/

    fc-cache -f -v
    fc-list | grep -i MesloLGS

    # setup default shell
    sudo chsh -s $(which zsh)
}

install_zsh_build() {
    # zsh requires ncurses
    export CXXFLAGS=" -fPIC" CFLAGS=" -fPIC" CPPFLAGS="-I${HOME}/include" LDFLAGS="-L${HOME}/lib"
    wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.2.tar.gz
    tar -xzvf ncurses-6.2.tar.gz
    cd ncurses-6.2
    ./configure --prefix=$HOME --enable-shared
    make
    make install
    cd .. && rm ncurses-6.2.tar.gz && rm -r ncurses-6.2

    # install zsh
    wget -O zsh.tar.xz https://sourceforge.net/projects/zsh/files/latest/download
    mkdir zsh && unxz zsh.tar.xz && tar -xvf zsh.tar -C zsh --strip-components 1
    cd zsh
    ./configure --prefix=$HOME
    make
    make install
    cd .. && rm zsh.tar && rm -r zsh

    # font for p10k
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

    sudo mkdir -p ${HOME}/.local/share/fonts
    sudo mv MesloLGS* ${HOME}/.local/share/fonts/

    fc-cache -f -v
    fc-list | grep -i MesloLGS

    # setup default shell
    echo -e "export SHELL=~/bin/zsh\nexec ~/bin/zsh -l" >> ~/.bash_profile
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
    # @https://github.com/nodesource/distributions#installation-instructions
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

    NODE_MAJOR=20
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

    # install node web packages
    sudo npm install -g http-server
    sudo npm install -g create-react-app
}

install_desktop() {
    # system_check
    instll_sudo
    install_basic_packages
    install_useful_packages
    install_script_packages
    install_zsh
    install_git
    install_neovim
    # install_fasd
    install_fasd_manual
    # install_exa
    install_exa_manual
    install_anaconda
    install_cargo
    install_sd
    install_guake # guake only needed for Desktop
    install_desktop_packages # desktop packages
    install_node
}

install_server() {
    # system_check
    install_sudo
    install_basic_packages
    install_useful_packages
    install_script_packages
    install_zsh
    install_git
    install_neovim
    # install_fasd
    install_fasd_manual
    # install_exa
    install_exa_manual
    install_anaconda
    # install_cargo
    # install_sd
    install_node
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
