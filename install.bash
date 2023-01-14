#! /bin/bash 

FILE=~/vim-configuration
if [! -d "$FILE"]; then
	echo "$FILE does not exist"
fi

FILE=~/vim-configuration/install.bash
if [! -x "$FILE"]; then
	echo "$FILE is not executable"
fi 

