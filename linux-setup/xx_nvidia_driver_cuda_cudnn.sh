#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'
echo -e "${RED}| ${YELLOW}02_nvidia_driver_cuda_cudnn.sh begin ${RED}| ${NC}\n"

echo -e "Start NVIDIA Graphic card setting"
echo -e "Install nvidia driver..."
sudo apt-get install -y build-essential
# sudo apt-get install -y linux-headers-`uname -r`
sudo wget https://us.download.nvidia.com/XFree86/Linux-x86_64/470.94/NVIDIA-Linux-x86_64-470.94.run
sudo sh NVIDIA-Linux-x86_64-470.94.run
# Reboot for nvidia-driver to manage display

echo -e "Install cuda..."
sudo wget https://developer.download.nvidia.com/compute/cuda/11.4.3/local_installers/cuda_11.4.3_470.82.01_linux.run
sudo sh cuda_11.4.3_470.82.01_linux.run
echo -e "" >> ~/.profile
echo -e "# CUDA and cuDNN paths" >> ~/.profile
echo -e "export PATH=\$PATH:/usr/local/cuda-11.4/bin" >> ~/.profile
echo -e "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/cuda-11.4/lib64" >> ~/.profile

echo -e "Install cudnn..."
sudo apt-get install -y zlib1g # for Ubuntu users
# sudo yum install zlib # for RHEL users
tar -xzvf cudnn-11.4-linux-x64-v8.2.4.15.tgz
sudo cp cuda/include/cudnn*.h /usr/local/cuda/include 
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda/lib64 
sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

# NCCL if needed

echo -e "${RED}| ${YELLOW}02_nvidia_driver_cuda_cudnn.sh done ${RED}| ${NC}"
echo -e "Type any keyboard input to continue...\n"
read