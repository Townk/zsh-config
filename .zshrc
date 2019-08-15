# # --------------------------------------------------------------------
# # Configuration file for Z Shell
# # By: Thiago Alves
# # Last Update: March, 22 2019
# # --------------------------------------------------------------------


# # --------------------------------------------------------------------
# # Contents:
# # --------
# # 1. Plugins
# # 2. Environment Options
# # 3. Custom Shell Functions
# # 4. Applications
# # 5. Define color variables
# # 6. Promp Appearances
# # 7. Command Completion
# # 8. Aliases
# # 9. Key Bindings
# # --------------------------------------------------------------------


# # --------------------------------------------------------------------
# # 1. Plugins
# # --------------------------------------------------------------------
# Before anything we should setup, install, and enable all plugins we
# want. After that any configuration we do will overrite the plugin
# defaults.

# iTerm 2 Integration
test -e "${ITERMDIR}/shell_integration.zsh" && source "${ITERMDIR}/shell_integration.zsh"

# ZPlug session
# Use this place to add all your "automagically installed" plugins.
export ZSH_CACHE_DIR=${ZDOTDIR:-$HOME}/cache
if [ ! -d /usr/local/opt/zplug ]; then
    export ZPLUG_HOME=${HOME}/.config/zplug
    if [ ! -d ${ZPLUG_HOME} ]; then
        curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
    fi
else
    export ZPLUG_HOME=/usr/local/opt/zplug
fi
source ${ZPLUG_HOME}/init.zsh

zplug "${ZDOTDIR:-$HOME}",                      from:local,                use:'plugins/*.plugin.*'
if [ -d ${ZDOTDIR:-$HOME}/work ]; then
    zplug "${ZDOTDIR:-$HOME}/work",             from:local,                use:'plugins/*.plugin.*'
fi

zplug "softmoth/zsh-vim-mode"
zplug "zsh-users/zsh-autosuggestions",          defer:2
zplug "zdharma/fast-syntax-highlighting"
zplug "MichaelAquilina/zsh-you-should-use",     defer:2
zplug "gmatheu/shell-plugins",                  use:'explain-shell/*.zsh', defer:2
zplug "b4b4r07/enhancd",                        use:init.sh, defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "plugins/colored-man-pages",              from:oh-my-zsh, as:plugin, defer:2

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# Plugins configuration

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=none,fg=yellow,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=none,fg=red,bold'
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='l'
MODE_CURSOR_VICMD="green block"
MODE_CURSOR_VIINS="#20d08a blinking bar"
MODE_CURSOR_SEARCH="#ff00ff steady underline"
MODE_INDICATOR_VICMD='%K{#fff275} %F{#595429}NORMAL%f %k'
MODE_INDICATOR_REPLACE='%K{#fc766a} %F{#592925}REPLACE%f %k'
MODE_INDICATOR_SEARCH='%K{#90c962} %F{#40592b}SEARCH%f %k'
MODE_INDICATOR_VISUAL='%K{#6699cc} %F{#2d2f37}VISUAL%f %k'
MODE_INDICATOR_VLINE='%K{#5985b2} %F{#2c4259}V-LINE%f %k'


# # --------------------------------------------------------------------
# # 2. Environment Options
# # --------------------------------------------------------------------
## turn options on
setopt \
    always_to_end          \
    append_history         \
    auto_cd                \
    auto_list              \
    auto_menu              \
    complete_in_word       \
    correct                \
    extended_glob          \
    extended_history       \
    hist_expire_dups_first \
    hist_ignore_all_dups   \
    hist_ignore_space      \
    hist_verify            \
    inc_append_history     \
    interactive_comments   \
    nomatch                \
    notify                 \
    prompt_subst           \
    share_history

## turn options off
unsetopt \
    beep \
    flowcontrol \
    menucomplete

## history settins
HISTSIZE=100000
# cache directory
if [ ! -d ${ZSH_CACHE_DIR} ]; then
    mkdir -p ${ZSH_CACHE_DIR}
