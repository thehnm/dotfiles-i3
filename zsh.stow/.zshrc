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

# Modify the colors and symbols in these variables as desired.
#GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"                              # plus/minus     - clean repo
#GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
#GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
#GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"             # A"NUM"         - ahead by "NUM" commits
#GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"           # B"NUM"         - behind by "NUM" commits
#GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"     # lightning bolt - merge conflict
#GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}#%{$reset_color%}"       # red circle     - untracked files
#GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}#%{$reset_color%}"     # yellow circle  - tracked files modified
#GIT_PROMPT_STAGED="%{$fg_bold[green]%}#%{$reset_color%}"        # green circle   - staged changes present = ready for "git push"
#
#parse_git_branch() {
#  # Show Git branch/tag, or name-rev if on detached head
#  ( git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD ) 2> /dev/null
#}
#
#parse_git_state() {
#  # Show different symbols as appropriate for various Git repository states
#  # Compose this value via multiple conditional appends.
#  local GIT_STATE=""
#  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
#  if [ "$NUM_AHEAD" -gt 0 ]; then
#    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
#  fi
#  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
#  if [ "$NUM_BEHIND" -gt 0 ]; then
#    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
#  fi
#  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
#  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
#    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
#  fi
#  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
#    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
#  fi
#  if ! git diff --quiet 2> /dev/null; then
#    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
#  fi
#  if ! git diff --cached --quiet 2> /dev/null; then
#    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
#  fi
#  if [[ -n $GIT_STATE ]]; then
#    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
#  fi
#}
#
#git_prompt_string() {
#  local git_where="$(parse_git_branch)"
#
#  # If inside a Git repository, print its branch and state
#  [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
#
#  # If not inside the Git repo, print exit codes of last command (only if it failed)
#  [ ! -n "$git_where" ] && echo "%{$fg[red]%} %(?..[%?])"
#}

# Right prompt with exit status of previous command if not successful
RPROMPT="%{$fg[red]%} %(?..[%?])"
# Right prompt with exit status of previous command marked with ✓ or ✗
#RPROMPT="%(?.%{$fg[green]%}✓ %{$reset_color%}.%{$fg[red]%}✗ %{$reset_color%})"
#RPROMPT='$(git_prompt_string)'

. ~/.shell/zsh/interactive
