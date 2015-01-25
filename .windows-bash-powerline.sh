#!/usr/bin/env bash

__powerline() {

    # Unicode symbols
    readonly PS_SYMBOL_DARWIN='ʎ'
    readonly PS_SYMBOL_LINUX='ʎ'
    readonly PS_SYMBOL_OTHER='ʎ'
    readonly GIT_BRANCH_SYMBOL='Ⴤ '
    readonly GIT_BRANCH_CHANGED_SYMBOL='+'
    readonly GIT_NEED_PUSH_SYMBOL='￪'
    readonly GIT_NEED_PULL_SYMBOL='￬'

    # what OS?
    case "$(uname)" in
        Darwin)
            readonly PS_SYMBOL=$PS_SYMBOL_DARWIN
            ;;
        Linux)
            readonly PS_SYMBOL=$PS_SYMBOL_LINUX
            ;;
        *)
            readonly PS_SYMBOL=$PS_SYMBOL_OTHER
    esac

    __git_info() { 
        [ -x "$(which git)" ] || return    # git not found

        # get current branch name or short SHA1 hash for detached head
        local branch="$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)"
        [ -n "$branch" ] || return  # git branch not found

        # print the git branch segment without a trailing newline
        printf " $GIT_BRANCH_SYMBOL$branch "
    }

    readonly BG_GREEN='\e[42m'
    readonly BG_BLUE='\e[44m'
    readonly BG_RED='\e[41m'
    readonly FG_WHITE='\e[97m'
    readonly RESET='\e[0m'
    readonly BOLD='\e[1m'
    ps1() {
        # Check the exit code of the previous command and display different
        # colors in the prompt accordingly. 
        if [ $? -eq 0 ]; then
            local BG_EXIT="$BG_GREEN"
        else
            local BG_EXIT="$BG_RED"
        fi

        
        PS1="$BG_BLUE$FG_WHITE$(__git_info)$RESET"
        PS1+="\e[1;40;32m$BOLD \w $RESET"
        PS1+="\n$BG_EXIT $FG_WHITE$PS_SYMBOL $RESET "
    }

    PROMPT_COMMAND=ps1
}

__powerline
unset __powerline
