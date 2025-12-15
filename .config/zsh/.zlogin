typeset -U PATH LIBRARY_PATH

# macOS-specific settings
if [[ "$OSTYPE" == "darwin*" ]]; then
    source $ZDOTDIR/boot_env/macos.zsh
    exit 0
fi

# Function to append library paths if not already included
append_lib() {
    if (( ! ${LIBRARY_PATH[(I)$1]} )); then
        LIBRARY_PATH+=("$1")
    fi
}

# Read library paths from configuration files and append to LIBRARY_PATH
for line in /etc/ld.so.conf.d/*.conf; do
    append_lib "$line"
done

# Clean up by unsetting the function
unset -f append_lib
export LIBRARY_PATH

# Laptop-specific settings
if [[ "${MACHINE_TYPE}" = "laptop" ]]; then
    source $ZDOTDIR/boot_env/laptop.zsh
fi


# Set SSH_AUTH_SOCK if not already set for this process
: ${SSH_AUTH_SOCK:="$(gpgconf --list-dirs agent-ssh-socket)"}
export SSH_AUTH_SOCK

# Set GPG_TTY to the current terminal
if tty -s; then
    export GPG_TTY=$(tty)
else
    # Attempt to find a terminal or fallback to a default
    if [ -n "$XDG_VTNR" ]; then
        export GPG_TTY="/dev/tty$XDG_VTNR"
    elif [ -n "$XDG_SESSION_ID" ]; then
        export GPG_TTY="/dev/tty$(loginctl show-session $XDG_SESSION_ID -p VTNr --value)"
    else
        export GPG_TTY="/dev/tty1" # Fallback to a default TTY
    fi
    echo "Fallback GPG_TTY: $GPG_TTY"
fi

# Ensure GPG_AGENT_INFO is available (legacy variable, usually not needed)
: ${GPG_AGENT_INFO:="$(gpgconf --list-dirs agent-ssh-socket)"}
export GPG_AGENT_INFO

gpg-connect-agent updatestartuptty /bye >/dev/null
gpgconf --launch gpg-agent

# Set platform-specific environment variables
export VK_LAYER_PATH="/usr/share/vulkan/explicit_layer.d/"

case "${XDG_SESSION_TYPE}" in
    wayland)
        source $ZDOTDIR/boot_env/proton.zsh
        export QT_QPA_PLATFORM='wayland'
        export TERMINAL=/usr/bin/ghostty
        export TERM=ghostty
        ;;
    *)
        export TERMINAL="/usr/local/bin/st"
        export TERM=st
        export SUDO_ASKPASS="/usr/local/bin/dpass"
        ;;
esac
