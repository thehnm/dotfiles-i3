## My personal installation instructions for my i3 setup.

### Install needed packages
```
sudo pacman -S i3 rofi dunst ranger manjaro-zsh-config libgnome-keyring compton xorg-xbacklight pass playerctl ttf-dejavu ctags texlive-most nitrogen stow vim lxappearance w3m mupdf polybar
yaourt -S i3lock-color libmpdclient cmake
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
