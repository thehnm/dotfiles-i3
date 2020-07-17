# thehnm's dotfiles

This dotfile repository contains configuration files for my [dwm](https://github.com/thehnm/dwm) setup on [Arch Linux](https://www.archlinux.org/).
Furthermore, my Arch Linux installation script [tarbs](https://github.com/thehnm/tarbs) also installs my configurations found here.
Just download and run it with:

```
curl -LO https://raw.githubusercontent.com/thehnm/tarbs/master/install.sh
bash install.sh
```

## Required Sofware

You can find the software with my own changes, configurations and patches here:

- [dwm](https://github.com/thehnm/dwm)
- [dmenu](https://github.com/thehnm/dmenu)
- [st](https://github.com/thehnm/st)
- [slock](https://github.com/thehnm/slock)

## Configuration

This repository contains configuration files for the following software:

- **zsh**
- **zsh Plugins**, managed by [antibody](https://github.com/getantibody/antibody)
    - [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
    - [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
    - [zsh-completions](https://github.com/zsh-users/zsh-completions)
    - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- **dunst** notification daemon
- **fontconfig**
    - Serif: Linux Libertine
    - Sans-Serif: Linux Biolinum
    - Sans: Linux Biolinum
    - Monospace: Fira Mono
    - Non-Latin: Noto CJK fonts
- **mpd** Music Player daemon
- **ncmpcpp** mpd client
- **sxhkd**
    - `Alt + Return` Open Terminal
    - `Alt + p` Open dmenu program launcher
    - `Alt + d` Open passmenu
    - `Alt + Shift + d` Clear clipboard
    - `Alt + Shift + q` Open exit wizard
    - `Alt + x` Lock screen with **slock**
    - `Print` Take screenshot
    - `Super + Shift + l` Toggle playerctl
    - `Super + Shift + j` playerctl next song
    - `Super + Shift + k` playerctl previous song
    - `Alt + Shift + l` Toggle mpc
    - `Alt + Shift + j` mpc next song
    - `Alt + Shift + k` mpc previous song
    - `Alt + o; b` Open default browser
    - `Alt + o; m` Open neomutt terminal email client
    - `Alt + o; v` Open virt-manager frontend
    - `Alt + o; n` Open ncmpcpp mpd client
    - `Alt + o; r` Open newsboat RSS reader
    - `Alt + s` Display song status for playerctl and mpd
- **youtube-dl** CLI youtube video downloader
- **zathura** PDF reader