fi
HISTFILE=${ZSH_CACHE_DIR}/history
SAVEHIST=${HISTSIZE}

# user binaries
if [ ! -d ${USERBINDIR} ]; then
    mkdir -p ${USERBINDIR}
fi


# search path for zsh functions  (fpath ==> function path)
fpath=(                                  \
        ${ZDOTDIR:-$HOME}/functions      \
        /usr/local/share/zsh-completions \
        ${fpath}                         \
      )

export LESS="-r -F"

## define default path completion
setopt auto_cd
cdpath=(${HOME}/Projects)

## default editor
export EDITOR='nvim'
VISUAL=${EDITOR}

## default language for shell
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8

## make colors better for dark terminals
export CLICOLOR=1
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"

## make grep use colors
export GREP_OPTIONS='--color'

## make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

## load extra zsh-highlight modules
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

## Kill the lag on vim mode when pressing <ESC>
export KEYTIMEOUT=1



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

# Split iTerm2 pannel horizontally
function iterm_split_horizontal { osascript >/dev/null 2>&1 <<-eof
  tell application "iTerm2"
    tell current session of current window
      split horizontally with same profile
    end tell
  end tell
eof
}
zle -N iterm_split_horizontal

# Split iTerm2 pannel vertically
function iterm_split_vertical { osascript >/dev/null 2>&1 <<-eof
  tell application "iTerm2"
    tell current session of current window
      split vertically with same profile
    end tell
  end tell
eof
}
zle -N iterm_split_vertical

# Navigate to Split pannel on the left
function iterm_go_split_left {
    osascript -e 'tell application "System Events" to tell process "iTerm2" to click menu item "Select Pane Left" of menu 1 of menu item "Select Split Pane" of menu 1 of menu bar item "Window" of menu bar 1' > /dev/null 2>&1
}
zle -N iterm_go_split_left

# Navigate to Split pannel on the right
function iterm_go_split_right {
    osascript -e 'tell application "System Events" to tell process "iTerm2" to click menu item "Select Pane Right" of menu 1 of menu item "Select Split Pane" of menu 1 of menu bar item "Window" of menu bar 1' > /dev/null 2>&1
}
zle -N iterm_go_split_right

# Navigate to Split pannel up
function iterm_go_split_up {
    osascript -e 'tell application "System Events" to tell process "iTerm2" to click menu item "Select Pane Above" of menu 1 of menu item "Select Split Pane" of menu 1 of menu bar item "Window" of menu bar 1' > /dev/null 2>&1
}
zle -N iterm_go_split_up

# Navigate to Split pannel down
function iterm_go_split_down {
    osascript -e 'tell application "System Events" to tell process "iTerm2" to click menu item "Select Pane Below" of menu 1 of menu item "Select Split Pane" of menu 1 of menu bar item "Window" of menu bar 1' > /dev/null 2>&1
}
zle -N iterm_go_split_down

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

# GIT FZF integration
# -------------------

# A helper function to join multi-line output from fzf
join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

# Search for Git [F]iles
function fzf-gf-widget {
    if is_in_git_repo; then
        LBUFFER+=$(git -c color.status=always status --short |
                   fzf -m \
                       --ansi \
                       --nth 2..,.. \
                       --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
                   cut -c4- |
                   sed 's/.* -> //' |
           join-lines)
    fi
    zle reset-prompt
}
zle -N fzf-gf-widget

# Search for Git [B]ranches
function fzf-gb-widget {
    if is_in_git_repo; then
        LBUFFER+=$(git branch -a --color=always |
                   grep -v '/HEAD\s' |
                   sort |
                   fzf --ansi \
                       --multi \
                       --tac \
                       --preview-window right:70% \
                       --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
                   sed 's/^..//' | cut -d' ' -f1 |
                   sed 's#^remotes/##' |
                   join-lines)
    fi
    zle reset-prompt
}
zle -N fzf-gb-widget

