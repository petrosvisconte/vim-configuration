#! /bin/bash 

### Checks files before running installation 
FILE=~/vim-configuration
if [ ! -d "$FILE" ]; then
	echo "$FILE does not exist"
	exit 1
fi
FILE=~/vim-configuration/colors
if [ ! -d "$FILE" ]; then
	echo "$FILE does not exist"
	exit 1
fi
FILE=~/vim-configuration/.vimrc
if [ ! -f "$FILE" ]; then
	echo "$FILE does not exist"
	exit 1
fi


### Copies files from github clone to user's directory
# Prompts user to overwrite or exit if they already have an existing .vimrc 
FILE=~/.vimrc
if [ -f "$FILE" ]; then
	until [ $dec = "y" ] || [ $dec = "n" ]; do
		read -p "A .vimrc has already been created. Overwrite file? [y/n]: " dec
	done
	if [ $dec = "n" ]; then
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
cp ~/vim-configuration/.vimrc ~	
cp ~/vim-configuration/colors/* ~/.vim/colors

### Allows user to select color scheme of their choice and appends code to .vimrc
read -p "Enter the name of your desired colorscheme: " color
FILE=~/.vim/colors/$color.vim
# Checks if color.vim is available
if [ ! -f "$FILE" ]; then
	avail=false
	# Prompts user to enter a valid name until they do
	while [ "$avail" = false ]
	do
		read -p "File cannot be found, please enter a valid name: " color
       		FILE=~/.vim/colors/$color.vim
		if [ -f "$FILE" ]; then
			avail=true
		fi
	done			
fi
# Appends colorscheme chosen to vim config file
echo "colorscheme $color" >> .vimrc

### Installs and setups vim-plug and desired plugins
#vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#lightline 
#  Plug 'itchyny/lightline.vim'
#  vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"
