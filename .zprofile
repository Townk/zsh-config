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
# # 1. Profile start hook
# # 2. Message Of The Day (MOTD)
# # 3. Plugins
# # 4. Profile finish hook
# # --------------------------------------------------------------------

# # --------------------------------------------------------------------
# # 1. Profile start hook
# # --------------------------------------------------------------------

for hook in ${XDG_DATA_HOME}/zsh/hooks/*.zprofile.start.hook.zsh(#qN); do
    source $hook
done


# # --------------------------------------------------------------------
# # 2. Message Of The Day (MOTD)
# # --------------------------------------------------------------------
case $OSTYPE in
  darwin*)
    PWD_LAST_CHANGE=$(dscl -q . read $HOME SMBPasswordLastSet 2> /dev/null | grep -v ':$' | awk '{ sub(/^(.*:)? +/, ""); print $0 }')
    if [ -n "$PWD_LAST_CHANGE" ] && [ "$PWD_LAST_CHANGE" -eq "$PWD_LAST_CHANGE" ] 2>/dev/null; then
        PWD_LAST_CHANGE=$(( $(date +%s) - ($PWD_LAST_CHANGE / 10000000 - 11644473600) ))
    else
        PWD_LAST_CHANGE=$(( $(date +%s) - $(dscl -q . readpl $HOME accountPolicyData passwordLastSetTime | awk '{ sub(/^(.*:)? +/, ""); print $0 }') ))
    fi
    UPTIME_TEXT=$(uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* users.*//; s/min/minutes/; s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/')
    PWD_REMAINING_DAYS=$(LC_ALL=C /usr/bin/printf "%.*f\n" "0" $((90 - ($PWD_LAST_CHANGE / 86400))) )
    USER_REAL_NAME=$(dscl -q . read $HOME RealName | grep -v ':$' | awk '{ sub(/^ +/, ""); print $2 }')
    ;;
  *)
    UPTIME_TEXT="$(uptime -p 2> /dev/null)"
    PWD_REMAINING_DAYS=$(( ($(date -d "`chage -l $USER | grep "Last password change" | awk -F: '{ print $2; }'` + 90 days" +%s) - $(date -d "now" +%s)) / 86400 ))
    ;;
esac
PWD_REMAINING_SUFFIX="day"
if [ $PWD_REMAINING_DAYS -gt 7 ]; then
    PWD_COLOR="\e[6;32m"
elif [ $PWD_REMAINING_DAYS -gt 2 ]; then
    PWD_COLOR="\e[6;33m"
else
    PWD_COLOR="\e[6;31m"
    if [ $PWD_REMAINING_DAYS -ne 1 ]; then
        PWD_REMAINING_SUFFIX="${PWD_REMAINING_SUFFIX}s"
    fi
fi

UPTIME_TEXT="$(uptime -p 2> /dev/null)"
if [ $? -ne 0 ]; then
    UPTIME_TEXT=$(uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* users.*//; s/min/minutes/; s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/')
fi


if $(whence toilet >/dev/null); then
    echo -e "\e[1;37m";toilet -f future -F gay -t "   Welcome, " ${USER_REAL_NAME:-$USER};
    echo ""
fi
echo -ne "     \e[0;34mToday is:\t\t\t\e[6;32m" `date`; echo ""
echo -ne "     \e[0;34mUptime:\t\t\t\e[6;32m ";echo $UPTIME_TEXT
echo -ne "     \e[0;34mPassword expires in:\t$PWD_COLOR ";echo "$PWD_REMAINING_DAYS $PWD_REMAINING_SUFFIX"
echo -e "     \e[0;34mKernel Information: \t\e[6;32m" `uname -smr`;echo "";echo ""
echo -e "\e[6;33m"; cal -3
echo -ne "\e[0m"


# # --------------------------------------------------------------------
# # 3. Plugins
# # --------------------------------------------------------------------
for plugindir in $pluginpath; do
    if [ -d $plugindir ]; then
        for plugin in $plugindir/*.plugin.zsh(#qN); do
            source $plugin
        done
    fi
done    


# # --------------------------------------------------------------------
# # 4. Profile finish hook
# # --------------------------------------------------------------------

for hook in ${XDG_DATA_HOME}/zsh/hooks/*.zprofile.finish.hook.zsh(#qN); do
    source $hook
done
