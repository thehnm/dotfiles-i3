PATH=$PATH:$HOME/.local/bin/; export PATH
export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR="nvim"
export BROWSER="firefox"
export TERMINAL="termite"

exec nm-applet
exec $HOME/.fehbg &
exec sxhkd &
exec udiskie &
exec protonmail-bridge --no-window
exec mpd
exec mpc update
exec eval `ssh-agent`

exec dwm
