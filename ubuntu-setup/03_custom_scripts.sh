#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'
echo -e "${RED}| ${YELLOW}04_custom_script.sh begin ${RED}| ${NC}\n"

# custom scripts
sudo apt install -y cpufrequtils xclip lmsensor hwinfo sshpass
echo -e "" >> ~/.profile
echo -e "# Custom Scripts" >> ~/.profile
echo -e "export PATH=\$PATH:/home/seongjae/Documents/scripts/" >> ~/.profile
echo -e "export SCRIPT_PATH=/home/seongjae/Documents/scripts/" >> ~/.profile
# sudo dpkg-reconfigure dash
sudo dpkg-reconfigure bash # TODO: check 

echo -e "${RED}| ${YELLOW}04_custom_script.sh done ${RED}| ${NC}"
echo -e "Type any keyboard input to continue...\n"
read