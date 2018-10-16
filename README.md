## My personal installation instructions for my i3 setup.

### Install needed packages
```
sudo pacman -S i3 rofi dunst ranger manjaro-zsh-config libgnome-keyring compton xorg-xbacklight pass playerctl ttf-dejavu ctags texlive-most nitrogen stow vim lxappearance w3m mupdf polybar
yaourt -S i3lock-color
```

### Enable Bitmap fonts
```
cd /etc/fonts/conf.d/
sudo rm /etc/fonts/conf.d/10* && sudo rm -rf 70-no-bitmaps.conf && sudo ln -s ../conf.avail/70-yes-bitmaps.conf
sudo fc-cache -fv
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
stow ~/dotfiles-i3/config.stow
stow ~/dotfiles-i3/wallpaper.stow
stow ~/dotfiles-i3/fonts.stow
sudo fc-cache ~/.local/share/fonts
```

### Install plugins
```
vim +PluginInstall +qall
```

### Set Xresources
```
xrdb ~/.Xresources
```
