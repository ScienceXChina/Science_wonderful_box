#!/bin/bash

#COLOUR CODE
RED='\E[1;31m'
GRN='\E[1;32m'
YEL='\E[1;33m'
RES='\E[0m'

#Dnowload Pathogen--->
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
			echo -e "${YEL} [ WARNING ]: ${RES} Please check the ~/.vim/ (May be Vim-pathogen had exist)."
			sudo rm -rf ./vim-pathogen
		fi
	fi
fi
echo -e "${GRN} --> INSTALLED Vim-pathogen. ${RES}"

#sudo sh -c 'echo "call pathogen#infect()
#syntax on
#filetype plugin indent on" >> ~/.vimrc'

if [ ! -d ~/.vim/bundle ];then
	mkdir ~/.vim/bundle
else
	echo -e "${YEL} [ WARNING ]: ${RES} ~/.vim/bundle had exist."
fi

#Dnowload Bundle (Vundle)
if [ ! -d ~/.vim/bundle/Vundle.vim ];then
	sudo git clone https://github.com/VundleVim/Vundle.vim.git 
	sudo mv ./Vundle.vim ~/.vim/bundle/
else
	echo -e "${YEL} [ WARNING ]: ${RES} /.vim/bundle/Vundle.vim had exist."
fi

#Dnowload Ctags 
sudo apt-get install ctags
echo -e "${GRN} --> INSTALLED Ctags ${RES}"

