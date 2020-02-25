#!/bin/bash

#selinux
setenforce 0

sed -r -i 's/^(%wheel\s+ALL=\(ALL\)\s+)(ALL)$/\1NOPASSWD: ALL/' /etc/sudoers
curl -s --user BCIT:w1nt3r2020 https://acit4640.y.vu/docs/module06/resources/mongodb_ACIT4640.tgz -o - | tar xzf -
mongorestore -d acit4640 ACIT4640

yum -y install git
yum -y install nodejs
yum -y install mongodb-server
yum -y install mongodb 

systemctl enable mongod
systemctl start mongod


useradd todoapp -p "P@ssw0rd"
usermod -aG wheel todoapp
#su - todoapp

mkdir /home/todoapp/app
# chown todoapp /home/todoapp/app
cd /home/todoapp/app
git clone https://github.com/timoguic/ACIT4640-todo-app.git /home/todoapp/app
chmod -R 755 /home/todoapp/app
npm install --prefix /home/todoapp/app

cp /home/admin/database.js /home/todoapp/app/config/
chown -R todoapp /home/todoapp/app
#Firewall
firewall-cmd --zone=public --add-port=8080/tcp
firewall-cmd --zone=public --list-all

#nginx
yum -y install nginx
systemctl enable nginx
systemctl start nginx

cp /home/admin/nginx.conf /etc/nginx/
systemctl restart nginx

chmod 755 /home/todoapp


#daemon
cp /home/admin/todoapp.service /etc/systemd/system/todoapp.service
systemctl daemon-reload

systemctl enable todoapp
systemctl start todoapp

systemctl restart nginx
systemctl restart todoapp

