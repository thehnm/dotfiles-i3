# thehnm's Arch Linux rice installation script

![base](docs/base.png)

![neofetch](docs/neofetch.png)

I created this script to replicate my current Arch Linux setup every time I move to another machine or when I have to reinstall my system. To avoid repeating the same tedious steps when
installing Arch Linux I wrote this script that takes over most of the installation.

The majority of this script was written by [Luke Smith](https://github.com/LukeSmithxyz) in his Arch Linux installation script [LARBS](https://github.com/LukeSmithxyz/LARBS). All the
credits go to him. I only added some features not present in LARBS like hostname configuration or locale configuration.

## Installation
### Prerequisites
The following steps are meant for a system where Arch Linux is about to get installed and no other steps where taken.

#### First, you have to partition your system
Obviously, this is the first step to do before installing anything.
I recommend this partition scheme:

| Mount Point | Partition     | File System   | Size |
| ------------|:-------------:| -------------:| -------:
| /boot       | /dev/sda1     | ext4          | 200-300 MB
| [swap]      | /dev/sda2     | swap          | 1.5 x the amount of RAM you have
| /           | /dev/sda3     | ext4          | the rest

If youre systems runs on UEFI then this small change is necessary:

| Mount Point | Partition     | File System   | Size |
| ------------|:-------------:| -------------:| -------:
| /boot/efi   | /dev/sda1     | FAT32         | 200-300 MB
| [swap]      | /dev/sda2     | swap          | 1.5 x the amount of RAM you have
| /           | /dev/sda3     | ext4          | the rest

Some people recommend having a separate /home partition that stores all your user specific configurations. I never had the need for one but you always can create a separate /home partition without changing much of the installation process.

#### Install the base Arch Linux system
Before you can do that you have to mount the boot and root partitions, like here:
```
mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
```

Then you can issue this command to install the base Arch Linux system:
```
pacstrap /mnt base base-devel vim
```

This also installs an editor called vim. You can omit the last package or replace it with anything else.

#### Generate fstab file
Issue this command to create a fstab file. This file indicates the partitions that will be automatically mounted on startup.
```
genfstab -U /mnt >> /mnt/etc/fstab
```

#### Install my dotfile
When the base system is installed then you can change into your installation:
```
arch-chroot /mnt
```

Then download my installation script with this command:
```
curl https://raw.githubusercontent.com/thehnm/dotfiles-i3/master/arch_bootstrap/install.sh >> install.sh
```

**Attention** Currently, the locale.conf file will be set with english and german locales. To customize your locales you have to edit my script. Then go to line 268 and
change the parameter to your likings. In the future this process will hopefully be obsolete.

Make it executable and run it.
```
chmod ugo+x install.sh
./install.sh
```

That's it. This script installs my i3 setup that I currently use on my systems and handles other settings you otherwise would have to do.

More screenshots from my setup:
![termite](docs/termite.png)
![termite](docs/termiteandfirefox.png)

## TODO
* Support more Window Managers / Desktop Environments
