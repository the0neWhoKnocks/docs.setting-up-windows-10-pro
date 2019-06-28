# Windows Subsystem Linux (WSL)

Table of Contents:

- 

---

## Downloading and Installing

Utilizing `lxrunoffline` and PowerShell
- Open PowerShell
  - To allow https requests enter
  ```ps
  [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
  ```
  - Download the Ubuntu/bionic img with
  ```ps
  wget -O "D:\VMs\_imgs\ubuntu-bionic-$(Get-Date -format "FileDateTime").tar.gz" "https://lxrunoffline.apphb.com/download/Ubuntu/bionic"
  ```
    - The `lxrunoffline.apphb.com` download path comes from
    https://github.com/DDoSolitary/LxRunOffline/wiki.
    - I got the `codeName` from https://wiki.ubuntu.com/Releases, and the actual
    shortened name `bionic` from this repo https://github.com/tianon/docker-brew-ubuntu-core.
  - Install with
  ```ps
  lxrunoffline i -n "Ubuntu-bionic" -d "D:\VMs\Ubuntu\bionic" -f "D:\VMs\_imgs\ubuntu-bionic-<DATE>.tar.gz"
  ```
    - Note that `<DATE>` should be replaced with the value from the actual download.
  - List installed imgs `lxrunoffline l`
  - Create a shortcut `lxrunoffline s -n "Ubuntu-bionic" -f "D:\VMs\Ubuntu-bionic.lnk" -i "D:\VMs\_icos\ubuntu_multi.ico"`
    - I've included some [ico files here](./assets/ico).
- Double-click the new shortcut to go into the VM

---

## Configure VM

### Install binaries

```sh
# Update the machine
apt update && apt upgrade

# General tools
apt install curl git psmisc vim zsh

# For Node / Yarn
apt install curl git gnupg1 make

# To patch system for proper character interpretations for shell theme. May be
# optional depending on the VM.
apt install locales

# Docker deps
apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
```

### Set up locale

This may not be required for all distros, but I found I needed it for my ZSH
theme, otherwise I'd get `character not in range` errors when icon's were
trying to be set.

```sh
dpkg-reconfigure locales
# 158 is the value for en_US.UTF-8

# once done
locale # should print out everything without any errors at the top
```

### Disable bell sound
- For the Bash
```sh
vi ~/.inputrc
set bell-style none
```
- For vi
```sh
vi ~/.vimrc
set visualbell
set t_vb= 
```
- For ZSH
```sh
vi ~/.zshrc
unsetopt BEEP
```

### Disable Inserting Windows 'PATH's Into the Shell's 'PATH'.

