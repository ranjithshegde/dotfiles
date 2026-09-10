#!/bin/zsh

refile() {
    nvim -c "autocmd BufEnter * only" -c "lua require('orgmode').capture:open_template_by_shortcut('t')"
}

nvp() {
    cat /sys/bus/pci/devices/0000:01:00.0/power_state
}

nvs() {
    nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings
}

pacelist() {
    expac --timefmt='%Y-%m-%d %T' '%l\t%n\t:%w' | sort | grep -i 'explicit' | tail -n 200 | awk -F: '{print $1 $2 $3}' | nvim +Man!
}

paclist() {
    expac --timefmt='%Y-%m-%d %T' '%l\t%n\t:%w' | sort | tail -n 200 | awk -F: '{print $1 $2 $3}' | nvim +Man!
}

function pacdisowned() {
    local tmp_dir db fs
    tmp_dir=$(mktemp --directory)
    db=$tmp_dir/db
    fs=$tmp_dir/fs

    trap "rm -rf $tmp_dir" EXIT

    pacman -Qlq | sort -u >"$db"

    # fd --type d --exclude lost+found --full-path --print0 /etc /usr | sort -z >"$fs"
    find /etc /usr ! -name lost+found \
        \( -type d -printf '%p/\n' -o -print \) | sort >"$fs"

    comm -23 "$fs" "$db"

    rm -rf $tmp_dir
}

nopac() {
    SEARCH_DIRS="/etc:/usr:/opt"
    fd ${SEARCH_DIRS//:/ } | LC_ALL=C.UTF-8 pacman -Qqo - 2>&1 >&- >/dev/null | cut -d ' ' -f 5- >excess.txt
}

# OSC 133 (Prompt Marking)
function osc133_prompt() {
    printf '\033]133;A\033\\'
}
precmd_functions+=(osc133_prompt)