# Search for Git [T]ags
function fzf-gt-widget {
    if is_in_git_repo; then
        LBUFFER+=$(git tag --sort -version:refname |
                   fzf --multi \
                       --preview-window right:70% \
                       --preview 'git show --color=always {} | head -'$LINES |
           join-lines)
    fi
    zle reset-prompt
}
zle -N fzf-gt-widget

# Search for Git [H]ash commits
function fzf-gh-widget {
    if is_in_git_repo; then
        LBUFFER+=$(git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
                   fzf --ansi \
                       --no-sort \
                       --reverse \
                       --multi \
                       --bind 'ctrl-s:toggle-sort' \
                       --header 'Press CTRL-S to toggle sort' \
                       --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
                   grep -o "[a-f0-9]\{7,\}" |
                   join-lines)
    fi
    zle reset-prompt
}
zle -N fzf-gh-widget

# Search Git [R]emotes
function fzf-gr-widget {
    if is_in_git_repo; then
        LBUFFER+=$(git remote -v |
                   awk '{print $1 "\t" $2}' |
                   uniq |
                   fzf --tac \
                       --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
                   cut -d$'\t' -f1 |
                   join-lines)
    fi
    zle reset-prompt
}
zle -N fzf-gr-widget

function explain-this {
    local cmd="${LBUFFER}${RBUFFER}"
    open "http://explainshell.com/explain?cmd=${cmd/ /+}"
}
zle -N explain-this


# # --------------------------------------------------------------------
# # 4. Applications
# # --------------------------------------------------------------------

# Homebrew
## fix paths
if [[ -a /usr/local/bin/brew ]]; then
    BREW_PATH="`/usr/local/bin/brew --prefix`"
    ## make user binaries a priority
    PATH=${USERBINDIR}:${PATH}
    ## add Homebrew to path
    PATH=${PATH}:${BREW_PATH}/share/npm/bin:${BREW_PATH}/opt/sqlite/bin:${BREW_PATH}/sbin
    ## fix man paths
    if [ -z ${MANPATH} ]; then
        MANPATH=${BREW_PATH}/share/man:${MANPATH}
    else
        MANPATH=${BREW_PATH}/share/man
    fi
    export PATH
    export MANPATH
    unset BREW_PATH
    ## Allow apps to be installed on the /Applications directory
    HOMEBREW_CASK_OPTS="--appdir=/Applications"
    ## Homebrew help location
    HELPDIR=/usr/local/share/zsh/helpfiles
    ## Homebrew helper to allow more API access on Github
    export HOMEBREW_GITHUB_API_TOKEN=$(gpg_decrypt ${ZDOTDIR:-$HOME}/.secrets/github.api.homebrew)
fi

# FZF integration
if _has fzf; then
    ## fzf + rg + ag configuration
    if _has rg; then
        export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
    elif _has ag; then
        export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
    fi

    if _has fd; then
        # Use fd (https://github.com/sharkdp/fd) instead of the default find
        # command for listing path candidates.
        # - The first argument to the function ($1) is the base path to start traversal
        # - See the source code (completion.{bash,zsh}) for the details.
        _fzf_compgen_path() {
          fd --hidden --follow --exclude ".git" . "$1"
        }

        # Use fd to generate the list for directory completion
        _fzf_compgen_dir() {
          fd --type d --hidden --follow --exclude ".git" . "$1"
        }
    fi

    PREVIEW_CMD="[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file ||
                 (bat --style=numbers,changes --color=always {} ||
                 highlight -O ansi -l {} ||
                 coderay {} ||
                 rougify {} ||
                 cat {}) 2> /dev/null || head -500"

    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
    # Options to fzf command
    export FZF_DEFAULT_OPTS='
           --filepath-word
           --border
           --height=45%
           --layout=reverse
           --inline-info
           --prompt=" "
           --color gutter:-1
           --preview "[[ $(file --mime {}) =~ binary ]] && file -F \" is\" --mime {} ||
                   (bat --style=numbers,changes --color=always {} ||
                   highlight -O ansi -l {} ||
                   coderay {} ||
                   rougify {} ||
                   cat {}) 2> /dev/null || head -500"
           --preview-window=right:60%:hidden
           --bind "ctrl-space:toggle-preview"
           '

    if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
        source /usr/local/opt/fzf/shell/key-bindings.zsh
        source /usr/local/opt/fzf/shell/completion.zsh
    fi
