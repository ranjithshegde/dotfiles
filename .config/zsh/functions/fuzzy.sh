#!/bin/sh

fkill() {
	local pid
	if [ "$UID" != "0" ]; then
		pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
	else
		pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
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
