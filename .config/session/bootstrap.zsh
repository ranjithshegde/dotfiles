typeset -U PATH LIBRARY_PATH

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

# Set SSH_AUTH_SOCK if not already set for this process
: ${SSH_AUTH_SOCK:="$(gpgconf --list-dirs agent-ssh-socket)"}
export SSH_AUTH_SOCK

if [[ "${XDG_CURRENT_DESKTOP}" != *"KDE"* ]]; then 
    [[ -x /usr/lib/pam_kwallet_init ]] && /usr/lib/pam_kwallet_init &
fi

systemctl --user set-environment \
    LIBRARY_PATH="$LIBRARY_PATH" \
    SSH_AUTH_SOCK="$SSH_AUTH_SOCK" \
