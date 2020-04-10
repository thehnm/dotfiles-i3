#!/bin/sh

mkdir -p ~/.config/dunst
mkdir -p ~/.config/mpd
mkdir -p ~/.config/mpd/playlists
mkdir -p ~/.config/ncmpcpp
mkdir -p ~/.config/nvim
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/fonts
mkdir -p ~/pics
mkdir -p ~/dl
mkdir -p ~/.mozilla/firefox/user.default-release

stow -R config.stow
stow -R shell.stow
stow -R sh.stow
stow -R zsh.stow
stow -R firefox.stow

if [ -f /usr/bin/openbox ]; then
    stow -R openbox.stow
else
    stow -R dwm.stow
fi
