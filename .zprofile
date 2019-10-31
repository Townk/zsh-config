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


UPTIME_TEXT="$(uptime -p 2> /dev/null)"
if [ $? -ne 0 ]; then
    UPTIME_TEXT=$(uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* users.*//; s/min/minutes/; s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/')
fi

if $(whence toilet >/dev/null); then
    echo -e "\e[1;37m";toilet -f future -F gay -t "   Welcome, " $USER;
    echo ""
fi
echo -ne "     \e[0;34mToday is:\t\t\t\e[6;32m" `date`; echo ""
echo -e "     \e[0;34mKernel Information: \t\e[6;32m" `uname -smr`
echo -ne "     \e[0;34mUptime:\t\t\t\e[6;32m ";echo $UPTIME_TEXT;echo ""
echo -e "\e[6;33m"; cal -3
echo -e "\e[0m"
