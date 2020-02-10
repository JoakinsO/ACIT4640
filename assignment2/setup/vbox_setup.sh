#!/bin/bash

# This is a shortcut function that makes it shorter and more readable
vbmg () { /mnt/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe "$@"; }
# vbmg () {
#    VBoxManage.exe "$@"
#}

NET_NAME="4640"
VM_NAME="TODO-Assignment2"
SSH_PORT="12022"
WEB_PORT="12080"
PXE_PORT="12222"

SED_PROGRAM="/^Config file:/ { s/^.*:\s\+\(\S\+\)/\1/; s|\\\\|/|gp }"
#
# NEED CORRECTION... You run vminfo before creating the VM.
VBOX_FILE=$(vbmg showvminfo "$VM_NAME" | sed -ne "$SED_PROGRAM")
VM_DIR=$(dirname "$VBOX_FILE")

# This function will clean the NAT network and the virtual machine
clean_all () {
    vbmg natnetwork remove --netname "$NET_NAME"
    vbmg unregistervm "$VM_NAME" --delete 
}

create_network () {
        vbmg natnetwork add --netname $NET_NAME --network "192.168.230.0/24" --enable --dhcp off \
        --port-forward-4 "SSH:tcp:[127.0.0.1]:"$SSH_PORT":[192.168.230.10]:22" \
        --port-forward-4 "HTTP:tcp:[127.0.0.1]:"$WEB_PORT":[192.168.230.10]:80" \
        --port-forward-4 "SSH_PXE:tcp:[127.0.0.1]:12222:[192.168.230.200]:22"
        #ADDED... SSH to PXE server
}

create_vm () {
    vbmg createvm --name "$VM_NAME" --ostype "RedHat_64" --register
    #added extra 1GB(1024)
    vbmg modifyvm "$VM_NAME" --memory 2048 --cpus 1 --audio "none" --nic1 "natnetwork" --natnetwork1 "$NET_NAME" --boot1 disk --boot2 net
    
    vbmg createmedium disk --filename "$VM_NAME".vdi --format VDI --size 10240 

    vbmg modifymedium disk "$VM_NAME.vdi" --move "$VM_DIR"
    
    vbmg storagectl "$VM_NAME" --name "SATAcontroller"  --add "sata" --controller "IntelAHCI"
    vbmg storagectl "$VM_NAME" --name "IDEcontroller"   --add "ide"  --controller "PIIX4" 

    vbmg storageattach "$VM_NAME" --storagectl "SATAcontroller" --port 0 --device 0 --type "hdd" --medium "$VM_DIR/$VM_NAME".vdi
    vbmg storageattach "$VM_NAME" --storagectl "IDEcontroller"  --port 0 --device 0 --type "dvddrive" --medium "emptydrive"
}

echo "Starting script..."

clean_all
create_network
create_vm

echo "DONE!"