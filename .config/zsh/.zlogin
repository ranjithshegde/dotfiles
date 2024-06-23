#USE VCPKG HEADERS
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/opt/vcpkg/installed/x64-linux/include/
export C_INCLUDE_PATH=$C_INCLUDE_PATH:/opt/vcpkg/installed/x64-linux/include/

# Function to append library paths if not already included
append_lib() {
	case ":$LIBRARY_PATH:" in
	*:"$1":*) ;; # If already included, do nothing
	*)
		LIBRARY_PATH="${LIBRARY_PATH:+$LIBRARY_PATH:}$1"
		;;
	esac
}

# Read library paths from configuration files and append to LIBRARY_PATH
for line in $(cat /etc/ld.so.conf.d/*.conf); do
	append_lib "$line"
done

# Clean up by unsetting the function
unset -f append_lib
export LIBRARY_PATH

if [[ "${MACHINE_TYPE}" = "laptop" ]]; then
	# SSH with GNUPG -----------------------------------------------------------------------------
	unset SSH_AGENT_PID

	# Set SSH_AUTH_SOCK if not already set for this process
	if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
		SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
		export SSH_AUTH_SOCK
	fi
	# Disable Bluetooth by default
	rfkill block bluetooth
else
    SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
    export SSH_AUTH_SOCK
fi

# Set GPG_TTY to the current terminal and update GPG agent's tty
GPG_TTY=$(tty)
export GPG_TTY
gpg-connect-agent updatestartuptty /bye >/dev/null

# Ensure GPG_AGENT_INFO is available (legacy variable, usually not needed)
export GPG_AGENT_INFO

# Set platform-specific environment variables
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
