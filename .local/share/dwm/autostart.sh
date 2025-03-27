#!/bin/sh

dbus-update-activation-environment --all

if [[ "${MACHINE_TYPE}" = "laptop" ]]; then
    xset r rate 200 30 &
    xrandr --dpi 96 &
    nm-applet &
fi

nitrogen --force-setter=xinerama --restore &
picom &
xss-lock --notifier "$HOME/.local/bin/scripts/steam_sleep" -- "$HOME/.local/bin/scripts/dwm_lock" &
