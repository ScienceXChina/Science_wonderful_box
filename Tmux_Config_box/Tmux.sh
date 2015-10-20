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

# INSTALL TMUX
sudo apt-get install tmux | grep "0 upgraded, 0 newly installed" > ./.record_install
grep -q "1 upgraded, 0 newly installed" ./.record_install                           
while [ $? -ne 0 ];
do
	sudo apt-get install tmux | grep "0 upgraded, 0 newly installed" > ./.record_install
	grep -q "0 upgraded, 0 newly installed" ./.record_install
done
echo -e "${SUCCESS}INSTALLED TMUX" 
rm -f ./.record_install

# DEPLOY TMUX
test -d ~/.tmux && echo -e "${WARNING}.tmux had existed." || cp -rf ./tmux ~/.tmux
test ~/.tmux.conf && echo -e "${WARNING}.tmux.conf had existed." || cp -rf ./tmux.conf ~/.tmux.conf 
if [ $? -eq 0 ];then
	echo -e "${NEED_SOLVE}${RED}Not deploy Tmux for user,you should backup and remove the configuration of tmux.${RES}"
	exit 1
else
	echo -e "${SUCCESS}DEPLOYED TMUX"
fi


