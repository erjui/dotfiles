#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'
echo -e "${RED}| ${YELLOW}03_terminal_setup.sh begin ${RED}| ${NC}\n"

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

install_guake() {
    # install guake
    sudo apt install -y guake
    sudo cp -P /usr/share/applications/guake.desktop /etc/xdg/autostart/
}

install_zsh
install_guake

echo -e "${RED}| ${YELLOW}03_terminal_setup.sh done ${RED}| ${NC}"
echo -e "Type any keyboard input to continue...\n"
read
