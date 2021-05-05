# # --------------------------------------------------------------------
# # Configuration file for Z Shell
# # By: Thiago Alves
# # Last Update: May 4, 2021
# # --------------------------------------------------------------------

# MIT License
#
# Copyright (c) 2016 Thiago Alves
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sub-license, and/or sell
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
# # Contents:
# # --------
# # 1. Env start hook
# # 2. Core functions
# # 3. ZSH options
# # 4. XDG variables
# # 5. System variables
# # 6. Helper variables
# # 7. Path-like variables
# # 8. Others
# # 9. Env finish hook
# # --------------------------------------------------------------------

# # --------------------------------------------------------------------
# # 1. Env start hook
# # --------------------------------------------------------------------

for hook in ${XDG_DATA_HOME}/zsh/hooks/*.zshenv.start.hook.zsh(N); do
    source $hook
done


# # --------------------------------------------------------------------
# # 2. Core functions
# # --------------------------------------------------------------------

## enable setenv() for csh compatibility
function setenv {
    typeset -x "${1}${1:+=}${(@)argv[2,$#]}"
}


# # --------------------------------------------------------------------
# # 3. ZSH options
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


# # --------------------------------------------------------------------
# # 4. XDG variables
# # --------------------------------------------------------------------

## Make sure apps know about `XDG defaults`
export XDG_LOCAL_ROOT=$HOME/.local
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$XDG_LOCAL_ROOT/share
export XDG_RUNTIME_DIR=$XDG_LOCAL_ROOT/var
export XDG_LIB_HOME=$XDG_LOCAL_ROOT/lib
export XDG_CACHE_HOME=$HOME/.cache
export XDG_LOG_HOME=$XDG_RUNTIME_DIR/log
export XDG_OPT_HOME=$XDG_LOCAL_ROOT/opt
export XDG_TEMP_HOME=$XDG_LOCAL_ROOT/temp


# # --------------------------------------------------------------------
# # 5. System variables
# # --------------------------------------------------------------------

# Disable Apple Terminal sessions since I don't use Apple Terminal
SHELL_SESSIONS_DISABLE=1

# Make ZSH more compliant with my personal directory layout
export ZSH_CACHE_DIR=${XDG_CACHE_HOME}/zsh
export ZSH_DATA_DIR=${XDG_DATA_HOME}/zsh

## default language for shell
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

## default editor
export EDITOR='nvim'
export VISUAL=${EDITOR}

export LESS="-r -F"

## make less more friendly for non-text input files, see lesspipe(1) [ -x
export LESSOPEN="|lesspipe %s"
export LESSCLOSE="lesspipe %s %s"

export LESSHISTFILE="$XDG_CACHE_HOME"/less/history

## make colors better for dark terminals
export CLICOLOR=1

## Kill the lag on vim mode when pressing <ESC>
export KEYTIMEOUT=1


# # --------------------------------------------------------------------
# # 6. Helper variables
# # --------------------------------------------------------------------

## Define a places for local binaries
export USER_BIN=$XDG_LOCAL_ROOT/bin
export USER_LIB=$XDG_LOCAL_ROOT/lib

## Define a places for local temporary files
export TMPDIR=${XDG_TEMP_HOME}

# Defines the Homebrew instalation dir
export HOMEBREW_PREFIX=/usr/local
## Allow apps to be installed on the /Applications directory
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# # --------------------------------------------------------------------
# # 7. Path-like variables
# # --------------------------------------------------------------------

## Custom array holding all directoris that should have local plugin
## files sourced during ZSH initialization.
typeset -U pluginpath
pluginpath=(
    ${ZDOTDIR:-$HOME/.zsh}/plugins
    $XDG_DATA_HOME/zsh/plugins
)

## Custom array holding all directoris that should have local binding
## files sourced during ZSH initialization.
typeset -U bindingspath
bindingspath=(
    ${ZDOTDIR:-$HOME/.zsh}/bindings
    $XDG_DATA_HOME/zsh/bindings
)

# Set the the list of directories that cd searches.
cdpath=(
    .
    ${HOME}/workplace
    "${cdpath[@]}"
)
NORMALIZE_VARS=( cdpath )

# Set the list of directories that Zsh searches for programs.
path=(
    ${USER_BIN}
    ${HOMEBREW_PREFIX}/opt/gettext/bin
    ${HOMEBREW_PREFIX}/opt/sqlite/bin
    ${HOMEBREW_PREFIX}/MacGPG2/bin
    ${HOMEBREW_PREFIX}/share/zsh/scripts
    {/usr,/$HOMEBREW_PREFIX,}/{bin,sbin}
    "$path[@]"
)
NORMALIZE_VARS=( $NORMALIZE_VARS[@] path )

fpath=(
    ${XDG_DATA_HOME}/zsh/functions
    ${ZDOTDIR:-$HOME}/functions
    ${HOMEBREW_PREFIX}/share/zsh/{site-functions,functions}
    /usr/share/zsh/site-functions
    /usr/share/zsh/5.3/functions
    "${fpath[@]}"
)
NORMALIZE_VARS=( $NORMALIZE_VARS[@] fpath )

# Path for user manuals
MANPATH=${XDG_DATA_HOME}/man:/usr/share/man:${MANPATH}
NORMALIZE_VARS=( $NORMALIZE_VARS[@] MANPATH )

HELPDIR=${XDG_DATA_HOME}/zsh/help:${XDG_DATA_HOME}/zsh/helpfiles:${HOMEBREW_PREFIX}/share/zsh/help:${HOMEBREW_PREFIX}/share/zsh/helpfiles:/usr/share/zsh/5.3/help:/usr/share/zsh/5.3/helpfiles
NORMALIZE_VARS=( $NORMALIZE_VARS[@] HELPDIR )

export PERLLIB=${XDG_LIB_HOME}/perl:${PERLLIB}
NORMALIZE_VARS=( $NORMALIZE_VARS[@] PERL5LIB )

# Path for dynamic loading of libraries.
export LD_LIBRARY_PATH=${USER_LIB}:${HOMEBREW_PREFIX}/lib:/usr/lib:${LD_LIBRARY_PATH}
NORMALIZE_VARS=( $NORMALIZE_VARS[@] LD_LIBRARY_PATH )


# # --------------------------------------------------------------------
# # 8. Others
# # --------------------------------------------------------------------

export LDFLAGS="-L/usr/local/opt/gettext/lib -L/usr/local/opt/sqlite/lib -L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
export CPPFLAGS="-I/usr/local/opt/gettext/include -I/usr/local/opt/sqlite/include -I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"
export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig:/usr/local/opt/zlib/lib/pkgconfig"
export MANPATH=${XDG_DATA_HOME}/man:${HOMEBREW_PREFIX}/share/man:$MANPATH

# Define where gradle should store its local data files
export GRADLE_USER_HOME=${XDG_DATA_HOME}/gradle


# # --------------------------------------------------------------------
# # 9. Env finish hook
# # --------------------------------------------------------------------

for hook in ${XDG_DATA_HOME}/zsh/hooks/*.zshenv.finish.hook.zsh(#qN); do
    source $hook
done
