#!/bin/sh

mkdir -p ~/.config/dunst
mkdir -p ~/.config/mpd
mkdir -p ~/.config/mpd/playlists
mkdir -p ~/.config/ncmpcpp
mkdir -p ~/.config/nvim
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/fonts
mkdir -p ~/pic
mkdir -p ~/dl

stow -R config.stow
stow -R shell.stow
stow -R sh.stow
stow -R zsh.stow

if [ -n "$(ls /usr/bin/openbox)" ]; then
    stow -R openbox.stow
else
    stow -R dwm.stow
fi
