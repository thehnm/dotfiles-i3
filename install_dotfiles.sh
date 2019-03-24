#!/bin/bash

mkdir -p $HOME/.config/dunst
mkdir -p $HOME/.config/mpd
mkdir -p $HOME/.config/mpd/playlists
mkdir -p $HOME/.config/gtk-3.0
mkdir -p $HOME/.config/ncmpcpp
mkdir -p $HOME/.config/termite
mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.themes
mkdir -p $HOME/.icons
mkdir -p $HOME/.local/share/fonts
mkdir -p $HOME/Pictures

stow -R config.stow
stow -R fonts.stow
stow -R wallpaper.stow
stow -R gtk-themes.stow
