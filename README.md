## My personal installation instructions for my i3 setup.

### Manjaro installation command 
```
sudo pacman -S i3 rofi dunst manjaro-zsh-config libgnome-keyring compton pass playerctl ttf-dejavu ctags texlive-most nitrogen stow vim lxappearance w3m mupdf polybar libmpdclient cmake netctl dialog wpa_actiond yay 
yay -S i3lock-color 
```

### Arch Linux installation command
```
sudo pacman -S i3 rofi dunst libgnome-keyring compton openvpn pass playerctl ttf-dejavu ctags texlive-most nitrogen stow vim lxappearance w3m mupdf libmpdclient cmake netctl dialog wpa_actiond zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting udiskie alsa-utils openssh pulseaudio pavucontrol network-manager-applet
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si
yay -S i3lock-color polybar
```

### Install `vundle`
```
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

### Download repo
```
https://github.com/thehnm/dotfiles-i3.git
https://thehnm@github.com/thehnm/dotfiles-i3.git // for personal use
```

### Install dotfile
```
cd ~/dotfiles-i3/
stow config.stow
stow wallpaper.stow
stow fonts.stow
```

### Install plugins
```
vim +PluginInstall +qall
```

### Set Xresources
```
xrdb ~/.Xresources
```

### Set gnome-keyring as git credential helper
```
cd /usr/share/git/credential/gnome-keyring
sudo make
git config --global credential.helper /usr/share/git/credential/gnome-keyring/git-credential-gnome-keyring
```

### Fix polybar audio control
```
cd /etc/pulse
sudo vim client.conf
```
Comment the line ```autospawn = no```.
