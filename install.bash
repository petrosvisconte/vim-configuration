#! /bin/bash 

FILE=~/vim-configuration
if [ ! -d "$FILE" ]; then
	echo "$FILE does not exist"
fi
FILE=~/vim-configuration/colors
if [ ! -d "$FILE" ]; then
	echo "$FILE does not exist"
fi
FILE=~/vim-configuration/.vimrc
if [ ! -d "$FILE" ]; then
	echo "$FILE does not exist"
fi
