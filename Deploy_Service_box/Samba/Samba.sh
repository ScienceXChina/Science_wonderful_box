#!/bin/bash

#COLOUR CODE
RED='\E[1;31m'
GRN='\E[1;32m'
YEL='\E[1;33m'
RES='\E[0m'

#SET PATH VARIABLE
USER_DIR="/home/ubuntu"
SAMBA_DIR="/etc/samba"

#INSTALLE SAMBA
sudo apt-get update
sudo apt-get install samba smbclient
echo -e "${GRN} --> INSTALLED SAMBA ${RES}"

#BUILD SHARE DIRECTORY
if [ ! -d "$USER_DIR/share" ];then
	mkdir $USER_DIR/share
	sudo chmod 777 $USER_DIR/share
else
	echo -e "${YEL} [ WARNING ]: ${RES} share dir exist."
fi
echo -e "${GRN} --> BUILT share DIR ${RES}"

#BACKUP SAMBA CONFIG
if [ ! -f "$SAMBA_DIR/smb.conf.bak" ];then
	sudo cp $SAMBA_DIR/smb.conf $SAMBA_DIR/smb.conf.bak
else
	echo -e "${YEL} [ WARNING ]: ${RES} smb.conf.bak exist."
fi
echo -e "${GRN} --> BACKUPED CONFIG ${RES}"

#ADD SHARE INFORMATION
grep -q "\[share\]" $SAMBA_DIR/smb.conf
if [ $? -eq 0 ];then
	echo -e "${YEL} [ WARNING ]: ${RES} The share information had added."
else
	sudo sh -c 'echo "[share]
	path = /home/ubuntu/share
	available = yes
	browseable = yes
	public = yes
	writable = yes" >> /etc/samba/smb.conf'
fi
echo -e "${GRN} --> ADDED SHARE INFORMATION ${RES}"

#ADD PASSWORD
sudo touch $SAMBA_DIR/smbpasswd
sudo smbpasswd -a ubuntu
echo -e "${GRN} --> ADDED PASSWORD ${RES}"

#SERVICE RESTART
echo -e "${YEL} SAMBA service restart --> ${RES}"
sudo /etc/init.d/smbd restart
