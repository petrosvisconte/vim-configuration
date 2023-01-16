#!/usr/bin/env bash
set -euo pipefail


### Checks files before running installation
function check_files {
	local FILE=~/vim_configuration
	if [ ! -d "$FILE" ]; then
		echo "$FILE does not exist"
		exit 1
	fi
	FILE=~/vim_configuration/colors
	if [ ! -d "$FILE" ]; then
		echo "$FILE does not exist"
		exit 1
	fi
	FILE=~/vim_configuration/.vimrc
	if [ ! -f "$FILE" ]; then
		echo "$FILE does not exist"
		exit 1
	fi
} 

### Copies files from github clone to user's directory
function copy_files {
	local FILE=~/.vimrc
	# Prompts user to overwrite or exit if they already have an existing .vimrc 
	if [ -f "$FILE" ]; then
		local dec=
		until [ "$dec" = y ] || [ "$dec" = n ]; do
			read -p "A .vimrc has already been created. Overwrite file? [y/n]: " dec
		done
		if [ "$dec" = n ]; then
			echo "Install canceled"
			exit 1
		fi
	fi
	# Creates necessary directories if they do not already exist
	FILE=~/.vim
	if [ ! -d "$FILE" ]; then
		mkdir -p ~/.vim/colors
	else
		FILE=~/.vim/colors
		if [ ! -d "$FILE" ]; then
			mkdir ~/.vim/colors
		fi
	fi
	# Copies the files
	cp ~/vim_configuration/.vimrc ~	
	cp ~/vim_configuration/colors/* ~/.vim/colors
}

### Allows user to select color scheme of their choice and appends code to .vimrc
function set_color {
	local color
	read -p "Enter the name of the desired colorscheme: " color
	local FILE=~/.vim/colors/$color.vim
	# Checks if color.vim is available
	if [ ! -f "$FILE" ]; then
		until [ -f "$FILE" ]; do
			read -p "Color cannot be found, enter a valid name: " color
			FILE=~/.vim/colors/$color.vim		
		done
	fi
	# Appends colorscheme chosen to vim config file
	echo "colorscheme $color" >> ~/.vimrc
}

### Installs and setups vim-plug
function install_vimplug {
	# Prompts user if they would like to install vim-plug and plugins
	local dec=
	until [ "$dec" = y ] || [ "$dec" = n ]; do
		read -p "Install vim-plug and desired plugins? [y/n]: " dec1
	done
	if [ "$dec" = n ]; then
		echo "Setup complete"
		exit 0
	fi
	# vim-plug
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	echo "" >> ~/.vimrc
	echo '" vim-plug plugins' >> ~/.vimrc
	echo "call plug#begin()" >> ~/.vimrc
	echo "call plug#end()" >> ~/.vimrc
	echo 'vim-plug installed'
}

### Installs and setups lightline
function install_lightline {
	local dec=
	until [ "$dec" = y ] || [ "$dec" = n ]; do
		read -p "Install lightline (status bar)? [y/n]: " dec2
	done
	if [ "$dec" = y ]; then
		sed -i "/call plug#begin()/a Plug 'itchyny/lightline.vim'" ~/.vimrc
	fi 
	#  vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"
} 

### Main function
function main {
	check_files
	copy_files
	set_color
	install_vimplug
	install_lightline

}

main
