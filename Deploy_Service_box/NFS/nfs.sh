#!/bin/bash

# COLOUR CODE
RED='\E[1;31m'
GRN='\E[1;32m'
YEL='\E[1;33m'
RES='\E[0m'

# HINT
SUCCESS="${GRN} [ SUCCESS ]: ${RES}"
WARNING="${YEL} [ WARNING ]: ${RES}"
ERROR="${RED} [ ERROR ]: ${RES}"
NEED_SOLVE="------------> "

# INSTALL NFS FUNCTION
function INSTALL_NFS {
	sudo apt-get install nfs-kernel-server | tee ./.record_install
}

# UPDATE SOFTWARE SOURCE
sudo apt-get update

# INSTALL NFS
for ((i=1; i<=2; i++)); do 
	INSTALL_NFS 
done
grep -q "0 upgraded, 0 newly installed" ./.record_install
if [ $? -ne 0 ];then
	echo -e "${ERROR} Fail to install nfs-kernel-server."
else 
	echo -e "${SUCCESS} --> INSTALLED NFS"
fi
sudo rm -f ./.record_install

# Add configuration parameter for the config of nfs
echo " [ exemple ]: /home/ubuntu/share/ *(rw,sync,no_root_squash)"
sleep 1
read -p "Input directory that should be mounted :" DIR
read -p "Input IP that allow to access :" IP
read -p "Input authority for other :" AUTHY
sudo echo "${DIR} ${IP}${AUTHY}" | sudo tee -a /etc/exports

# Restart nfs service
# sudo /etc/init.d/portmap restart
sudo /etc/init.d/nfs-kernel-server restart

# TEST NFS OPERATE SITUATION
showmount -e 
