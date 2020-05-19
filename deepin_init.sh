#!/bin/bash

# 独立docker安装的其他
apt-get install git -y
cat >> /etc/hosts <<EOF
151.101.185.194 github.global-ssl.fastly.net
192.30.253.112 github.com
EOF
cat /etc/hosts
#sed -i '$a 151.101.185.194 github.global-ssl.fastly.net \n192.30.253.112 github.com' /etc/hosts && cat /etc/hosts
#echo -e "\n151.101.185.194  github.global-ssl.fastly.net \n192.30.253.112 github.com\n" >> /etc/hosts

