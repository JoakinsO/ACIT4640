#!/bin/bash

#installing git
sudo yum -y install git

#create user
sudo useradd hichat -p "P@ssw0rd"
sudo usermod -aG wheel hichat

# disable password
sed -r -i 's/^(%wheel\s+ALL=\(ALL\)\s+)(ALL)$/\1NOPASSWD: ALL/' /etc/sudoers

#making app directory and cloning hichat repo
sudo mkdir /home/hichat/app
cd /home/hichat/app
sudo git clone https://github.com/wayou/HiChat.git /home/hichat/app
sudo chmod -R 755 /home/hichat/app
sudo chown -R hichat /home/hichat/app

#installing node dependencies
sudo yum -y install nodejs
sudo yum -y install mongodb-server
sudo npm install --prefix /home/hichat/app

#Firewall
sudo firewall-cmd --zone=public --add-port=12980/tcp
sudo firewall-cmd --zone=public --list-all

#nginx
sudo yum -y install nginx
sudo systemctl enable nginx
sudo systemctl start nginx
sudo cp /home/midterm/nginx.conf /etc/nginx/
sudo systemctl restart nginx

#selinux
sudo setenforce 0

#daemon
sudo cp /home/midterm/hichat.service /etc/systemd/system/hichat.service
sudo systemctl daemon-reload

sudo systemctl enable hichat
sudo systemctl start hichat

sudo systemctl restart nginx
sudo systemctl restart hichat


