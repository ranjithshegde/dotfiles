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

nopac() {
    find /etc /usr /opt | LC_ALL=C.UTF-8 pacman -Qqo - 2>&1 >&- >/dev/null | cut -d ' ' -f 5- >excess.txt
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

dgvim() {
    local original_git_dir="$GIT_DIR"
    local original_git_work_tree="$GIT_WORK_TREE"

    # Set Git environment variables
    export GIT_DIR="${HOME}/Repositories/Maintained/dotbare"
    export GIT_WORK_TREE="${HOME}"

    # Check if core.worktree is already set
    local current_worktree=$(git config --get core.worktree)

    if [ -z "$current_worktree" ]; then
        # Set core.worktree configuration
        git config --replace-all core.worktree "$HOME"
    fi

    # Launch Neovim
    nvim

    # After Neovim exits, restore original Git environment variables
    GIT_DIR="$original_git_dir"
    GIT_WORK_TREE="$original_git_work_tree"
    export GIT_DIR
    export GIT_WORK_TREE
}

zle -N hcd
bindkey -M emacs '\eD' hcd
bindkey -M vicmd '\eD' hcd
bindkey -M viins '\eD' hcd
