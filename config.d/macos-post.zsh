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

# Use this file to configure options specific for a macOS system. Notice
# that not all sessions are listed here. This is on purpose to prevent
# any override on sessions that were not intended to be overriden.

# # --------------------------------------------------------------------
# # 1. Custom Shell Functions
# # --------------------------------------------------------------------
# Shell functions specific for macOS

function fcd() {
    pFinder=$(osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)')
    [ -n "${pFinder}" ] && cd "${pFinder}"
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


# # --------------------------------------------------------------------
# # 2. Environment variables
# # --------------------------------------------------------------------
# Variables that need most of the configuration to be finished before they're
# defined. These variables usually use autoloaded functions or a local plugin.
if _has brew; then
    ## Homebrew helper to allow more API access on Github
    export HOMEBREW_GITHUB_API_TOKEN=$(vault github.api.access_token)
fi

# # --------------------------------------------------------------------
# # 3. Aliases
# # --------------------------------------------------------------------
# Aliases specific for macOS

## file extension association
alias -s html="open"

# notification center
alias notify='/Applications/Terminal\ Notifier.app/Contents/MacOS/terminal-notifier'

# Quick View
alias qlf='qlmanage -p "$@" > /dev/null 2>&1'
