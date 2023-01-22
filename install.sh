#!/usr/bin/env bash
#
# Configures vim and plugins
# Author: Pierre Visconti
# Github: https://github.com/petrosvisconte

set -euo pipefail


### Checks files before running installation
function check_files {
	local FILE=~/vim_configuration
	if [ ! -d "${FILE}" ]; then
		echo "${FILE} does not exist"
		exit 1
	fi
	FILE=~/vim_configuration/colors
	if [ ! -d "${FILE}" ]; then
		echo "${FILE} does not exist"
		exit 1
	fi
	FILE=~/vim_configuration/.vimrc
	if [ ! -f "${FILE}" ]; then
		echo "${FILE} does not exist"
		exit 1
	fi
}

### Copies files from github clone to user's directory
function copy_files {
	local FILE=~/.vimrc
	# Prompts user to overwrite or exit if they already have an existing .vimrc 
	if [ -f "${FILE}" ]; then
		local dec=
		until [ "${dec}" = y ] || [ "${dec}" = n ]; do
			read -pr $'\n'"A .vimrc has already been created. Overwrite file? [y/n]: " dec
		done
		if [ "${dec}" = n ]; then
			echo "> Install canceled"
			exit 1
		fi
	fi
	# Creates necessary directories if they do not already exist
	FILE=~/.vim
	if [ ! -d "${FILE}" ]; then
		mkdir -p ~/.vim/colors
	else
		FILE=~/.vim/colors
		if [ ! -d "${FILE}" ]; then
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
	until [ "${mode}" = d ] || [ "${mode}" = l ]; do
		read -p $'\n'"Enter your desired color mode (dark or light). 
		This effects colorschemes and plugins with light and dark variants built in. [d/l]: " mode
	done
	if [ "${mode}" = d ]; then
		echo 'set background=dark' >> ~/.vimrc
		echo "> dark mode set"
	else
		echo 'set background=light' >> ~/.vimrc
		echo "> light mode set"
	fi
	# Appends colorscheme comment for later
	echo '" colorscheme' >> ~/.vimrc
}

### Allows user to select color scheme of their choice and appends necessary code to .vimrc
function set_colorscheme {
	local color
	read -pr $'\n'"Enter the name of the desired colorscheme, without file extension. 
	(Or press <enter> to list all available colors): " color
	if [ "${color}" = "" ]; then
		echo -e "\n"
		ls ~/.vim/colors
		echo -e "\n"
		read -pr "Enter the name of the desired colorscheme: " color
	fi
	local FILE=~/.vim/colors/${color}.vim
	# Checks if color.vim is available
	if [ ! -f "${FILE}" ]; then
		until [ -f "${FILE}" ]; do
			read -pr "Color cannot be found, enter a valid name: " color
			FILE=~/.vim/colors/$color.vim
		done
	fi
	echo "< ${FILE} set as colorscheme"
	# Appends colorscheme chosen to vim config file
	echo "colorscheme ${color}" >> ~/.vimrc
}

