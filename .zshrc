#!/usr/bin/env zsh
# -*- mode: sh; indent-tabs-mode: nil; tab-width: 4 -*-

# MIT License
#
# Copyright (c) 2016 Thiago Alves
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# # --------------------------------------------------------------------
# # Configuration file for Z Shell
# # By: Thiago Alves
# # Last Update: March, 22 2019
# # --------------------------------------------------------------------


# # --------------------------------------------------------------------
# # Contents:
# # --------
# #  1. Plugins
# #  2. System specific pre-configuration
# #  3. Environment Options
# #  4. Custom Shell Functions
# #  5. Applications
# #  6. Define color variables
# #  7. Promp Appearances
# #  8. Command Completion
# #  9. Aliases
# # 10. Key Bindings
# # 11. System specific post-configuration
# # --------------------------------------------------------------------


# # --------------------------------------------------------------------
# # 1. Autoloads
# # --------------------------------------------------------------------

# Now that FPATH is set correctly, do autoloaded functions.
# Autoload all functions in $FPATH - that is, all files in each component of the
# array $fpath. If there are none, feed the list it prints into /dev/null.
for path_dir in "$fpath[@]"; do
    for f in "$path_dir"/*(N:t); do
        autoload -Uz "$f" >/dev/null 2>&1
    done
done


# # --------------------------------------------------------------------
# # 2. Widgets
# # --------------------------------------------------------------------

# Insert last word wrapper for vicmd
function vi-insert-last-word {
    zle vi-insert
    zle vi-forward-char
    zle insert-last-word
}
zle -N vi-insert-last-word

# Clear screen wrapper for vicmd
function vi-clear-screen {
   zle clear-screen
   zle vi-insert
}
zle -N vi-clear-screen

function explain-this {
    local cmd="${LBUFFER}${RBUFFER}"
    open "http://explainshell.com/explain?cmd=${cmd/ /+}"
}
zle -N explain-this


# # --------------------------------------------------------------------
# # 3. Command Completion
# # --------------------------------------------------------------------
#
## A nice way of adding colour to auto-completion (according to ZshWiki)
zmodload -i zsh/complist

## Enables cache for auto-completion (according to Portage)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ${ZSH_CACHE_DIR}

## Ignore completion functions for commands you don’t have:
zstyle ':completion:*:functions' ignored-patterns '_*'

## Enables fuzzy completion, so Zsh corrects you if you make a typo
zstyle ':completion:*' completer _complete _match _correct
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

## A nice menu for commands that use PID for an argument (e.g. 'kill')
zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always

## Should turn on colours for 'kill'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

## Should make kill completion more verbose
zstyle ':completion:*:*:kill:*' verbose true
zstyle ':completion:*:*:*:*:processes' command "ps -u ${USER} -o pid,user,comm -w -w"

## Show completion title with some color
zstyle ':completion:*' format $'\e[1;30mCompleting %d\e[0m'

## cd will never select the parent directory (e.g.: cd ../<TAB>):
zstyle ':completion:*:cd:*' ignore-parents parent pwd

zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true

zstyle ':completion:*' list-prompt $'\e[1;30mAt %p: Hit TAB for more, or the character to insert %p%s\e[0m'
zstyle ':completion:*' select-prompt $'\e[1;30mScrolling active: current selection at %p%s\e[0m'

zstyle ':completion:*' original true
zstyle ':completion:*' menu select=long
zstyle ':completion:*' verbose true

## case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

autoload -Uz bashcompinit
bashcompinit


# # --------------------------------------------------------------------
# # 4. Aliases
# # --------------------------------------------------------------------

## global aliases
alias -g NUL="> /dev/null 2>&1"
alias -g C='| wc -l'

## basic commands
alias rm='rm -i' # always confirm when deleting a file
alias h='history 1 -1' # full history
alias pgrep='pgrep -lf' # long output, match against full args list
alias em='emacs -nw'
alias grep='grep --color'

## replace ls -> exa
if ! _has_alias ls; then
    alias ls='ls -FGhkO'
    alias la='ls -A'
    alias ll='ls -l'
    alias lla='ls -Al'
fi

## git aliases
alias gst='git status --short'
alias gu='git pull'
alias gp='git push'
alias gd='git vimdiff'
alias gdf='git diff --name-only'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias grv='git remote -v'
alias gl='git l'

# access help online
unalias run-help 2> /dev/null
autoload -Uz run-help

# ssh helper
alias ssh-x='ssh -o CompressionLevel=9 -c arcfour,blowfish-cbc -YC'

# makes easy to initiate iPython
alias py='ipython'

# NeoVim
if _has nvim; then
    alias vim='nvim'
    alias vi='nvim'
elif _has vim; then
    alias vi='vim'
else
    alias vim='vi'
fi


# # --------------------------------------------------------------------
# # 5. Key Bindings (must be one of the last things in the config)
# # --------------------------------------------------------------------

## set bindings to Vi mode
bindkey -v

## source all bindings from plugins
for bindingdir in $bindingspath; do
    if [ -d $bindingdir ]; then
        for bindings in $bindingdir/*.bindings.zsh(#qN); do
            source $bindings
        done
    fi
done

## remove unwanted bindings
bindkey -r '\e,'
bindkey -r '^h'
bindkey -r '^l'
bindkey -r '^j'
bindkey -r '^k'
bindkey -r '^x'

## create a zkbd compatible hash;
## to add other keys to this hash, see: man 5 terminfo
typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

for k in ${(k)key} ; do
    # ${terminfo[]} entries are weird in ncurses application mode...
    [[ ${key[${k}]} == $'\eO'* ]] && key[${k}]=${key[${k}]/O/[}
done
unset k

### setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# we have to bind our key to clear-scree because other plugins might have
# overwriten it
bindkey '\e,' clear-screen
bindkey '\e.' insert-last-word
bindkey -M vicmd '.' vi-insert-last-word
bindkey -M vicmd ',' vi-clear-screen

bindkey '^xv' iterm_split_vertical
bindkey '^x^v' iterm_split_vertical
bindkey '^xs' iterm_split_horizontal
bindkey '^x^s' iterm_split_horizontal
bindkey '^h' iterm_go_split_left
bindkey '^l' iterm_go_split_right
bindkey '^j' iterm_go_split_down
bindkey '^k' iterm_go_split_up
bindkey '^x.' explain-this

bindkey -M vicmd "^V" edit-command-line
