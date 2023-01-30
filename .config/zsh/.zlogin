#USE VCPKG HEADERS
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/opt/vcpkg/installed/x64-linux/include/
export C_INCLUDE_PATH=$C_INCLUDE_PATH:/opt/vcpkg/installed/x64-linux/include/

append_lib() {
    case ":$LIBRARY_PATH:" in
        *:"$1":*) ;;

        *)
            LIBRARY_PATH="${LIBRARY_PATH:+$LIBRARY_PATH:}$1"
            ;;
    esac
}

for line in $(cat /etc/ld.so.conf.d/*.conf); do
    append_lib "$line"
done

unset -f append_lib
export LIBRARY_PATH

# SSH with GNUPG -----------------------------------------------------------------------------
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    export SSH_AUTH_SOCK
fi

GPG_TTY=$(tty)
export GPG_TTY
gpg-connect-agent updatestartuptty /bye >/dev/null
export GPG_AGENT_INFO


if [[ ${XDG_SESSION_TYPE} == "wayland" ]]; then
    export QT_QPA_PLATFORM='wayland'
else
    xset r rate 200 30
fi

# Run these only if X is running
if [[ ${DISPLAY} ]]; then
    if [[ ${DESKTOP_SESSION} == "dwm" ]]; then
        systemctl --user start redshift.service
        xrandr --dpi 96 &
        nitrogen --force-setter=xinerama --restore &
        picom &
        nm-applet &
    fi
fi
