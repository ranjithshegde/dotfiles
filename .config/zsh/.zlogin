typeset -U PATH LIBRARY_PATH

# macOS-specific settings
if [[ "$OSTYPE" == "darwin*" ]]; then
    source "$ZDOTDIR"/boot_env/macos.zsh
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
    source "$ZDOTDIR"/boot_env/laptop.zsh
fi

# Set SSH_AUTH_SOCK if not already set for this process
: ${SSH_AUTH_SOCK:="$(gpgconf --list-dirs agent-ssh-socket)"}
export SSH_AUTH_SOCK
# Reload gpg-agent TTY settings for ssh-agent forwarding
gpg-connect-agent updatestartuptty /bye >/dev/null

case "${XDG_SESSION_TYPE}" in
    wayland)
        source "$ZDOTDIR"/boot_env/proton.zsh
        export TERMINAL=/usr/bin/ghostty
        export TERM=ghostty
        ;;
    *)
        export TERMINAL="/usr/local/bin/st"
        export TERM=st
        export SUDO_ASKPASS="/usr/local/bin/dpass"
        ;;
esac

if [[ "${XDG_CURRENT_DESKTOP}" != *"KDE"* ]]; then 
    [[ -x /usr/lib/pam_kwallet_init ]] && /usr/lib/pam_kwallet_init &
fi
