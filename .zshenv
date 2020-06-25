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

#zmodload zsh/zprof

# # --------------------------------------------------------------------
# # 1. Core functions
# # --------------------------------------------------------------------

## Returns whether the given command is executable or aliased.
function _has() {
    return $(whence $1 >/dev/null 2>&1)
}

## Returns whether the given alias exists
function _has_alias() {
    return $(alias $1 > /dev/null 2>&1)
}

## enable setenv() for csh compatibility
function setenv {
    typeset -x "${1}${1:+=}${(@)argv[2,$#]}"
}


# # --------------------------------------------------------------------
# # 2. ZSH options
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
# # 3. XDG variables
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
export XDG_TEMP_HOME=$XDG_LOCAL_ROOT/tmp


# # --------------------------------------------------------------------
# # 4. System variables
# # --------------------------------------------------------------------

# Make ZSH more compliant with my personal directory layout
export ZSH_CACHE_DIR=${XDG_CACHE_HOME}/zsh

## history settins
export HISTSIZE=100000
# cache directory
export HISTFILE=${ZSH_CACHE_DIR}/history
export SAVEHIST=${HISTSIZE}

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

## make colors better for dark terminals
export CLICOLOR=1
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"

## Kill the lag on vim mode when pressing <ESC>
export KEYTIMEOUT=1


# # --------------------------------------------------------------------
# # 5. Helper variables
# # --------------------------------------------------------------------

## Define a places for local binaries
export USER_BIN=$XDG_LOCAL_ROOT/bin
export USER_LIB=$XDG_LOCAL_ROOT/lib

## Define a places for local temporary files
export TMPDIR=${XDG_TEMP_HOME}


# # --------------------------------------------------------------------
# # 6. Path-like variables
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
    /usr/local/MacGPG2/bin
    /usr/local/bin
    /usr/share/zsh/5.3/scripts
    /usr/{bin,sbin}
    /{bin,sbin}
    "$path[@]"
)
NORMALIZE_VARS=( $NORMALIZE_VARS[@] path )

fpath=(
    ${XDG_DATA_HOME}/zsh/functions
    ${ZDOTDIR:-$HOME}/functions
    /usr/share/zsh/site-functions
    /usr/share/zsh/5.3/functions
    "${fpath[@]}"
)
NORMALIZE_VARS=( $NORMALIZE_VARS[@] fpath )

# Path for user manuals
MANPATH=${XDG_DATA_HOME}/man:/usr/share/man:${MANPATH}
NORMALIZE_VARS=( $NORMALIZE_VARS[@] MANPATH )

HELPDIR=${XDG_DATA_HOME}/zsh/help:/usr/local/share/zsh/help:/usr/share/zsh/5.3/help
NORMALIZE_VARS=( $NORMALIZE_VARS[@] HELPDIR )

export PERLLIB=${XDG_LIB_HOME}/perl:${PERLLIB}
NORMALIZE_VARS=( $NORMALIZE_VARS[@] PERL5LIB )

# Path for dynamic loading of libraries.
export LD_LIBRARY_PATH=${USER_LIB}:/usr/local/lib:/usr/lib:${LD_LIBRARY_PATH}
NORMALIZE_VARS=( $NORMALIZE_VARS[@] LD_LIBRARY_PATH )


# # --------------------------------------------------------------------
# # 7. Others
# # --------------------------------------------------------------------

export POETRY_HOME=${XDG_OPT_HOME}/poetry
export RUSTUP_HOME=${XDG_OPT_HOME}/rustup
export CARGO_HOME=${XDG_OPT_HOME}/cargo

## Make GnuPG to use XDG configuration dir
export GNUPGHOME=${XDG_CONFIG_HOME}/gnupg
export GPG_TTY=$(tty)

## Define where the Android SDK should be installed
export ANDROID_SDK_ROOT=/usr/local/share/android-sdk
export ANDROID_NDK_ROOT=/usr/local/share/android-ndk
export ANDROID_SDK_HOME=/usr/local/share/android-sdk
export ANDROID_EMULATOR_HOME=/usr/local/share/android-sdk/emulator
export ANDROID_AVD_HOME=${HOME}/.android/adv

# Define where gradle should store its local data files
export GRADLE_USER_HOME=${XDG_DATA_HOME}/gradle

# Define where iPython should store its local data files
export IPYTHONDIR=${XDG_DATA_HOME}/ipython

## Ansible configuration
export ANSIBLE_LOCAL_TEMP=${XDG_TEMP_HOME}/ansible
export ANSIBLE_LOG_PATH=${XDG_LOG_HOME}/ansible/ansible.log
export ANSIBLE_SSH_CONTROL_PATH_DIR=${XDG_RUNTIME_DIR}/ansible/control
export ANSIBLE_GALAXY_TOKEN_PATH=${XDG_RUNTIME_DIR}/ansible/galaxy.token
export ANSIBLE_PERSISTENT_CONTROL_PATH_DIR=${XDG_RUNTIME_DIR}/ansible/pc
mkdir -p ${XDG_RUNTIME_DIR}/ansible
mkdir -p ${XDG_LOG_HOME}/ansible
