#!/bin/bash

# Tensorflow installation for Ubuntu 20.04
# Packages:
#   - CUDA 11.2
#   - cuDNN 8.1
#   - Tensorflow 2.7.0
#

# to verify your gpu is cuda enable check
lspci | grep -i nvidia

# If you have previous installation remove it first. 
sudo apt -y clean
sudo apt -y update
sudo apt -y purge cuda
sudo apt -y purge nvidia-*
sudo apt-get purge nvidia*
sudo apt remove nvidia-*
sudo rm /etc/apt/sources.list.d/cuda*
sudo apt -y autoremove
sudo apt-get -y autoremove
sudo apt-get -y autoclean
sudo rm -rf /usr/local/cuda*

# system update
sudo apt-get -y update
sudo apt-get -y upgrade

# install other import packages
sudo apt-get -y install g++ freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev

# first get the PPA repository driver
#sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt -y update

# install nvidia driver with dependencies
sudo apt -y install libnvidia-common-470
sudo apt -y install libnvidia-gl-470
#sudo apt -y install nvidia-driver-470 # this results in failed cuda-11-2 installation.

sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" | sudo tee /etc/apt/sources.list.d/cuda.list
sudo apt-get -y update

 # installing CUDA-11.2
sudo apt -y install cuda-11-2 

# setup your paths
echo 'export PATH=/usr/local/cuda-11.2/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc
sudo ldconfig

# install cuDNN v11.2
wget https://developer.download.nvidia.com/compute/redist/cudnn/v8.1.1/cudnn-11.2-linux-x64-v8.1.1.33.tgz
tar -xzvf cudnn-11.2-linux-x64-v8.1.1.33.tgz

# copy the following files into the cuda toolkit directory.
sudo cp -P cuda/include/cudnn.h /usr/local/cuda-11.2/include
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda-11.2/lib64/
sudo chmod a+r /usr/local/cuda-11.2/lib64/libcudnn*

# install python.
sudo apt-get -y install python3-pip python3-venv

# install tensorflow.
pip3 install tensorflow==2.7.0

# Finally, to verify the installation, check
nvidia-smi
nvcc -V

# echo reboot.
echo "You must reboot to use the GPU's."
