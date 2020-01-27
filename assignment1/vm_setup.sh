#!/usr/bin/expect

#vbmg () { /mnt/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe "$@"; }

#vbmg startvm "TODO4640" --type headless
#cd ~/.ssh
#sleep 30
#ssh -i acit_admin_id_rsa admin@192.168.230.10
#ssh todoapp

# sudo useradd todoapp
# sudo usermod -aG wheel todoapp


scp -r setup/ todoapp:

ssh todoapp << 'Finish'

sudo usermod -aG wheel admin

cd setup

./install_script.sh

Finish