My personal installation instructions for my i3 setup.

### Install needed packages
```
sudo pacman -S i3 rofi dunst ranger manjaro-zsh-config i3lock compton xorg-xbacklight
```

### Download repo
```
git clone git@github.com:TheHNM/dotfiles-i3.git
```

### Stow
```
cd dotfiles-i3
stow config.stow
```
