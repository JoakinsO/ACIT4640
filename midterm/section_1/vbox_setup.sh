#!/bin/bash

# This is a shortcut function that makes it shorter and more readable
vbmg () {
     VBoxManage "$@"; 
     }


#variables
NET_NAME="NETMIDTERM"
VM_NAME="MIDTERM4640"
SSH_PORT="12922"
WEB_PORT="12980"
NEW_NAME="A01021262"
USER_NAME="midterm"


# This function will clean the NAT network and the virtual machine
clean_network () {
    vbmg natnetwork remove --netname "$NET_NAME"
}


#creating the NAT network
create_network () {
    vbmg natnetwork add --netname "$NET_NAME" --network "192.168.10.0/24" --enable --dhcp off \
    --port-forward-4 "SSH:tcp:[127.0.0.1]:$SSH_PORT:[192.168.10.10]:22" \
    --port-forward-4 "HTTP:tcp:[127.0.0.1]:$WEB_PORT:[192.168.10.10]:80"
}


#renaming the vm
rename_vm (){
    vbmg modifyvm $VM_NAME --name "$NEW_NAME"
}


#starting the vm
start_vm (){
    vbmg startvm "$NEW_NAME"
        while true; do
            ssh "$USER_NAME" -o ConnectTimeout=4
            if [ $? -ne 0 ]; then
                    echo "The virtual machine is not up, sleeping..."
                    sleep 2
            else
                    break
            fi
        done
}


#running the script
echo "starting script..."

clean_network
create_network
rename_vm
start_vm