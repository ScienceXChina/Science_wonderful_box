#!/bin/bash

#COLOUR CODE
RED='\E[1;31m'
GRN='\E[1;32m'
YEL='\E[1;33m'
RES='\E[0m'

# HINT
SUCCESS="${GRN} [ SUCCESS ]: ${RES}"
WARNING="${YEL} [ WARNING ]: ${RES}"
ERROR="${RED} [ ERROR ]: ${RES}"
NEED_SOLVE="------------> "

# Replace sources.list
sudo cp -f ./sources.list /etc/apt/sources.list && sudo apt-get update
grep -q "main restricted universe multiverse" /etc/apt/sources.list
if [ $? -ne 0 ];then
	echo -e "${ERROR} Please check the /etc/apt/sources.list"
else
	echo -e "${SUCCESS} --> REPLACED sources.list"
fi

# Replace .vimrc
if [ ! -f ~/.vimrc ];then
	sudo cp -f ./vimrc ~/.vimrc
else
	sudo cp -f ~/.vimrc ~/vimrc.bak
	sudo cp -f ./vimrc ~/.vimrc
fi
echo -e "${SUCCESS} --> Add .vimrc for user now"

# Dnowload Pathogen--->
git clone https://github.com/tpope/vim-pathogen
if [ ! -d ./vim-pathogen ];then 
	while [ ! -d ./vim-pathogen ]
	do
		git clone https://github.com/tpope/vim-pathogen
	done
else
	if [ ! -d ~/.vim ];then
		sudo mkdir ~/.vim
		sudo mv ./vim-pathogen/autoload ~/.vim/
		sudo rm -rf ./vim-pathogen
	else
		if [ ! -d ~/.vim/autoload ];then
			sudo mv ./vim-pathogen/autoload ~/.vim/
			sudo rm -rf ./vim-pathogen
		else
			echo -e "${WARNING} Please check the ~/.vim/ (May be Vim-pathogen had exist)."
			sudo rm -rf ./vim-pathogen
		fi
	fi
fi
echo -e "${SUCCESS} --> INSTALLED Vim-pathogen."

#sudo sh -c 'echo "call pathogen#infect()
#syntax on
#filetype plugin indent on" >> ~/.vimrc'

if [ ! -d ~/.vim/bundle ];then
	mkdir ~/.vim/bundle
else
	echo -e "${WARNING} ~/.vim/bundle had exist."
fi

# Dnowload Bundle (Vundle)
if [ ! -d ~/.vim/bundle/Vundle.vim ];then
	sudo git clone https://github.com/VundleVim/Vundle.vim.git 
	sudo mv ./Vundle.vim ~/.vim/bundle/
else
	echo -e "${WARNING} /.vim/bundle/Vundle.vim had exist."
fi

# Dnowload Ctags 
CTAGS=1
while [ ${CTAGS} -ne 0 ]; do
	sudo apt-get install ctags | tee ./.record_install
	grep -q "0 upgraded, 0 newly installed" ./.record_install
	if [ $? -ne 0 ]; then
		CTAGS=1
	else
		CTAGS=0
	fi
done
if [ $? -ne 0 ];then
	echo -e "${WARNING} Fail to install ctags"
else
	echo -e "${SUCCESS} --> INSTALLED Ctags"
fi
sudo rm -f ./.record_install

# Dnowload Cscope
CSCOPE=1
while [ ${CSCOPE} -ne 0 ]; do
	sudo apt-get install cscope | tee ./.record_install 
	grep -q "0 upgraded, 0 newly installed" ./.record_install
	if [ $? -ne 0 ]; then
		CSCOPE=1
	else
		CSCOPE=0
	fi
done
if [ $? -ne 0 ];then
	echo -e "${WARNING} Fail to install cscope"
else
	echo -e "${SUCCESS} --> INSTALLED Cscope"
fi
sudo rm -f ./.record_install
