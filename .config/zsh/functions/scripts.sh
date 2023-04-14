#!/bin/sh

nvp() {
    cat /sys/bus/pci/devices/0000:01:00.0/power_state
}

nvs() {
    nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings
}

vids() {
    vlc "$(find ~/Videos/. -name "*.*" | dmenu -l 30 -i -p 'Select video: ')"
}

pacelist() {
    expac --timefmt='%Y-%m-%d %T' '%l\t%n\t:%w' | sort | grep -i 'explicit' | tail -n 200 | awk -F: '{print $1 $2 $3}' | nvim +Man!
}

paclist() {
    expac --timefmt='%Y-%m-%d %T' '%l\t%n\t:%w' | sort | tail -n 200 | awk -F: '{print $1 $2 $3}' | nvim +Man!
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

#Check externel screen connection status
screen_connected() {

    if [[ ${XDG_SESSION_TYPE} == "wayland" ]]; then
        return 1
    fi

    hdmi_status="$(cat /sys/class/drm/card1-HDMI-A-1/status)"
    usbc_status="$(cat /sys/class/drm/card1-DP-1/status)"

    if [ "${hdmi_status}" = "connected" ] || [ "${usbc_status}" = "connected" ]; then
        return 0
    else
        return 1
    fi
}

# FZF dotfiles -------------------------------------------------------------------------------
hcd() {
    dir=$(find "${1:-.}" -type d 2>/dev/null | fzf +m --reverse --prompt='Enter Directory> ') && cd "$dir" || exit
}

zle -N hcd
bindkey -M emacs '\eD' hcd
bindkey -M vicmd '\eD' hcd
bindkey -M viins '\eD' hcd
