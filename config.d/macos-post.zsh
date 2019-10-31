# -*- mode: sh; indent-tabs-mode: nil; tab-width: 4; tab-always-indent: t -*-

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
# # Configuration file for Z Shell Specific for macOS system
# # By: Thiago Alves
# # Last Update: August, 16 2019
# # --------------------------------------------------------------------

# # --------------------------------------------------------------------
# # Contents:
# # --------
# # 3. Custom Shell Functions
# # 4. Applications
# # 7. Command Completion
# # 8. Aliases
# # 9. Key Bindings
# # --------------------------------------------------------------------

# Use this file to configure options specific for a macOS system. Notice
# that not all sessions are listed here. This is on purpose to prevent
# any override on sessions that were not intended to be overriden.

# # --------------------------------------------------------------------
# # 3. Custom Shell Functions
# # --------------------------------------------------------------------
# Shell functions specific for macOS

function fcd() {
    pFinder=$(osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)')
    [ -n "${pFinder}" ] && cd "${pFinder}"
}

# # --------------------------------------------------------------------
# # 4. Applications
# # --------------------------------------------------------------------
# Configuration for applications specific for macOS

# Homebrew
if [[ -e /usr/local/bin/brew ]]; then
    BREW_PATH="$(/usr/local/bin/brew --prefix)"
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

# NVM
[ -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" ] && . "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"  # This loads nvm
[ -s "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion" ] && . "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# # --------------------------------------------------------------------
# # 7. Command Completion
# # --------------------------------------------------------------------
# Command completion options specific for macOS

# # --------------------------------------------------------------------
# # 8. Aliases
# # --------------------------------------------------------------------
# Aliases specific for macOS

## file extension association
alias -s html="open"

# notification center
alias notify='/Applications/Terminal\ Notifier.app/Contents/MacOS/terminal-notifier'

# Quick View
alias qlf='qlmanage -p "$@" > /dev/null 2>&1'

# # --------------------------------------------------------------------
# # 9. Key Bindings (must be one of the last things in the config)
# # --------------------------------------------------------------------
# Bindings specific for macOS. This is also the place to fix bindings
# that were misconfigured due to any option/configuration in the system
# specific section.
