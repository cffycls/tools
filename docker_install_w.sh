#!/bin/bash
#1. 卸载旧版本
apt-get remove docker docker-engine docker.io
#2. 安装依赖
apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
#3. 
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
#4. x86_64添加软件仓库
add-apt-repository "deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian $(lsb_release -cs) stable"
#5. 更新源并安装
apt-get update && apt-get install docker-ce -y


docker network create mybridge --subnet=172.1.0.0/16
docker network create others --subnet=111.0.0.0/8
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://kuogup1r.mirror.aliyuncs.com"],
  "dns": "8.8.8.8"
}
EOF

#开机启动、权限更改 添加用户cffycls到docker组
#gpasswd -a cffycls:docker && newgrp docker
usermod -aG docker wyq 
systemctl enable docker && systemctl restart docker


# 2020.05.19 build: docker-compose
wget -O docker-compose "https://github.com/docker/compose/releases/download/1.26.0-rc4/docker-compose-Linux-x86_64"
mv docker-compose /usr/local/bin/docker-compose
chown wyq:docker /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

