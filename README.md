# My personal installation steps for my i3 configuration

## Manjaro installation command 
```
sudo pacman -S i3 rofi dunst manjaro-zsh-config gnome-keyring compton pass playerctl ttf-dejavu ctags
sudo pacman -S texlive-most nitrogen stow vim lxappearance w3m mupdf polybar libmpdclient cmake netctl
sudo pacman -S dialog wpa_actiond yay
yay -S i3lock-color 
```

## Arch Linux installation command

1. `pacstrap` command
```
pacstrap /mnt base base-devel vim
```

2. Install this after entering `arch-chroot /mnt`
```
pacman -S i3 rofi firefox networkmanager nm-connection-editor lightdm lightdm-gtk-greeter-settings
pacman -S termite network-manager-applet xorg-server xorg-xinit
```

3. Start `i3` whenever you login
```
echo exec i3 >> ~/.xinitrc
```

4. Enable `networkmanager` and `lightdm`
```
systemctl enable NetworkManager
systemctl enable lightdm.service
```

5. Install necessary software for this rice after rebooting
```
sudo pacman -S dunst gnome-keyring compton stow openvpn pass ttf-dejavu ctags nitrogen
sudo pacman -S udiskie alsa-utils openssh pulseaudio pavucontrol otf-ipafont
sudo pacman -S lxappearance mupdf libmpdclient dialog lightdm-webkit2-greeter
```

6. Install `zsh` plugins
```
sudo pacman -S zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting 
```

7. Install `texlive` packages
```
sudo pacman -S texlive-most 
```

8. Install `yay` AUR helper
```
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si
```

9. Install packages from AUR
```
yay -S i3lock-color polybar lightdm-webkit-theme-aether
```

10. Fix `polybar` audio control
```
cd /etc/pulse
sudo vim client.conf
```
Comment the line `autospawn = no`.

## Download repo
```
git clone https://github.com/thehnm/dotfiles-i3.git ~/dotfiles-i3
git clone https://thehnm@github.com/thehnm/dotfiles-i3.git ~/dotfiles-i3 // for personal use
```

## Install dotfile
```
cd ~/dotfiles-i3/
stow config.stow
stow wallpaper.stow
stow fonts.stow
```

## Install `vundle` vim plugin manager
```
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

### Install `vim` plugins
```
vim +PluginInstall +qall
```

## Set Xresources
```
xrdb ~/.Xresources
```

## Set `gnome-keyring` as `git` credential helper
```
cd /usr/share/git/credential/gnome-keyring
sudo make
git config --global credential.helper /usr/share/git/credential/gnome-keyring/git-credential-gnome-keyring
```
