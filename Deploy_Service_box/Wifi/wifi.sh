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

# VARIABLES

# Reboot flags
grep -q "REBOOT_PARAMETER=1" /etc/profile
if [ $? -ne 0 ]; then
	REBOOT_PARAMETER=0
else
	REBOOT_PARAMETER=1
fi

# Install Inter 7260 mini PCIe wireless driver for TK1 
function INSTALL_FIRMWARE {
	sudo apt-get install linux-firmware | sudo tee ./.record_install
}

sudo apt-get update
INSTALL_FIRMWARE
grep -q "0 upgraded, 1 newly installed" ./.record_install
while [ $? -ne 0 ];
do
	INSTALL_FIRMWARE
	grep -q "0 upgraded, 0 newly installed" ./.record_install
done
# sudo sh -c 'echo "$PWD/wifi.sh" >> /etc/profile'
if [ $REBOOT_PARAMETER -eq 1 ]; then
	sudo mv /etc/profile.bak /etc/profile
else
	sudo cp -f /etc/profile /etc/profile.bak
	sudo sh -c 'echo "export REBOOT_PARAMETER=1" >> /etc/profile'
	#sudo reboout
	#echo "sleep 3 second"
	#sudo sleep 3   #test the script
	echo -e "${WARNING} Please reboot your system now and keep on ./wifi.sh ."
	exit 1
fi
sudo rm -f ./.record_install

# Check the Inter 7260 mini PCIe wireless driver for TK1
lspci | grep -q "Network controller: Intel Corporation Wireless 7260"
if [ $? -eq 0 ];then
	echo -e "${SUCCESS} The driver of wireless is ok."
else
	echo -e "${ERROR} The operation of wireless is unsuccessful."
	echo -e "${NEED_SOLVE}${RED} Please reinstall the driver of wireless.${RES}"
	exit 1
fi

# Check the operation of wireless 
ifconfig | grep -q "wlan0"
if [ $? -eq 0 ];then
	echo -e "${SUCCESS} The operation of wireless is ok."
else
	echo -e "${WARNING} May be you should check it again."
	echo -e "${NEED_SOLVE}${RED} Restart the wireless service.${RES}"
	exit 1
fi

# Find the available wireless and choose
sudo iwlist wlan0 scan | grep "ESSID:"
read -p "Please choose wifi :" ESSID
read -p "Please input password :" PSK

# Wifi configuration
#sudo sh -c 'echo "network={
#	ssid=
#	psk=
#	prioriity=5
#}" >> /etc/wpa_supplicant.conf.test'
touch ./.wpa_supplicant.conf 
echo -e "network={
	ssid=\"$ESSID\"
	psk=\"$PSK\"
	priority=1
}" > ./.wpa_supplicant.conf
sudo sh -c 'cat ./.wpa_supplicant.conf >> /etc/wpa_supplicant.conf'
sudo rm -f ./.wpa_supplicant.conf
echo -e "${SUCCESS} Choose ${ESSID} is ok."

# Wifi interfaces service
sudo sh -c 'echo "auto lo
iface lo inet loopback
auto eth0
iface eth0 inet dhcp
allow-hotplug wlan0
iface wlan0 inet manual
wpa-roam /etc/wpa_supplicant.conf
iface default inet dhcp" >> /etc/network/interfaces'
echo -e "${SUCCESS} Deployed the wifi interfaces"

# The network service restart
echo -e "${WARNING} Reboot for restarting the network service now."
#sudo /etc/init.d/networking restart
echo -e "${WARNING} if IP is not true,please execute the commond 
\n --> sudo ifdown wlan0 && sudo ifup wlan0"





