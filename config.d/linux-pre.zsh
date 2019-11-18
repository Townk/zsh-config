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

# Use this file to configure options specific for a Linux system. Notice
# that not all sessions are listed here. This is on purpose to prevent
# any override on sessions that were not intended to be overriden.

# # --------------------------------------------------------------------
# # 1. Environment Options
# # --------------------------------------------------------------------
# Environment variables and shell options specific for Linux

# search path for zsh functions  (fpath ==> function path)
fpath=(
    ${XDG_DATA_HOME}/zsh/functions
    ${ZDOTDIR:-$HOME}/functions
    /usr/local/share/zsh/site-functions
    "${fpath[@]}"
)
