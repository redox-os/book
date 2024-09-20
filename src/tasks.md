# Tasks

This page covers the commands used for common and specific tasks on Redox.

- [Hardware](#hardware)
- [System](#system)
- [Networking](#networking)
- [User](#user)
- [Files and Folders](#files-and-folders)
- [Media](#media)
- [Graphics](#graphics)

## Hardware

### Show CPU information

```sh
cat /scheme/sys/cpu
```

## System

### Show system information

```sh
uname -a
```

### Show memory (RAM) usage

```sh
free -h
```

### Show the storage usage

```sh
df -h
```

### Shutdown the computer

```sh
sudo shutdown
```

### Show all running processes

```sh
ps
```

### Show system-wide common programs

```sh
ls /bin
```

### Show all schemes

```sh
ls /scheme
```

### Show the system log

```sh
cat /scheme/sys/log
```

Or

```sh
dmesg
```

## Networking

#### Show system DNS name

```sh
hostname
```

#### Show all network addresses of your system

```sh
hostname -I
```

### Ping a website or IP

```sh
ping (website-link/ip-address)
```

### Show website information

```sh
whois https://website-name.com
```

### Download a GitHub repository on the current directory

```sh
git clone https://github.com/user-name/repository-name.git
```

### Download a Git repository

```sh
git clone https://website-name.com/repository-name
```

### Download a Git repository to the specified directory

```sh
git clone https://website-name.com/repository-name folder-name
```

### Download a file with wget

```sh
wget https://website-name.com/file-name
```

### Resume an incomplete download

```sh
wget -c https://website-name.com/file-name
```

### Download from multiple links in a text file

```sh
wget -i file.txt
```

### Download an entire website and convert it to work locally (offline)

```sh
wget --recursive --page-requisites --html-extension --convert-links --no-parent https://website-name.com
```

### Download a file with curl

```sh
curl -O https://website-name.com
```

### Download files from multiple websites at once

```sh
curl -O https://website-name.com/file-name -O https://website2-name.com/file-name
```

### Host a website with [Simple HTTP Server](https://github.com/TheWaWaR/simple-http-server)

- Point the program to the website folder
- The Home page of the website should be available on the root of the folder
- The Home page should be named as `index.html`

```sh
simple-http-server -i -p 80 folder-name
```

This command will use the port 80 (the certified port for HTTP servers), you can change as you wish.

## User

### Clean the terminal content

```sh
clear
```

### Exit the terminal session, current shell or root privileges

```sh
exit
```

### Current user on the shell

```sh
whoami
```

### Show the default terminal shell

```sh
echo $SHELL
```

### Show your current terminal shell

```sh
echo $0
```

### Show your installed terminal shells (active on $PATH)

```sh
cat /etc/shells
```

### Change your default terminal shell permanently (common path is `/usr/bin`)

```sh
chsh -s /path/of/your/shell
```

### Add an abbreviation for a command on the Ion shell

```sh
alias name='command'
```

### Change the user password

```sh
passwd user-name
```

### Show the commands history

```sh
history
```

### Show the commands with the name specified in history

```sh
history name
```

### Change the ownership of a file, folder, device and mounted-partition (recursively)

```sh
sudo chown -R user-name:group-name directory-name
```

Or

```sh
chown user-name file-name
```

### Show system-wide configuration files

```sh
ls /etc
```

### Show the user configuration files of programs

```sh
ls ~/.local/share ~/.config
```

### Print a text on terminal

```sh
echo text
```

### Show the directories in the $PATH environment variable

```sh
echo $PATH
```

### Show the dependencies (shared libraries) used by a program

```sh
ldd program-name
```

### Add a new directory on the $PATH environment variable of the Ion shell

```sh
TODO
```

### Restore the shell variables to default values

```sh
reset
```

### Measure the time spent by a program to run a command

```sh
time command
```

### Run a executable file on the current directory

```sh
./
```

### Run a non-executable shell script

```sh
sh script-name
```

Or

```sh
bash script-name
```

## Files and Folders

### Show files and folders in the current directory

```sh
ls
```

### Print some text file

```sh
cat file-name
```

### Edit a text file

```sh
kibi file-name
```

Save your changes by pressing Ctrl+S

### Show the current directory

```sh
pwd
```

### Change the active directory to the specified folder

```sh
cd folder-name
```

### Change to the previous directory

```sh
cd -
```

### Change to the upper directory

```sh
cd ..
```

### Change the current directory to the user folder

```sh
cd ~
```

### Show files and folders (including the hidden ones)

```sh
ls -A
```

### Show the files, folders and subfolders

```sh
ls *
```

### Show advanced information about the files/folders of the directory

```sh
ls -l
```

### Create a new folder

```sh
mkdir folder-name
```

### Copy a file

```sh
cp -v file-name destination-folder
```

### Copy a folder

```sh
cp -v folder-name destination-folder
```

### Move a folder
```sh
mv folder-name destination-folder
```

### Remove a file

```sh
rm file-name
```

### Remove a folder

(Use with caution if you called the command with `su`, `sudo` or `doas`)

```sh
rm -rf folder-name
```

### Add text in a text file

```sh
echo "text" >> directory/file
```

### Search for files

```sh
find . -type f -name file-name
```

(Run with `sudo` or `su` if these directories are under root permissions)

### Search for folders

```sh
find . -type d -name folder-name
```

(Run with `sudo` or `su` if the directories are under root permissions)

### Show files/folders in a tree

```sh
tree
```

## Media

### Play a video

```sh
ffplay video-name
```

### Play a music

```sh
ffplay music-name
```

### Show an image

```sh
image-viewer image-name
```

## Graphics

### Show the OpenGL driver information

```sh
glxinfo | grep OpenGL
```

<!--

### 

```sh

```

-->
