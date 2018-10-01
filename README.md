My personal installation instructions for my i3 setup.

### Install needed packages
```
sudo pacman -S i3 rofi dunst ranger manjaro-zsh-config i3lock compton xorg-xbacklight playerctl pass rxvt-unicode powerline-fonts ctags texlive-most
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
git clone git@github.com:TheHNM/dotfiles-i3.git
```

### Stow
```
stow ~/dotfiles-i3/config.stow
stow ~/dotfiles-i3/wallpaper.stow
```

### Install plugins
```
vim +PluginInstall +qall
```

### Set Xresources
```
xrdb ~/.Xresources
```
