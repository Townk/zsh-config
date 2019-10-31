#!/bin/env zsh
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



if [ -f ${HOME}/.local/bin/fzf ]; then
    FZF_BIN_PATH="${HOME}/.local/bin"
elif [ -f /usr/local/bin/fzf ]; then
    FZF_BIN_PATH="/usr/local/bin"
elif [ -f /usr/bin/fzf ]; then
    FZF_BIN_PATH="/usr/bin"
else
    FZF_BIN=`which fzf`
    FZF_BIN_PATH=`dirname ${FZF_BIN}`
fi

if [ -f ${FZF_BIN_PATH}/fzf  ]; then
    if [ ! "$PATH" = "*${FZF_BIN_PATH}*" ]; then
        export PATH=$PATH:${FZF_BIN_PATH}
    fi

    if [ -e ${HOME}/.local/opt/fzf ]; then
        FZF_HOME="${HOME}/.local/opt/fzf"
    elif [ -e /usr/local/opt/fzf ]; then
        FZF_HOME="/usr/local/opt/fzf"
    else
        FZF_HOME="${HOME}/.fzf"
    fi

    # 3P Integrations
    # -------------------

    # fzf + git configuration
    if $( whence git >/dev/null ); then
        # GIT FZF integration
        # -------------------

        # A helper function to join multi-line output from fzf
        join-lines() {
            local item
            while read item; do
                echo -n "${(q)item} "
            done
        }

        is_in_git_repo() {
            git rev-parse HEAD > /dev/null 2>&1
        }

        # Search for Git [F]iles
        function fzf-gf-widget {
            if is_in_git_repo; then
                LBUFFER+=$(git -c color.status=always status --short |
                               fzf -m \
                                   --ansi \
                                   --nth 2..,.. \
                                   --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
                               cut -c4- |
                               sed 's/.* -> //' |
                               join-lines)
            fi
            zle reset-prompt
        }
        zle -N fzf-gf-widget

        # Search for Git [B]ranches
        function fzf-gb-widget {
            if is_in_git_repo; then
                LBUFFER+=$(git branch -a --color=always |
                               grep -v '/HEAD\s' |
                               sort |
                               fzf --ansi \
                                   --multi \
                                   --tac \
                                   --preview-window right:70% \
                                   --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
                               sed 's/^..//' | cut -d' ' -f1 |
                               sed 's#^remotes/##' |
                               join-lines)
            fi
            zle reset-prompt
        }
        zle -N fzf-gb-widget

        # Search for Git [T]ags
        function fzf-gt-widget {
            if is_in_git_repo; then
                LBUFFER+=$(git tag --sort -version:refname |
                               fzf --multi \
                                   --preview-window right:70% \
                                   --preview 'git show --color=always {} | head -'$LINES |
                               join-lines)
            fi
            zle reset-prompt
        }
        zle -N fzf-gt-widget

        # Search for Git [H]ash commits
        function fzf-gh-widget {
            if is_in_git_repo; then
                LBUFFER+=$(git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
                               fzf --ansi \
                                   --no-sort \
                                   --reverse \
                                   --multi \
                                   --bind 'ctrl-s:toggle-sort' \
                                   --header 'Press CTRL-S to toggle sort' \
                                   --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
                               grep -o "[a-f0-9]\{7,\}" |
                               join-lines)
            fi
            zle reset-prompt
        }
        zle -N fzf-gh-widget

        # Search Git [R]emotes
        function fzf-gr-widget {
            if is_in_git_repo; then
                LBUFFER+=$(git remote -v |
                               awk '{print $1 "\t" $2}' |
                               uniq |
                               fzf --tac \
                                   --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
                               cut -d$'\t' -f1 |
                               join-lines)
            fi
            zle reset-prompt
        }
        zle -N fzf-gr-widget
    fi

    # fzf + rg + ag configuration
    if $( whence rg >/dev/null ); then
        export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
    elif $( whence ag >/dev/null ); then
        export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
    fi


    # fzf + fd configuration
    if $( whence fd >/dev/null ); then
        # Use fd (https://github.com/sharkdp/fd) instead of the default find
        # command for listing path candidates.
        # - The first argument to the function ($1) is the base path to start traversal
        # - See the source code (completion.{bash,zsh}) for the details.
        _fzf_compgen_path() {
            fd --hidden --follow --exclude ".git" . "$1"
        }

        # Use fd to generate the list for directory completion
        _fzf_compgen_dir() {
            fd --type d --hidden --follow --exclude ".git" . "$1"
        }
    fi

    # fzf + gradle configuration
    # Since gradle doesn't need to be installed on the system to work, we always configure it

    # Set the caching policy to invalidate cache if the build file is newer than the
    # cache.
    _gradle_caching_policy() {
        [[ $gradle_buildfile -nt $1 ]]
    }

    _gradle_cache_creation() {
        zle -R "Generating cache from $gradle_buildfile"
        local gradle_buildfile=${3:=build.gradle}
        local cache_name=${2:=${${gradle_buildfile:a}//[^[:alnum:]]/_}}
        local gradle_cmd=${1:=gradle}
        local outputline
        local -a match mbegin mend
        # Run gradle/gradlew and retrieve possible tasks.
        for outputline in ${(f)"$($gradle_cmd --build-file $gradle_buildfile -q tasks --all 2> /dev/null)"}; do
            # We must include the ':' character since it's part of any task name
            if [[ $outputline == "(#b)([[:blank:]]#)([[:alnum:]:]##)' - '(*)" ]]; then
                # The descriptions of main tasks start at beginning of line, descriptions of
                # secondary tasks are indented.
                # Also, we need to escape the ':' character since it's used as syntax on the
                # caching system.
                if [[ $mend[1] -gt $mbegin[1] ]]; then
                    gradle_group_tasks+=( "${match[2]/:/\\:}:${match[3]% \[*}" )
                else
                    gradle_all_tasks+=( "${match[2]/:/\\:}:${match[3]% \[*}" )
                fi
            fi
        done
        _store_cache $cache_name gradle_group_tasks gradle_all_tasks
    }

    _gradle_complete_cache_invalid() {
        local _cache_ident _cache_dir _cache_path _cache_policy
        _cache_ident="$1"

        # If the cache is disabled, we never want to rebuild it, so pretend
        # it's valid.
        zstyle -t ":completion:complete:gradle:argument-rest:" use-cache || return 1

        zstyle -s ":completion:complete:gradle:argument-rest:" cache-path _cache_dir
        : ${_cache_dir:=${ZDOTDIR:-$HOME}/.zcompcache}
        _cache_path="$_cache_dir/$_cache_ident"

        _gradle_caching_policy "$_cache_path" && return 0

        return 1
    }

    _fzf_complete_gradle() {
        _fzf_complete '--multi --ansi --delimiter=- --nth=1' "$@" < <(
            local gradle_buildfile='build.gradle'
            if [[ -f $gradle_buildfile ]]; then
                # Cache name is constructed from the absolute path of the build file.
                local cache_name=${${gradle_buildfile:a}//[^[:alnum:]]/_}
                local buildfile_outdated=false
                export curcontext=':complete:gradle:argument-rest'

                if _gradle_complete_cache_invalid $cache_name || ! _retrieve_cache $cache_name; then
                    _gradle_cache_creation 'gradle' $cache_name $gradle_buildfile
                fi

                for c in $gradle_group_tasks; do
                    local -a match mbegin mend
                    if [[ $c == "[[:blank:]]#(#b)([[:alnum:]]##'\:')#(*)':'([^:]#)" ]]; then
                        if [[ $mend[1] -gt $mbegin[1] ]]; then
                            printf "${match[1]/\\:/:}${COLOR_GREEN}${match[2]}${COLOR_NO_COLOR} %*s\n" $(( `tput cols` - (${#match[1]} + ${#match[2]} + 6) )) "${match[3]}"
                        else
                            printf "${COLOR_GREEN}${match[2]}${COLOR_NO_COLOR} %*s\n" $(( `tput cols` - (${#match[2]} + 5) )) "${match[3]}"
                        fi
                    else
                        print $c
                    fi
                done
            else
                printf "${COLOR_GREEN}buildEnvironment${COLOR_NO_COLOR} %*s\n" $((`tput cols` - 21)) "Displays all buildscript dependencies declared in root project '$(basename $PWD)'"
                printf "${COLOR_GREEN}components${COLOR_NO_COLOR} %*s\n" $((`tput cols` - 15)) "Displays the components produced by root project '$(basename $PWD)'"
                printf "${COLOR_GREEN}dependencies${COLOR_NO_COLOR} %*s\n" $((`tput cols` - 17)) "Displays all dependencies declared in root project '$(basename $PWD)'"
                printf "${COLOR_GREEN}dependencyInsight${COLOR_NO_COLOR} %*s\n" $((`tput cols` - 22)) "Displays the insight into a specific dependency in root project '$(basename $PWD)'"
                printf "${COLOR_GREEN}help${COLOR_NO_COLOR} %*s\n" $((`tput cols` - 9)) "Displays a help message"
                printf "${COLOR_GREEN}init${COLOR_NO_COLOR} %*s\n" $((`tput cols` - 9)) "Initializes a new Gradle build"
                printf "${COLOR_GREEN}model${COLOR_NO_COLOR} %*s\n" $((`tput cols` - 10)) "Displays the configuration model of root project '$(basename $PWD)'"
                printf "${COLOR_GREEN}projects${COLOR_NO_COLOR} %*s\n" $((`tput cols` - 13)) "Displays the sub-projects of root project '$(basename $PWD)'"
                printf "${COLOR_GREEN}properties${COLOR_NO_COLOR} %*s\n" $((`tput cols` - 15)) "Displays the properties of root project '$(basename $PWD)'"
                printf "${COLOR_GREEN}tasks${COLOR_NO_COLOR} %*s\n" $((`tput cols` - 10)) "Displays the tasks runnable from root project '$(basename $PWD)'"
                printf "${COLOR_GREEN}wrapper${COLOR_NO_COLOR} %*s\n" $((`tput cols` - 12)) "Generates Gradle wrapper files"
            fi
        )
    }

    _fzf_complete_gradle_post() {
        awk '{ print $1; }' | sed 's/[^[:graph:]]*//g'
    }

    # UX
    # -------------------

    PREVIEW_CMD="[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file ||
                 (bat --style=numbers,changes --color=always {} ||
                 highlight -O ansi -l {} ||
                 coderay {} ||
                 rougify {} ||
                 cat {}) 2> /dev/null || head -500"

    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
    # Options to fzf command
    export FZF_DEFAULT_OPTS='
           --filepath-word
           --border
           --height=45%
           --layout=reverse
           --inline-info
           --prompt="  "
           --color gutter:-1
           --preview "[[ $(file --mime {}) =~ binary ]] && file -F \" is\" --mime {} ||
                   (bat --style=numbers,changes --color=always {} ||
                   highlight -O ansi -l {} ||
                   coderay {} ||
                   rougify {} ||
                   cat {}) 2> /dev/null || head -500"
           --preview-window=right:60%:hidden
           --bind "ctrl-space:toggle-preview"
           '

    # Extras
    # -------------------

    if [ -f ${FZF_HOME}/shell/completion.zsh ]; then
        source ${FZF_HOME}/shell/completion.zsh
    fi

    if [ -f ${FZF_HOME}/shell/key-bindings.zsh ]; then
        source ${FZF_HOME}/shell/key-bindings.zsh
    fi
fi