A good explanation of what's going on can be
[found here](https://stackoverflow.com/a/51345880). The simplest fix is to use
`lxrunoffline` to set the registry value to `5`.

- In Powershell
```ps
lxrunoffline sf -n Ubuntu-bionic -v 5
```
- In the VM you should be able to run `echo $PWD` and not see all the extra
Windows binary paths listed. If you want to revert the change, just change `5`
back to `7`.

### Disable Windows Mounts Being Prefixed With '/mnt'.

- In the VM `vi /etc/wsl.conf`, add
```sh
[automount]
enabled = true
root = /
```
- Exit and re-open the VM, run `mount -l`, and you should see something like
```sh
C: on /c type drvfs
```

---

## Customize Terminal

- Install Oh-My-Zsh `sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
  - Install auto-suggestions `git clone https://github.com/zsh-users/zsh-autosuggestions ~/zsh/zsh-autosuggestions`
  - Install my theme `git clone --single-branch -b wsl https://github.com/the0neWhoKnocks/zsh-theme-boom.git ${ZSH_CUSTOM}/themes/zsh-theme-boom`
    - Install [the fonts](./assets/fonts) in Windows.
- Install [wsl-terminal](https://github.com/goreliu/wsl-terminal/releases/download/v0.8.11/wsl-terminal-tabbed-0.8.11.zip).
  - You can just dump the contents of the `zip` into whatever folder you'd like.
    - Note that wsl-terminal just opens the current Default distro.
  - The **add "open here"** context menu scripts didn't work for me because they
    were pointing to the wrong path, so I created a
    [reg file](./assets/ContextMenu_Open_WSL_Here__add.reg) and used that instead.
    - Note that if you move that folder later, you'll have to update the paths
    in the reg file, and re-run it.
  - If the terminal won't start, it's due to the `/mnt` path change from above.
    - While dealing with `docker-compose` issues I came across [this post](https://github.com/Maximus5/ConEmu/issues/1538#issuecomment-386838630)
    which pointed to [these binaries](./assets/wslbridge-wslpath-patched-files.7z).
      - I just made a back up of the files within
      `D:\Programs\wsl-terminal-tabbed\bin`, and then added the new binaries.

---

## Install N (Node Version Manager)

- Repo - https://github.com/tj/n
- Install
  - `curl -L https://git.io/n-install | bash`
  
---

## Install Yarn

Go to https://yarnpkg.com/en/docs/install#debian-stable for newest instructions.

**NOTE** - If `cmdtest` is installed, you'll want to uninstall it with
`apt remove cmdtest`.

I ended up running:
```sh
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt update && apt install --no-install-recommends yarn
yarn --version
```

---

## Copying Over SSH from Cygwin

- I already had a bunch of SSH keys set up so I just copied them from
  `<PROGRAMS>\cygwin\home\<USER>\.ssh` to `<PATH_TO_VM>\rootfs\home\<USER>\.ssh`.
- Then I had to change permissions on the directory and the contents.
  ```sh
  chmod -R 600 ~/.ssh && chmod +x ~/.ssh
  ```
- A restart of the shell may be required.

---

## How to back up a user folder

- Create `backup-user.sh` within your user's home directory
```sh
mkdir ~/bin
touch ~/bin/backup-user.sh
```
- Open the file `vi ~/bin/backup-user.sh`, and add this to it
```bash
#!/bin/bash

# Create a log of all installed packages
dpkg-query -f '${binary:Package}\n' -W > ./installed-packages.log

# Back up the user's home folder which includes things like:
# - terminal settings
# - color settings
# - npm & yarn caches
OUTPUT_DIR="/d/Backups/VMs/Users"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
tar -cvpzf "$OUTPUT_DIR/ubuntu_home_$(whoami)_$TIMESTAMP.tar.gz" \
 --exclude="./nohup.out" \
 ./ \
 2> "$OUTPUT_DIR/error.log"
```
- Make it executable `chmod +x ~/bin/backup-user.sh`
- Back it up `~/bin/backup-user.sh`

You can then go to whatever system you'd like and bring in the data from that backup.
- Create a temp directory so you can pick and choose what you'd like to bring over.
```sh
mkdir ~/temp
```
- Untar the data to the temp directory
```sh
tar -C ~/temp -zxvf /d/Backups/VMs/Users/ubuntu_home_root_2019-06-23_09-18-29.tar.gz
```
- The data will most likely be under a different uid so you'll have to switch
all that over.
```sh
chown -vR root:root ~/temp
```
---

## How to back up the entire VM

Once everything is set up the way you want it, lets back it up so it can be
easily recreated or used on another machine.

In the VM you can run this code to generate a name.
```sh
. /etc/os-release
OS=$NAME
VER=$VERSION_ID
CODENAME=$VERSION_CODENAME

echo "\nName: ${OS}-${VER}-${CODENAME}"
```

I've included [this script](./assets/backup-vm.ps1) to automate the heavy
lifting of the backup, you just have to update `-n` and `-f` flag values to
whatever you'd like. The script will:
- Kill the WSL terminal if it's running, since it'll keep some processes open.
- Create a backup with an appended timestamp.

Now, like you did above, we can create a new VM but from the backup
```ps
# create the new vm
lxrunoffline i -n "Ubuntu-bionic2" -d "D:\VMs\Ubuntu\bionic2" -f "D:\Backups\VMs\Systems\Ubuntu-18.04-bionic_20190624203808.tar.gz" -s
# list all vms
lxrunoffline l
# switch to the new vm
lxrunoffline sd -n Ubuntu-bionic2
```
- You can now re-open WSL, make a noticeable change like switch the ZSH theme.
- Switch back and forth between VMs by closing WSL and running the below commands.
Opening and closing WSL between `lxrunoffline sd` commands to see different ZSH 
themes being displayed.
```ps
lxrunoffline sd -n Ubuntu-bionic
# or
lxrunoffline sd -n Ubuntu-bionic2
```
- To delete a VM just run
```ps
lxrunoffline ui -n Ubuntu-bionic2
```

---

## NOTES

- Depending on your distro, you may have to use `apt-get` instead of `apt`, but
  `apt-get` seems to be the standard now.
- If you need to switch to `root`, just run `sudo su`.
- Some distros only have the `root` user, so `sudo` will be unnecessary.
- The `/mnt/c/Windows` path seems to be locked down, even if you're `root`, so
  anything that needs to happen there, you'll have to handle in Windows.
- You can manually download distros to have them for later https://docs.microsoft.com/en-us/windows/wsl/install-manual
  - Once downloaded, you'll have an `.appx` archive, you can extract it's
  contents like a zip file.
