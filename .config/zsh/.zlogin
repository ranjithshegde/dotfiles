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
	# Unset Forward key
	xmodmap -e 'keysym 0xff53 = NoSymbol'

	# SSH with GNUPG -----------------------------------------------------------------------------
	unset SSH_AGENT_PID

	# Set SSH_AUTH_SOCK if not already set for this process
	if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
		SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
		export SSH_AUTH_SOCK
	fi
	# Disable Bluetooth by default
	rfkill block bluetooth
	export OPENCV_OPENCL_DEVICE="NVIDIA:GPU:0"
else
	SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
	export SSH_AUTH_SOCK
fi

# Set GPG_TTY to the current terminal
if tty -s; then
	GPG_TTY=$(tty)
	export GPG_TTY
else
	# Attempt to find a terminal or fallback to a default
	if [ -n "$XDG_VTNR" ]; then
		GPG_TTY="/dev/tty$XDG_VTNR"
	elif [ -n "$XDG_SESSION_ID" ]; then
		GPG_TTY="/dev/tty$(loginctl show-session $XDG_SESSION_ID -p VTNr --value)"
	else
		GPG_TTY="/dev/tty1" # Fallback to a default TTY
	fi
	export GPG_TTY
	echo "Fallback GPG_TTY: $GPG_TTY"
fi

# Ensure GPG_AGENT_INFO is available (legacy variable, usually not needed)
if [ -z "$GPG_AGENT_INFO" ]; then
	GPG_AGENT_INFO=$(gpgconf --list-dirs agent-socket)
	export GPG_AGENT_INFO
fi

gpg-connect-agent updatestartuptty /bye >/dev/null

# Set platform-specific environment variables
if [[ ${XDG_SESSION_TYPE} == "wayland" ]]; then
	export QT_QPA_PLATFORM='wayland'
fi

# Run these only if X is running
if [[ ${DISPLAY} ]]; then
	if [[ ${DESKTOP_SESSION} == "dwm" ]]; then
		if [[ "${MACHINE_TYPE}" = "laptop" ]]; then
			xset r rate 200 30 &
			xrandr --dpi 96 &
			nm-applet &
		fi

		systemctl --user start redshift.service
		nitrogen --force-setter=xinerama --restore &
		picom &
		# xautolock -time 5 -locker "$HOME/.local/bin/scripts/daver" &
		xss-lock --notifier "$HOME/.local/bin/scripts/steam_sleep" -- "$HOME/.local/bin/scripts/daver" &

	elif [[ ${DESKTOP_SESSION== 'sway'} ]]; then
		export XDG_CURRENT_DESKTOP='sway'
		export WLR_RENDERER='vulkan'
		# export GBM_BACKEND='amdgpu-drm'
	fi
fi
