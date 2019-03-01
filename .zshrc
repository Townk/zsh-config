# # --------------------------------------------------------------------
# # Configuration file for Z Shell
# # By: Thiago Alves
# # Last Update: April, 30 2018
# # --------------------------------------------------------------------


# # --------------------------------------------------------------------
# # Contents:
# # --------
# # 1. Define color variables
# # 2. Aliases
# # 3. Custom Shell Functions
# # 4. Environment Options
# # 5. Promp Appearances
# # 6. Command Completion
# # 7. Key Bindings
# # 8. Plugins
# # --------------------------------------------------------------------

# # --------------------------------------------------------------------
# # 1. Define color variables
# # --------------------------------------------------------------------
# Note: options -U and -z do the following:
# -U: prevent any alias from being resolved. This means that if you
#     created an alias called 'ls', during the load of the function
#     if the 'ls' command is used, the alias will not be used.
# -z: make sure you're executing in zsh mode.
autoload -Uz colors zsh/terminfo
if [[ "${terminfo[colors]}" -ge 8 ]]; then
    colors
fi

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE BLACK; do
    eval PR_${color}='%{${terminfo[bold]}${fg[${(L)color}]}%}'
    eval PR_LIGHT_${color}='%{${fg[${(L)color}]}%}'
    (( count = ${count} + 1 ))
done
PR_NO_COLOR="%{${terminfo[sgr0]}%}"


# # --------------------------------------------------------------------
# # 2. Aliases
# # --------------------------------------------------------------------
## file extension association
alias -s html="open"

## global aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g NUL="> /dev/null 2>&1"
alias -g C='| wc -l'

## command aliases
# alias ls='ls -F'
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -Al'
alias rm='rm -i'
alias h='history 1 -1'
alias pgrep='pgrep -lf' # long output, match against full args list
alias ccat='colorize_via_pygmentize'
alias em='emacs -nw'
alias lcat='logcat-color'

## git aliases
alias gst='git status --short'
alias gu='git pull'
alias gp='git push'
alias gd='gitvimdiff'
alias gdf='git diff --name-only'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias grv='git remote -v'
alias gl='git l'

# notification center
alias notify='/Applications/Terminal\ Notifier.app/Contents/MacOS/terminal-notifier'

# access help online
unalias run-help
autoload -Uz run-help
HELPDIR=/usr/local/share/zsh/help

# ssh helper
alias ssh-x='ssh -o CompressionLevel=9 -c arcfour,blowfish-cbc -YC'

# makes easy to initiate iPython
alias py='ipython'

# macOS
alias qlf='qlmanage -p "$@" > /dev/null 2>&1'


# # --------------------------------------------------------------------
# # 3. Custom Shell Functions
# # --------------------------------------------------------------------

## enable setenv() for csh compatibility
function setenv {
    typeset -x "${1}${1:+=}${(@)argv[2,$#]}"
}

function fcd {
    pFinder=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
    [ -n "${pFinder}" ] && cd "${pFinder}"
}

function gcd {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        cd "./"$(git rev-parse --show-cdup)
        return
    else
    fi
}

function ensure_tmux_is_running {
    if [[ -z "${TMUX}" ]]; then
        $HOME/.config/tmux/bin/tat
    fi
}

function gpg_encrypt {
    if [ -e "$@" ]; then
        gpg --encrypt --armor --recipient talk@thiagoalves.com.br "$@" > "$@".gpg
    else
        echo "$@" | gpg --encrypt --armor --recipient talk@thiagoalves.com.br
    fi
}

function gpg_decrypt {
    if [ -e "$@" ]; then
        gpg --decrypt -q "$@"
    else
        echo "$@" | gpg --decrypt -q
    fi
}

# Returns whether the given command is executable or aliased.
function _has {
	return $( whence $1 >/dev/null )
}


# # --------------------------------------------------------------------
# # 4. Environment Options
# # --------------------------------------------------------------------
## turn options on
setopt \
    append_history       \
    hist_ignore_all_dups \
    hist_ignore_space    \
    auto_cd              \
    extended_glob        \
    nomatch              \
    notify               \
    correct              \
    interactive_comments \
    complete_in_word     \
    always_to_end        \
    auto_list            \
    auto_menu

## turn options off
unsetopt \
    beep \
    flowcontrol \
    menucomplete

## history settins
HISTSIZE=100000
# cache directory
if [ ! -d ${ZDOTDIR:-$HOME}/cache ]; then
    mkdir -p ${ZDOTDIR:-$HOME}/cache
fi
HISTFILE=${ZDOTDIR:-$HOME}/cache/history
SAVEHIST=${HISTSIZE}

## Java
export JAVA_HOME=$(/usr/libexec/java_home)

## android home
export ANDROID_HOME="/usr/local/share/android-sdk"
export ANDROID_SDK_ROOT=${ANDROID_HOME}

# user binaries
if [ ! -d ${USER_BIN} ]; then
    mkdir -p ${USER_BIN}
fi

## fix paths
BREW_PATH="`/usr/local/bin/brew --prefix`"
# make user binaries a priority
PATH=${USER_BIN}:${PATH}
# add Homebrew to path
PATH=${PATH}:${BREW_PATH}/share/npm/bin:${BREW_PATH}/opt/sqlite/bin:${BREW_PATH}/sbin
# add Android to path
PATH=${PATH}:${ANDROID_SDK_ROOT}/tools:${ANDROID_SDK_ROOT}/platform-tools
## fix man paths
if [ -z ${MANPATH} ]; then
    MANPATH=${BREW_PATH}/share/man:${MANPATH}
