#! /bin/bash 

# Checks files before running installation 
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

# Allows user to select color scheme of their choice and appends code to .vimrc
read -p "Enter the name of your desired colorscheme: " color
FILE=~/vim-configuration/colors/$color.vim
# Checks if color.vim is available
if [ ! -f "$FILE" ]; then
	avail=false
	# Prompts user to enter a valid name until they do
	while [ "$avail" = false ]
	do
		read -p "File cannot be found, please enter a valid name: " color
       		FILE=~/vim-configuration/colors/$color.vim
		if [ -f "$FILE" ]; then
			avail=true
		fi
	done			
fi
# Appends colorscheme chosen to vim config file
echo "colorscheme $color" >> .vimrc

