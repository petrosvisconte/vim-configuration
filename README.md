# vim-configuration

monokai: https://github.com/sickill/vim-monokai  
badwolf: https://github.com/sjl/badwolf  
iceberg: https://github.com/cocopon/iceberg.vim  

## Install Vim:
```Bash
sudo apt install vim
```
or
```Bash
sudo apt-get install vim
```

**Note:** typing vi acts as a symbolic link in **Debian** and will open vim if it is installed. This means that to open a file with vim you can simply type 
```Bash
vi file_name
```
instead of
```Bash
vim file_name
```
For this guide vim will be typed out completely to prevent confusion  
## Set Vim as the default text editor:
#### Method 1: From the .bashrc file
Open the .bashrc file located in your home directory
```bash
vim ~/.bashrc 
```
Add the following lines to the end of the file
```bash
export VISUAL=vim
export EDITOR="$VISUAL"
```
**A quick note if you have never used vim before:**  
There are several different modes that vim can be in. When you enter vim it will open the file in "Normal" mode. In order to edit the text as you would expect you will need to enter "Insert" mode which can be done by simply pressing **I** on your keyboard. You should see "insert" pop up on the bottom left when you do so. You can now type the lines above in the file as you would normally. To write changes and exit vim you need to change modes again. First you will need to switch back to "Normal" which can be done by pressing the **Esc** key. Now you can enter "Command" mode by typing **:**. To write changes and quit vim you need to type **wq** following the **:** and then press **enter**. To simply write changes you can enter **w**, to quit if you have not made any changes you can enter **q** and to quit and discard any changes you can enter **q!**  
Keep in mind that if you enter a command, vim will return to "Normal" mode. This means that you will need to re-enter **:** to return to command mode and type in a new command.
   