### Installs and setups vim-plug
function install_vimplug {
	# Prompts user if they would like to install vim-plug and plugins
	local dec=
	until [ "${dec}" = y ] || [ "${dec}" = n ]; do
		read -pr $'\n'"Install vim-plug and desired plugins? [y/n]: " dec
	done
	if [ "${dec}" = n ]; then
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

function select_statusbar {
	local dec=
	until [ "${dec}" = y ] || [ "${dec}" = n ]; do
		read -pr $'\n'"Install a status bar? [y/n]: " dec
	done
	if [ "${dec}" = y ]; then
		echo 'Select one of the following options (Enter the corresponding number):'
		echo '1. lightline'
		echo '2. airline'
		dec=
	fi
}


### Installs and setups lightline
function install_lightline {
	local dec=
	# prompts to install
	until [ "${dec}" = y ] || [ "${dec}" = n ]; do
		read -pr $'\n'"Install lightline (status bar)? [y/n]: " dec
	done
	if [ "${dec}" = y ]; then
		# adds lightline to plugins in .vimrc
		sed -i "/call plug#begin()/a Plug 'itchyny/lightline.vim'" ~/.vimrc
		# installs lightline
		plug_install
		echo "> lightline installed"
		# prompts user to select colorscheme for lightline
		local color
		read -pr $'\n'"Enter the name of the desired colorscheme for lightline, without file extension. 
		(Or press <enter> to list all available colors): " color
		if [ "${color}" = "" ]; then
			echo -e "\n"
			ls ~/.vim/plugged/lightline.vim/autoload/lightline/colorscheme
			echo -e "\n"
			read -pr "Enter the name of the desired lightline colorscheme: " color
		fi	
		local FILE=~/.vim/plugged/lightline.vim/autoload/lightline/colorscheme/${color}.vim
		# Checks if color.vim is available
		if [ ! -f "${FILE}" ]; then
			until [ -f "${FILE}" ]; do
				read -pr "Color cannot be found, enter a valid name: " color
				FILE=~/.vim/plugged/lightline.vim/autoload/lightline/colorscheme/${color}.vim
			done
		fi
		# Appends lightline congfiguration to .vimrc file
		{
			echo ''
			echo '" lightline config'
			echo 'set noshowmode'
			echo 'let g:lightline = {'
			echo " \ 'colorscheme': '${color}',"
			echo ' \ }'
		} >> ~/.vimrc
		echo "> ${FILE} set as colorscheme"
	fi
} 

### Installs and setups wakatime
function install_wakatime {
	local dec=
	# prompts to install
	until [ "${dec}" = y ] || [ "${dec}" = n ]; do
		read -pr $'\n'"Install wakatime (coding activity and stats)? 
		Note: You will need to enter your API key into vim when prompted [y/n]: " dec
	done
	if [ "${dec}" = y ]; then
		# adds wakatime to plugins in .vimrc
		sed -i "/call plug#begin()/a Plug 'wakatime/vim-wakatime'" ~/.vimrc
		# installs wakatime
		plug_install
		plug_install # calls second time for API key
		echo "> wakatime installed"
	fi 
}

### Installs and setups nerdtree
function install_nerdtree {
	local dec=
	# prompts to install
	until [ "${dec}" = y ] || [ "${dec}" = n ]; do
		read -pr $'\n'"Install NerdTree (file browser) [y/n]: " dec
	done
	if [ "${dec}" = y ]; then
		# adds nerdtree to plugins in .vimrc
		sed -i "/call plug#begin()/a Plug 'preservim/nerdtree'" ~/.vimrc
		# installs nerdtree
		plug_install
		echo "> nerdtree installed"
	fi 
}

### Installs and setups undotree
function install_undotree {
	local dec=
	# prompts to install
	until [ "${dec}" = y ] || [ "${dec}" = n ]; do
		read -pr $'\n'"Install undotree (keeps an edit history) [y/n]: " dec
	done
	if [ "${dec}" = y ]; then
		# adds undotree to plugins in .vimrc
		sed -i "/call plug#begin()/a Plug 'mbbill/undotree'" ~/.vimrc
		# installs undotree
		plug_install
		echo "> undotree installed"
	fi 
}

### Installs and setups ycm 
function install_ycm {
	local dec=
	# prompts to install
	until [ "${dec}" = y ] || [ "${dec}" = n ]; do
		read -pr $'\n'"Install YouCompleteMe (Autosuggestions, auto complete, warnings/erros) [y/n]: " dec
	done
	if [ "${dec}" = y ]; then
		# adds undotree to plugins in .vimrc
		sed -i "/call plug#begin()/a Plug 'Valloric/YouCompleteMe'" ~/.vimrc
		# installs undotree
		plug_install
		echo "> YouCompleteMe installed"
	fi 
}

### Main function
function main {

	check_files
	copy_files
	set_colormode
	set_colorscheme
	install_vimplug
	# select_statusbar
	
	install_lightline
	install_wakatime
	install_nerdtree
	install_undotree
	install_ycm 

	echo "> Selected plugins installed. You can find them in $HOME/.vim/plugged"
}

main "$@"
