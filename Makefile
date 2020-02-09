bash:
	stow -R bash.stow

zsh:
	stow -R zsh.stow

sh:
	stow -R sh.stow

config:
	mkdir -p ~/.config/dunst
	mkdir -p ~/.config/mpd
	mkdir -p ~/.config/mpd/playlists
	mkdir -p ~/.config/ncmpcpp
	mkdir -p ~/.config/nvim
	mkdir -p ~/.local/bin
	mkdir -p ~/.local/share/fonts
	mkdir -p ~/pic
	mkdir -p ~/dl
	stow -R config.stow

uninstall:
	stow -D *.stow

install: config zsh sh
