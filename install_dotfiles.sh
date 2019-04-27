#!/bin/bash

mkdir -p $HOME/.config/dunst
mkdir -p $HOME/.config/mpd
mkdir -p $HOME/.config/mpd/playlists
mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.config/newsboat
mkdir -p $HOME/.themes
mkdir -p $HOME/.icons
mkdir -p $HOME/.local/share/fonts
mkdir -p $HOME/Pictures

stow -R config.stow
stow -R fonts.stow
stow -R wallpaper.stow
stow -R gtk-themes.stow
