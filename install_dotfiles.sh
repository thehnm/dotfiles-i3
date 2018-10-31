#!/bin/bash
confarray=(conky dunst gtk-3.0 i3 polybar termite)
for item in ${confarray[*]}
do
  if [ -d "$HOME/.config/$item" ]; then
    echo $HOME/.config/$item exists.
  else
    mkdir -p $HOME/.config/$item
  fi
done

mkdir -p $HOME/.themes
mkdir -p $HOME/.icons

stow -R config.stow
stow -R fonts.stow
stow -R wallpaper.stow
stow -R gtk-themes.stow
