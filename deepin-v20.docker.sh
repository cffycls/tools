#!/bin/bash

sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get install \apt-transport-https \ca-certificates \curl \gnupg-agent \software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo echo 'deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/debian buster stable' > /etc/apt/sources.list.d/docker.list
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
docker version

