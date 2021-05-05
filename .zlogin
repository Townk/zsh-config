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
# # 1. Login start hook
# # 3. Variable normalization
# # 3. Login start hook
# # 4. Path adjustment
# # --------------------------------------------------------------------

# # --------------------------------------------------------------------
# # 1. Login start hook
# # --------------------------------------------------------------------

for hook in ${XDG_DATA_HOME}/zsh/hooks/*.zlogin.start.hook.zsh(#qN); do
    source $hook
done


# # --------------------------------------------------------------------
# # 3. Variable normalization
# # --------------------------------------------------------------------

# Clean up all path variables
normalize-paths $NORMALIZE_VARS


# # --------------------------------------------------------------------
# # 3. Login start hook
# # --------------------------------------------------------------------

for hook in ${XDG_DATA_HOME}/zsh/hooks/*.zlogin.finish.hook.zsh(#qN); do
    source $hook
done


# # --------------------------------------------------------------------
# # 4. Path adjustment
# # --------------------------------------------------------------------

# Make user binaries to take precedence over anything else
export PATH="$USER_BIN:${PATH//:$USER_BIN:/:}"
