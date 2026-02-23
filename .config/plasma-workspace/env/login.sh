# Laptop-specific settings
if [[ "${MACHINE_TYPE}" = "laptop" ]]; then
    source "$ZDOTDIR"/boot_env/laptop.zsh
fi

source "$ZDOTDIR"/boot_env/proton.zsh
export TERMINAL=/usr/bin/ghostty
export TERM=ghostty