fi



# # --------------------------------------------------------------------
# # 5. Define color variables
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
# # 6. Promp Appearances
# # --------------------------------------------------------------------
autoload -Uz promptinit && promptinit

PROMPT="[${PR_GREEN}%n${PR_NO_COLOR}: ${PR_BLUE}%1c${PR_NO_COLOR}]%(!.#.$) " # main prompt
PROMPT2="${PR_BLACK}%_${PR_NO_COLOR}> " # command continuation prompt
# right side prompt
SPROMPT="Correct ${PR_RED}%R${PR_NO_COLOR} to ${PR_GREEN}%r${PR_NO_COLOR}? (Yes, No, Abort, Edit) " # correction prompt
RPS1='${MODE_INDICATOR_PROMPT}'

PURE_CMD_MAX_EXEC_TIME=10
PURE_GIT_UNTRACKED_DIRTY=0
prompt pure



# # --------------------------------------------------------------------
# # 7. Command Completion
# # --------------------------------------------------------------------
zstyle :compinstall filename '/Users/thiagoa/.config/zsh/.zshrc'
autoload -Uz compinit
compinit
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
# # 8. Aliases
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
alias gd='git vimdiff'
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
unalias run-help 2> /dev/null
autoload -Uz run-help
HELPDIR=/usr/local/share/zsh/help

# ssh helper
alias ssh-x='ssh -o CompressionLevel=9 -c arcfour,blowfish-cbc -YC'

# makes easy to initiate iPython
alias py='ipython'

# macOS
alias qlf='qlmanage -p "$@" > /dev/null 2>&1'

# NeoVim
alias vim='nvim'
alias vi='nvim'

# AWS CLI
alias awsp='aws --profile personal'


# # --------------------------------------------------------------------
# # 9. Key Bindings (must be one of the last things in the config)
# # --------------------------------------------------------------------
## remove unwanted bindings
## since we're using vi key binding we should turn off any bind that
## uses <Est> as the first key
bindkey -v
bindkey -r '^[/'
bindkey -r '^[,'
bindkey -r '^[~'
bindkey -r '^r'
bindkey -r '^h'
bindkey -r '^l'
bindkey -r '^j'
bindkey -r '^k'
bindkey -r '^g'

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
bindkey '^r' fzf-history-widget
bindkey -M viins '^r' fzf-history-widget
bindkey -M vicmd '^r' fzf-history-widget
bindkey -M viins '^p' history-substring-search-up
bindkey -M vicmd '^p' history-substring-search-up
bindkey -M vicmd '?' fzf-history-widget
bindkey -M vicmd '/' fzf-history-widget

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

# we have to bind our key to clear-scree because other plugins might have
# overwriten it
bindkey '\e,' clear-screen
bindkey '\e.' insert-last-word
bindkey -M vicmd '.' vi-insert-last-word
bindkey -M vicmd ',' vi-clear-screen

# complete current sugestion with Ctrl+Space
bindkey '^ ' autosuggest-accept

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

debug-widget() LBUFFER+=$(_gt)
zle -N debug-widget

bindkey '\er' redraw-current-line
bindkey '^G^F' fzf-gf-widget
bindkey '^G^B' fzf-gb-widget
bindkey '^G^T' fzf-gt-widget
bindkey '^G^H' fzf-gh-widget
bindkey '^G^R' fzf-gr-widget
bindkey '^G^G' debug-widget
