#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'
echo -e "${RED}| ${YELLOW}03_terminal_setup.sh begin ${RED}| ${NC}\n"

# terminal setting
echo -e "Start setting terminal"
echo -e "Install Zsh..."
sudo apt install -y zsh
zsh --version

echo -e "Install Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# REMIND: stop at this point: press ctrl D

echo -e "Install Zsh Theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

sudo mkdir -p /home/seongjae/.local/share/fonts
sudo mv MesloLGS* /home/seongjae/.local/share/fonts/

fc-cache -f -v
fc-list | grep -i MesloLGS

echo -e "Install Zsh Plugins..."
echo -e "Install Zsh Plugins: zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
echo -e "Install Zsh Plugins: zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
echo -e "Install Zsh Plugins: fzf"
sudo apt-get install -y fzf
echo -e "Install Zsh Plugins: fasd"
sudo add-apt-repository ppa:aacebedo/fasd
sudo apt-get update
sudo apt-get install fasd

echo -e "Install Guake terminal..."
sudo apt install guake
sudo cp -P /usr/share/applications/guake.desktop /etc/xdg/autostart/
# REMIND: guake -p to change settings

# Shell change done by installing Oh My Zsh #REMIND: seems not working right after installation
echo -e "Change default shell to zsh..."
sudo chsh -s $(which zsh)
echo -e $SHELL
$SHELL --version

echo -e "${RED}| ${YELLOW}03_terminal_setup.sh done ${RED}| ${NC}"
echo -e "Type any keyboard input to continue...\n"
read
