# vim_configuration
## About:  
The goal of this project is to create an all-in-one repository that includes all the files necessary to install and configure vim to ones liking as easily as possible. To perform the install and configuration process a script was written that does everything for the user, the user only needs to run the script and follow the prompts provided. Simply run the script, and you will be prompted to select your desired color modes, colorschemes, plugin manager, plugins and their available configurations. Everything will be automatically installed and configured as selected, nothing will be installed or added that was not specifically chosen.  
- Sudo/root are **not** required to run the setup script
### Requirements:
- vim
- python3
- git
- curl
### Some considerations:
This configuration script takes a minimalist approach which means only modifying the bare minimum required to have the user-selected installed colorschemes or plugins perform as expected. This approach was selected because more advanced configuration and tools like auto suggestions, auto indent, key bindings, etc, is extremely personal and user dependant. Therefore the default vim configuration was selected as the base which the user can then build off of and personalize further if desired after running the script.  
- The script does not install vim itself to avoid having to run the script as sudo/root. You may need to install vim before running the script, instructions for this have been provided further below.  
### Disclaimer:
Not all the work contained in this repository is my own. Files for things like the vim colorschemes for example are files that I found while searching online and decided to include. I have compiled a list of the original authors, as best as I can, at the very end of this file. If you would like to use my work, please give credit as well. 
  
       
       
# Available configurations: (Work in progress)
### Vim color modes:
This has an effect on colorschemes or plugins that have built in dark or light modes  
   
- dark
- light
### Vim colorschemes:
Sets the overall colorscheme in vim. All provided colorschemes are 256-color compatible 

- badwolf
- goodwolf
- iceberg
- monokai  
- 256_noir
- afterglow
- alduin
- anderson
- angr
- apprentice
- archery
- nord
### Plugin managers:
Used to install plugins

- vim-plug
### Plugins
- lightline
  - colorschemes:
    - https://github.com/itchyny/lightline.vim/blob/b1e91b41f5028d65fa3d31a425ff21591d5d957f/colorscheme.md
- airline      
- wakatime
- nerdtree

## Installing Vim:
```Bash
sudo apt install vim
```
or
```Bash
sudo apt-get install vim
```

## Setting Vim as the default text editor:
### Method 1: From the .bashrc file
Open the .bashrc file located in your home directory
```bash
vim ~/.bashrc 
```
Add the following lines to the end of the file
```bash
export VISUAL=vim
export EDITOR="$VISUAL"
```
### Method 2: From the command line (Debian/Ubuntu)
Enter the following command to set vim as the default editor for just the current user:  
```bash
select-editor
```
    
Enter the following command if you wish to set vim as the default editor system wide (or if the command above does not work)
```bash
sudo update-alternatives --config editor
```
Then, when prompted, enter the number that corresponds with the path containing vim.basic (be careful to select vim.basic and not vim.tiny)  


## Credits:    
monokai: https://github.com/sickill/vim-monokai  
badwolf: https://github.com/sjl/badwolf  
iceberg: https://github.com/cocopon/iceberg.vim  
vim-plug: https://github.com/junegunn/vim-plug  
lightline: https://github.com/itchyny/lightline.vim  
wakatime: https://wakatime.com  
256_noir: https://github.com/andreasvc/vim-256noir  
afterglow: https://github.com/danilo-augusto/vim-afterglow  
alduin: https://github.com/AlessandroYorba/Alduin    
anderson: https://github.com/tlhr/anderson.vim    
angr: https://github.com/zacanger/angr.vim  
apprentice: https://github.com/romainl/Apprentice  
archery: https://github.com/Badacadabra/vim-archery  
nord: https://github.com/arcticicestudio/nord-vim

