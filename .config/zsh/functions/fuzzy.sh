#!/bin/zsh

fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(/usr/bin/ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(/usr/bin/ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]; then
        echo "$pid" | xargs kill -"${1:-9}"
    fi
}

fparu() {
    paru -Slq | fzf -q "$1" -m --preview 'paru -Si {1} && paru -Fl {1}' | xargs -ro paru -S
}

rpac() {
    paru -Qq | fzf -q "$1" -m --preview 'paru -Qi {1} && paru -Ql {1}' | xargs -ro paru -Rcnsu
}

repac() {
    paru -Qe | fzf -q "$1" -m --preview 'paru -Qi {1} && paru -Ql {1}' | xargs -ro paru -Rcnsu
}

sc() {
    du -a ~/.config/ ~/.local/bin/scripts/ ~/.local/share/nvim/ | awk '{print $2}' | fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' | xargs -r "$EDITOR"
}

fbrow() {
    pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'
}

hcd() {
    dir=$(fd --type d --follow . "${1:-.}" 2>/dev/null | fzf +m --reverse --prompt='Enter Directory> ') && cd "$dir" || exit
}
