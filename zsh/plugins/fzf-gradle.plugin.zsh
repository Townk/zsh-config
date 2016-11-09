#!/bin/env zsh

# Set the caching policy to invalidate cache if the build file is newer than the 
# cache.
_gradle_caching_policy() {
    [[ $gradle_buildfile -nt $1 ]] }

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
        if [[ $outputline == (#b)([[:blank:]]#)([[:alnum:]:]##)' - '(*) ]]; then
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
                if [[ $c == [[:blank:]]#(#b)([[:alnum:]]##'\:')#(*)':'([^:]#) ]]; then
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


