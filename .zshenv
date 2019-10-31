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

## Define a place for all TMux configuration files
TMUXDIR=$XDG_CONFIG_HOME/tmux
## Define a place for all iTerm2 integration files
ITERMDIR=$XDG_CONFIG_HOME/iterm2
## Make GnuPG to use XDG configuration dir
GNUPGHOME=$XDG_CONFIG_HOME/gnupg

## Define a place for local installation of tools
USER_LOCAL_HOME=$HOME/.local

## Define where the available JDK is installed
JAVA_HOME=$USER_LOCAL_HOME/opt/jenv/versions/1.8
## Define where the Android SDK should be installed
ANDROID_HOME=/usr/local/share/android-sdk
