export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

export LS_COLORS='di=1;34:fi=0:ln=4;33:pi=5:so=5:bd=5:cd=5:or=4;47;30:mi=1;30;47:ex=1;31'

PATH=$PATH:$HOME/.local/bin/; export PATH
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share
export STACK_ROOT="$XDG_DATA_HOME"/stack
export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR="nvim"
export BROWSER="firefox"
export TERMINAL="st"
export _JAVA_AWT_WM_NONREPARENTING=1
export GOPATH="$XDG_DATA_HOME"/go

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