else
    MANPATH=${BREW_PATH}/share/man
fi
export PATH
export MANPATH
unset BREW_PATH

HOMEBREW_CASK_OPTS="--appdir=/Applications"

# search path for zsh functions  (fpath ==> function path)
fpath=(                                  \
        ${ZDOTDIR:-$HOME}/functions      \
        /usr/local/share/zsh-completions \
        ${fpath}                         \
      )

export LESS="-r -F"

## define default path completion
setopt auto_cd
cdpath=(${HOME}/Projects/personal ${HOME}/Depot/Dropbox/Documents/OrgMode ${HOME}/Depot)

## default editor
export EDITOR='vim'
VISUAL=${EDITOR}

## default language for shell
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8

## doxygen home
DOXYGEN_PATH=`brew --prefix`'/bin/doxygen'

## make colors better for dark terminals
export CLICOLOR=1
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"

## make grep use colors
export GREP_OPTIONS='--color'

## make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

## load extra zsh-highlight modules
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

## Homebrew help location
HELPDIR=/usr/local/share/zsh/helpfiles
## Homebrew helper to allow more API access on Github
export HOMEBREW_GITHUB_API_TOKEN=$(gpg_decrypt ${ZDOTDIR:-$HOME}/.secrets/github.api.homebrew)
## Vim access to Github tokens
export VIM_GITHUB_API_TOKEN=$(gpg_decrypt ${ZDOTDIR:-$HOME}/.secrets/github.api.vim)



# # --------------------------------------------------------------------
# # 5. Promp Appearances
# # --------------------------------------------------------------------
autoload -Uz promptinit && promptinit

PROMPT="[${PR_GREEN}%n${PR_NO_COLOR}: ${PR_BLUE}%1c${PR_NO_COLOR}]%(!.#.$) " # main prompt
PROMPT2="${PR_BLACK}%_${PR_NO_COLOR}> " # command continuation prompt
# right side prompt
SPROMPT="Correct ${PR_RED}%R${PR_NO_COLOR} to ${PR_GREEN}%r${PR_NO_COLOR}? (Yes, No, Abort, Edit) " # correction prompt

PURE_CMD_MAX_EXEC_TIME=10
PURE_GIT_UNTRACKED_DIRTY=0
prompt pure


# # --------------------------------------------------------------------
# # 6. Command Completion
# # --------------------------------------------------------------------
zstyle :compinstall filename '/Users/thiagoa/.zshrc'
autoload -Uz compinit
compinit
#
## A nice way of adding colour to auto-completion (according to ZshWiki)
zmodload -i zsh/complist

## Enables cache for auto-completion (according to Portage)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ${ZDOTDIR:-$HOME}/cache

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
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
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
# # 7. Key Bindings (must be one of the last things in the config)
# # --------------------------------------------------------------------
## remove unwanted bindings
## since we're using vi key binding we should turn off any bind that
## uses <Est> as the first key
bindkey -r '^[/'
bindkey -r '^[,'
bindkey -r '^[~'

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

## some extra bindings
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward
bindkey -M viins '^p' history-incremental-search-forward
bindkey -M vicmd '^p' history-incremental-search-forward

# # --------------------------------------------------------------------
# # 8. Plugins
# # --------------------------------------------------------------------

# FZF integration
if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
    source /usr/local/opt/fzf/shell/key-bindings.zsh
    source /usr/local/opt/fzf/shell/completion.zsh
fi

# fzf + ag configuration
if _has fzf && _has ag; then
	export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
	export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
	export FZF_DEFAULT_OPTS='
	--color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
	--color info:108,prompt:109,spinner:108,pointer:168,marker:168
	'
fi

# ZPlug session
# Use this place to add all your "automagically installed" plugins.
export ZPLUG_HOME=/usr/local/opt/zplug
source ${ZPLUG_HOME}/init.zsh

zplug "${ZDOTDIR:-$HOME}",                      from:local,                use:'plugins/*.plugin.*'
if [ -d ${ZDOTDIR:-$HOME}/work ]; then
    zplug "${ZDOTDIR:-$HOME}/work",             from:local,                use:'plugins/*.plugin.*'
fi
zplug "supercrabtree/k"
zplug "zsh-users/zsh-autosuggestions"
zplug "zdharma/fast-syntax-highlighting"
zplug "gmatheu/shell-plugins",                                                      use:'explain-shell/*.zsh'
zplug "plugins/colored-man-pages",              from:oh-my-zsh, as:plugin
zplug "plugins/colorize",                       from:oh-my-zsh, as:plugin
zplug "plugins/command-not-found",              from:oh-my-zsh, as:plugin
zplug "plugins/vi-mode",                        from:oh-my-zsh, as:plugin
zplug "zsh-users/zsh-history-substring-search",                            defer:3
zplug "b4b4r07/enhancd",                                                            use:init.sh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# Plugins configuration

# History Substring Search Configuration
# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "${terminfo[kcuu1]}" history-substring-search-up
bindkey "${terminfo[kcud1]}" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=none,fg=yellow,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=none,fg=red,bold'
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='l'

# we have to bind our key to clear-scree because other plugins might have
# overwriten it
bindkey '\e,' clear-screen
bindkey '\e.' insert-last-word

# complete current sugestion with Ctrl+Space
bindkey '^ ' autosuggest-accept

# End of Plugins

ensure_tmux_is_running
