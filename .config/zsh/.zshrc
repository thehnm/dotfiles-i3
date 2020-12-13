# { --- Option section ---
source <(antibody init)
antibody bundle < $HOME/.config/antibody/zsh_plugins.txt

autoload -U colors && colors
autoload -Uz compinit

if [ -f $HOME/.cache/zcompdump ]; then
	compinit -d $HOME/.cache/zcompdump;
else
	compinit -C -d $HOME/.cache/zcompdump;
fi

setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.
setopt prompt_subst                                             # enable substitution for prompt

HISTFILE=~/.local/share/zsh/history
HISTSIZE=1000
SAVEHIST=500
WORDCHARS=${WORDCHARS//\/[&.;]}                                 # Don't consider certain characters part of the word

# Change cursor
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

_fix_cursor() {
   echo -ne '\e[5 q'
}

precmd_functions+=(_fix_cursor)

# 0 -- vanilla completion (abc => abc)
# 1 -- smart case completion (abc => Abc)
# 2 -- word flex completion (abc => A-big-Car)
# 3 -- full flex completion (abc => ABraCadabra)
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

## Prompt (on left side) similar to default bash prompt, or redhat zsh prompt with colors
##PROMPT="%(!.%{$fg[red]%}[%n@%m %1~]%{$reset_color%}# .%{$fg[green]%}[%n@%m %1~]%{$reset_color%}$ "

## Maia prompt
##PROMPT="%B%{$fg[cyan]%}%(4~|%-1~/.../%2~|%~)%u%b >%{$fg[cyan]%}> %B%(?.%{$fg[cyan]%}.%{$fg[red]%})> %{$reset_color%}%b "

## Simple prompt
##PROMPT="[%n@%m %3~]$ "

## Simple prompt with indicator for last return code
##PROMPT="[%n@%m %3~]%(?.%{$reset_color%}.%{$fg[red]%})$%{$reset_color%} "

## Prompt with easy zsh sequences
## PROMPT="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[cyan]%}%m %{$fg[magenta]%}%3~%{$fg[red]%}]%(?.%{$fg[white]%}.%{$fg[blue]%})$%b "

PROMPT="%B%(?.%{$fg[white]%}.%{$fg[red]%})>%b %B%3~%b "

## Prompt on right side:
#  - shows status of git when in git repository (code adapted from https://techanic.net/2012/12/30/my_git_prompt_for_zsh.html)
#  - shows exit status of previous command (if previous command finished with an error)
#  - is invisible, if neither is the case

RPROMPT="%{$fg[red]%} %(?..[%?])"

alias cp="cp -iv"                                               # Confirm before overwriting something
alias df='df -h'                                                # Human-readable sizes
alias free='free -m'                                            # Show sizes in MB
alias l='ls -la --color=tty'
alias ls='ls --color=tty'

alias config='cd $XDG_CONFIG_HOME'
alias data='cd $XDG_DATA_HOME'

alias ga='git add'
alias gcmsg='git commit -m'
alias gpu='git push'
alias gsb='git status -b'
alias glog='git log'
alias gdiff='git diff'

alias ln='ln -v'
alias chmod='chmod -c'
alias chown='chown -c'
alias mkdir='mkdir -v'
alias mv='mv -iv'
alias rm='rm -v'
alias cp='cp -iv'
alias rsync='rsync -avP'
alias um='udiskie-umount -a'
alias shut='shutdown -h now'
alias yay='yay --color=auto'
alias pacman='pacman --color=auto'
alias fucking='sudo'
alias motherfucking='sudo'
alias fcking='sudo'
alias f='ranger'
alias e='nvim'
alias gettodos='grep TODO -nr * > TODOs.txt'
alias calcurse='calcurse -D $HOME/.config/calcurse'
alias music='ncmpcpp'
alias ydm='youtube-dl -x -f bestaudio --audio-format vorbis'
alias termite='termite -t termite'
alias evpc='expressvpn connect'
alias evpd='expressvpn disconnect'
alias evps='expressvpn status'
