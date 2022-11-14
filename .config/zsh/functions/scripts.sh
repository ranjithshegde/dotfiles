#!/bin/sh

nv_power() {
	cat /sys/bus/pci/devices/0000:01:00.0/power_state
}

nv_settings() {
	nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings
}

vids() {
	vlc "$(find ~/Videos/. -name "*.*" | dmenu -l 30 -i -p 'Select video: ')"
}

pacelist() {
	expac --timefmt='%Y-%m-%d %T' '%l\t%n\t:%w' | sort | grep -i 'explicit' | tail -n 200 | awk -F: '{print $1 $2 $3}' | nvim +Man!
}

netS() {
	DT=$(echo | dmenu -c -p "File or directory: ")
	IT=$(echo | dmenu -c -p "ip extension 192.168.: ")

	echo "Exporting file ${DT} to ip 192.168.${IT}"

	tar cf - "${DT}" | pv | netcat 192.168."${IT}" 7000
}

netR() {
	netcat -l -p 7000 | pv | tar x
}

# Ranger change directory on exit-----------------------------------------------------------
ranger_cd() {
	temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
	ranger --choosedir="$temp_file" -- "${@:-$PWD}"
	if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
		cd -- "$chosen_dir" || exit
	fi
	rm -f -- "$temp_file"
}

# FZF dotfiles -------------------------------------------------------------------------------
hcd() {
	dir=$(find "${1:-.}" -type d 2>/dev/null | fzf +m --reverse --prompt='Enter Directory> ') && cd "$dir" || exit
}

zle -N hcd
bindkey -M emacs '\eD' hcd
bindkey -M vicmd '\eD' hcd
bindkey -M viins '\eD' hcd
