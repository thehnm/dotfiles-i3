export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

#export LS_COLORS='di=1;34:fi=0:ln=4;33:pi=5:so=5:bd=5:cd=5:or=4;47;30:mi=1;30;47:ex=1;31'

PATH=$PATH:$HOME/.local/bin/; export PATH
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_CACHE_HOME="$HOME"/.cache
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export HISTFILE="$XDG_DATA_HOME"/zsh/history
export LESSHISTFILE=/dev/null
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME"/notmuch/notmuchrc
export NMBGIT="$XDG_DATA_HOME"/notmuch/nmbug
export STACK_ROOT="$XDG_DATA_HOME"/stack
export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR="nvim"
export BROWSER="brave"
export TERMINAL="st"
export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export GOPATH="$XDG_DATA_HOME"/go
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/password-store

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
