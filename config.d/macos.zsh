# # --------------------------------------------------------------------
# # Configuration file for Z Shell Specific for macOS system
# # By: Thiago Alves
# # Last Update: August, 16 2019
# # --------------------------------------------------------------------


# # --------------------------------------------------------------------
# # Contents:
# # --------
# # 2. Environment Options
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
# # 2. Environment Options
# # --------------------------------------------------------------------
# Environment variables and shell options specific for macOS

# search path for zsh functions  (fpath ==> function path)
fpath=(                                  \
        ${ZDOTDIR:-$HOME}/functions      \
        /usr/local/share/zsh-completions \
        ${fpath}                         \
      )


# # --------------------------------------------------------------------
# # 3. Custom Shell Functions
# # --------------------------------------------------------------------
# Shell functions specific for macOS

function fcd {
    pFinder=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
    [ -n "${pFinder}" ] && cd "${pFinder}"
}



# # --------------------------------------------------------------------
# # 4. Applications
# # --------------------------------------------------------------------
# Configuration for applications specific for macOS

# Homebrew
if [[ -a /usr/local/bin/brew ]]; then
    BREW_PATH="`/usr/local/bin/brew --prefix`"
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

