#/bin/bash

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

# Add the highlight code for ~/.bashrc
touch ./.man.config
echo "
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'" >> ./.man.config

grep -q "LESS_TERMCAP_" ~/.bashrc
if [ $? -eq 0 ]; then
	echo -e "$WARNING You should check the .bashrc for current user whether it have been added the highlight code"
else
	sudo cp ~/.bashrc ~/bashrc.bak
	sudo sh -c 'cat ./.man.config >> ~/.bashrc'
	rm -rf ./.man.config
	source ~/.bashrc
	echo -e "$SUCCESS Add the highlight code successful"
fi
