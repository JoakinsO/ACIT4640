#!/bin/bash

USER = "todoapp"
PASSWORD = "P@ssw0rd"

sudo yum -y install git
sudo yum -y install nodejs
sudo yum -y install mongodb-server

sudo systemctl enable mongod
sudo systemctl start mongod


sudo useradd todoapp -p "P@ssw0rd"
sudo usermod -aG wheel todoapp
sudo su - todoapp

sudo mkdir /home/todoapp/app
sudo chown todoapp /home/todoapp/app
cd /home/todoapp/app
sudo git clone https://github.com/timoguic/ACIT4640-todo-app.git /home/todoapp/app
sudo chmod 755 /home/todoapp/app
sudo npm install --prefix /home/todoapp/app

sudo cp /home/admin/setup/database.js /home/todoapp/app/config/

#Firewall
sudo firewall-cmd --zone=public --add-port=8080/tcp
sudo firewall-cmd --zone=public --list-all

#nginx
sudo yum -y install nginx
sudo systemctl enable nginx
sudo systemctl start nginx

sudo cp /home/admin/setup/nginx.conf /etc/nginx/
sudo systemctl restart nginx

sudo chmod 755 /home/todoapp
sudo chmod 755 /home/todoapp/app/public/index.html

#selinux
sudo setenforce 0

#daemon
sudo cp /home/admin/setup/todoapp.service /etc/systemd/system/
sudo systemctl daemon-reload

sudo systemctl enable todoapp
sudo systemctl start todoapp

sudo systemctl restart nginx
sudo systemctl restart todoapp