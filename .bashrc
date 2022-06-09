#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias python=python3
alias grep='grep --color=auto'
# alias weather='curl wttr.in/"den haag"'


source /usr/share/doc/find-the-command/ftc.bash


PS1='[\u@\h \W]\$ '

VISUAL=nvim; export VISUAL EDITOR=nvim; export EDITOR

# export HISTCONTROL=ignoreboth
# export BROWSER=qutebrowser
#export CLICOLOR=1


export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'


ranger-cd() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
        cd -- "$chosen_dir"
    fi
    rm -f -- "$temp_file"
}


alias config='/usr/bin/git --git-dir=/home/ranjith/Software/Workspaces/Repos/dotfiles --work-tree=/home/ranjith'

source /opt/vcpkg/scripts/vcpkg_completion.bash
