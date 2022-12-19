#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'
echo -e "${RED}| ${YELLOW}01_basic_setup.sh begin ${RED}| ${NC}\n"

# system check
echo -e "${RED}uname -a\n${NC}`uname -a`\n"
echo -e "${RED}hostnamectl \n${NC}`hostnamectl`\n"
echo -e "${RED}lscpu\n${NC}`lscpu`\n"
echo -e "${RED}lsmem\n${NC}`lsmem`\n"
echo -e "${RED}lspci -vnn | grep VGA -A 12\n${NC}`lspci -vnn | grep VGA -A 12`\n"
# sudo dmidecode
echo -e "Type any keyboard input to continue...\n"
read

# basic apt packages
echo -e "Start installing basic APT packages..."
sudo apt install -y htop nvtop vim curl tmux git
sudo apt install -y tig exa bat fd-find ripgrep direnv sshpass
sudo apt install -y asciinema neofetch ncal

# python symbolic link
echo -e "Update python symbolic link..."
sudo ln -s /usr/bin/python3 /usr/bin/python

# anaconda
echo -e "Install Anaconda..."
wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh # REMIND: anaconda version update
bash Anaconda3-2021.11-Linux-x86_64.sh

echo -e "${RED}| ${YELLOW}01_basic_setup.sh done ${RED}| ${NC}"
echo -e "Type any keyboard input to continue...\n"
