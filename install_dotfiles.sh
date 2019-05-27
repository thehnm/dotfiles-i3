#!/bin/bash

mkdir -p $HOME/.config/i3
mkdir -p $HOME/.config/dunst
mkdir -p $HOME/.config/mpd
mkdir -p $HOME/.config/mpd/playlists
mkdir -p $HOME/.config/ncmpcpp
mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.config/newsboat
mkdir -p $HOME/.config/termite
mkdir -p $HOME/.config/gtk-3.0
mkdir -p $HOME/.config/calcurse
mkdir -p $HOME/pic
mkdir -p $HOME/dl

stow -R *.stow
