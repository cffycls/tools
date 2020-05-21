#!/bin/bash

## CentOS 8 安装实操
# 第一部分 安装源
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-8.repo
sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
yum makecache
#应用商店bug
dnf install -y centos-release-stream and dnf update -y


#安装git、输入法、docker
yum install git -y
sed -i '$a 151.101.185.194 github.global-ssl.fastly.net \n192.30.253.112 github.com' /etc/hosts
cat /etc/hosts && nmcli c reload ifcfg-ens33 && nmcli c up ens33

dnf install ibus-libpinyin.x86_64 -y
yum install yum-utils -y
dnf install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.13-3.2.el7.x86_64.rpm -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io
systemctl start docker

mkdir /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://kuogup1r.mirror.aliyuncs.com"],
  "dns": ["8.8.8.8"]
}
EOF
systemctl restart docker
usermod -aG docker cffycls
systemctl enable docker
curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

