# { --- Option section ---
source <(antibody init)
antibody bundle < $HOME/.config/antibody/zsh_plugins.txt

autoload -U colors && colors
autoload -Uz compinit

if [ -f $HOME/.zcompdump ]; then
	compinit;
else
	compinit -C;
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

HISTFILE=~/.zhistory
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

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

# Customize ls colors
export LS_COLORS='di=1;34:fi=0:ln=4;33:pi=5:so=5:bd=5:cd=5:or=4;47;30:mi=1;30;47:ex=1;31'

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

. ~/.shell/zsh/interactive
