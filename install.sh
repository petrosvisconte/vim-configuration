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
			echo "> Install canceled"
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

### Allows user to select their color mode and appends necessary code to .vimrc
function set_colormode {
	local mode=
	until [ "$mode" = d ] || [ "$mode" = l ]; do
		read -p "Enter your desired color mode (dark or light). 
		This effects colorschemes and plugins with light and dark variants built in. [d/l]: " mode
	done
	if [ "$mode" = d ]; then
		echo 'set background=dark' >> ~/.vimrc
		echo "< dark mode set"
	else
		echo 'set background=light' >> ~/.vimrc
		echo "< light mode set"
	fi	
	# Appends colorscheme comment for later
	echo '" colorscheme' >> ~/.vimrc
}

### Allows user to select color scheme of their choice and appends necessary code to .vimrc
function set_colorscheme {
	local color
	read -p "Enter the name of the desired colorscheme, without file extension. 
	(Or press <enter> to list all available colors): " color
	if [ "$color" = "" ]; then
		echo -e "\n"
		ls ~/.vim/colors
		echo -e "\n"
		read -p "Enter the name of the desired colorscheme: " color
	fi	
	local FILE=~/.vim/colors/$color.vim
	# Checks if color.vim is available
	if [ ! -f "$FILE" ]; then
		until [ -f "$FILE" ]; do
			read -p "Color cannot be found, enter a valid name: " color
			FILE=~/.vim/colors/$color.vim		
		done
	fi
	echo "< ~/.vim/colors/$color.vim set as colorscheme"
	# Appends colorscheme chosen to vim config file
	echo "colorscheme $color" >> ~/.vimrc
}

### Installs and setups vim-plug
function install_vimplug {
	# Prompts user if they would like to install vim-plug and plugins
	local dec=
	until [ "$dec" = y ] || [ "$dec" = n ]; do
		read -p "Install vim-plug and desired plugins? [y/n]: " dec
	done
	if [ "$dec" = n ]; then
		echo "> Setup complete"
		exit 0
	fi
	# vim-plug
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	echo '' >> ~/.vimrc
	echo '" vim-plug plugins' >> ~/.vimrc
	echo 'call plug#begin()' >> ~/.vimrc
	echo 'call plug#end()' >> ~/.vimrc
	echo '> vim-plug installed'
}

### Installs plugin using vim :PlugInstall command
function plug_install {
	vim +'PlugInstall --sync' +qa
}


### Installs and setups lightline
function install_lightline {
	local dec=
	# prompts to install lightline
	until [ "$dec" = y ] || [ "$dec" = n ]; do
		read -p "Install lightline (status bar)? [y/n]: " dec
	done
	if [ "$dec" = y ]; then
		# adds lightline to plugins in .vimrc
		sed -i "/call plug#begin()/a Plug 'itchyny/lightline.vim'" ~/.vimrc
		# installs lightline
		plug_install
		echo "> lightline installed"
		# prompts user to select colorscheme for lightline
		local color
		read -p "Enter the name of the desired colorscheme for lightline, without file extension. 
		(Or press <enter> to list all available colors): " color
		if [ "$color" = "" ]; then
			echo -e "\n"
			ls ~/.vim/plugged/lightline.vim/autoload/lightline/colorscheme
			echo -e "\n"
			read -p "Enter the name of the desired lightline colorscheme: " color
		fi	
		local FILE=~/.vim/plugged/lightline.vim/autoload/lightline/colorscheme/$color.vim
		# Checks if color.vim is available
		if [ ! -f "$FILE" ]; then
			until [ -f "$FILE" ]; do
				read -p "Color cannot be found, enter a valid name: " color
				FILE=~/.vim/plugged/lightline.vim/autoload/lightline/colorscheme/$color.vim		
			done
		fi
		# Appends lightline congfiguration to .vimrc file
		{	
			echo ''
			echo '" lightline config'
			echo 'set noshowmode'
			echo 'let g:lightline = {'
	      		echo "	\ 'colorscheme': '$color',"
	      		echo '	\ }'	
		} >> ~/.vimrc
		
	fi	
} 

### Main function
function main {
	check_files
	copy_files
	set_colormode
	set_colorscheme
	install_vimplug
	install_lightline
	
	echo "> Selected plugins installed. You can find them in $HOME/.vim/plugged"
}

main
