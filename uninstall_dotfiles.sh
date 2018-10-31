#!/bin/bash
stow -D config.stow
stow -D fonts.stow
stow -D wallpaper.stow

confarray=(conky dunst gtk-3.0 i3 polybar termite)
for item in ${confarray[*]}
do
  if [ "$(ls -A $HOME/.config/$item)" ]; then
    echo $HOME/.config/$item is not empty.
  else
    rm -r $HOME/.config/$item
  fi
done

if [ "$(ls -A $HOME/.themes)" ]; then
    echo $HOME/.themes is not empty.
else
    rm -r $HOME/.themes
fi

if [ "$(ls -A $HOME/.icons)" ]; then
    echo $HOME/.themes is not empty.
else
    rm -r $HOME/.icons
fi
