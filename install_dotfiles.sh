#!/bin/bash

mkdir -p $HOME/.config/i3
mkdir -p $HOME/.config/polybar

stow -R config.stow
