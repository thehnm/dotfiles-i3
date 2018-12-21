#!/bin/bash

mkdir -p $HOME/.config/dunst
mkdir -p $HOME/.config/mpd
mkdir -p $HOME/.config/mpd/playlists
mkdir -p $HOME/.config/gtk-3.0
mkdir -p $HOME/.config/i3
mkdir -p $HOME/.config/polybar
mkdir -p $HOME/.config/termite
mkdir -p $HOME/.themes
mkdir -p $HOME/.icons
mkdir -p $HOME/.local/share/fonts
mkdir -p $HOME/Pictures

stow -R config.stow
stow -R fonts.stow
stow -R wallpaper.stow
stow -R gtk-themes.stow
