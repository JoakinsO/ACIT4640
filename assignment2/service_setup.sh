#!/bin/bash

PXE_VM = "PXE4640"
PXE_PORT = "12222"
TODO_VM = "TODO-Assignment2"
TODO_PORT = "12022"


vbmg () { /mnt/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe "$@"; }

start_vm(){
    vbmg startvm "PXE4640"
        while /bin/true; do
            ssh -i ~/.ssh/acit_admin_id_rsa -p "12222" \
                -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
                -q admin@localhost exit
            if [ $? -ne 0 ]; then
                    echo "PXE server is not up, sleeping..."
                    sleep 2
            else
                    break
            fi
        done
}

start_todo(){
    vbmg startvm "TODO-Assignment2"
        while /bin/true; do
            ssh -i ~/.ssh/acit_admin_id_rsa -p "12022" \
                -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
                -q admin@localhost exit
            if [ $? -ne 0 ]; then
                    echo "TODO virtual machine is not up, sleeping..."
                    sleep 2
            else
                    break
            fi
        done
}

stop_pxe(){
    vbmg controlvm "PXE4640" poweroff
}


echo "Starting script..."

./setup/vbox_setup.sh
start_vm

scp -r setup/ pxe:

ssh pxe << 'pxe'
cp /home/admin/setup/ks.cfg /var/www/lighttpd/files/ks.cfg
cp /home/admin/setup/authorized_keys /var/www/lighttpd/files/authorized_keys
chmod -R 755 /var/www/lighttpd/files
chown -R admin:admin /var/www/lighttpd/files
pxe

start_todo 

./setup/vm_setup.sh

stop_pxe


#Run PXE server
#vbmg startvm "PXE4640" --type headless