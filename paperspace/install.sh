#!/usr/bin/bash

# updates.
sudo apt-get -y update
sudo apt-get -y upgrade

# install cuda
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt-get update && sudo apt-get install -y nvidia-kernel-source-460
sudo apt-get -y install cuda

# permissions.
sudo chown paperspace /usr/local/bin

# trader etc.
sudo mkdir /etc/trader
sudo chown paperspace /etc/trader
