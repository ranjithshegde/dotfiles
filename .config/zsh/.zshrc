# ==============================================================================
#                   Zinit Configuration
# ==============================================================================
if [[ ! -f "$ZINIT_HOME/bin/zinit.zsh" ]]; then
    print "zinit not found. Installing..."
    mkdir -p "$ZINIT_HOME" && command chmod g-rwX "$ZINIT_HOME"
    git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME/bin"
fi
source "$ZINIT_HOME/bin/zinit.zsh"

# ==============================================================================
#                   Shell Options & Basic Configuration
# ==============================================================================
# Core shell options
setopt autocd extendedglob notify correct
unsetopt beep

# Load colors for essential tools
autoload colors && colors

# History configuration
HISTSIZE=10000
SAVEHIST=1000
setopt hist_reduce_blanks hist_verify sharehistory
setopt hist_ignore_space hist_expire_dups_first hist_ignore_dups hist_ignore_all_dups hist_find_no_dups hist_save_no_dups

# ==============================================================================
#                   Default Completion Setup
# ==============================================================================
# Load completion system modules
zmodload -i zsh/complist
_comp_options+=(globdots)

# Determine dump file location
zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"

# Basic completion styles
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' max-errors 3 numeric
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:warnings' format '%F{red}%B-- No matches found --%b%f'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*:descriptions' format '%B%F{blue}%d%f%b'

# ==============================================================================
#                   Core Plugins
# ==============================================================================

# Prompt
zinit ice lucid \
    atclone"starship init zsh > init.zsh; starship completions zsh > _starship" \
    atpull"%atclone" src"init.zsh"
zinit light zdharma-continuum/null

# Load zoxide early since it's frequently used
unalias zi
zinit ice wait:0 lucid atinit"export _ZO_FZF_OPTS='--height=40%'"
zinit snippet OMZP::zoxide

# The big Two
zinit wait:0 lucid for \
    zdharma-continuum/fast-syntax-highlighting \
    MichaelAquilina/zsh-you-should-use \
    hlissner/zsh-autopair

# ==============================================================================
#                   Utility Plugins
# ==============================================================================
# History
zinit ice wait:1 lucid for \
    atload"bindkey '^[[A' history-substring-search-up; bindkey '^[[B' history-substring-search-down" \
    zsh-users/zsh-history-substring-search

# Multiword History
zinit ice wait:1 lucid
zinit load zdharma-continuum/history-search-multi-word

zstyle ":history-search-multi-word" highlight-color "fg=yellow,bold"
zstyle ":history-search-multi-word" page-size "8"
zstyle ":plugin:history-search-multi-word" active "underline"
zstyle ":plugin:history-search-multi-word" check-paths "yes"
zstyle ":plugin:history-search-multi-word" clear-on-cancel "no"
zstyle ":plugin:history-search-multi-word" synhl "yes"
zstyle :plugin:history-search-multi-word reset-prompt-protect 1

# Find the command
zinit ice wait lucid for \
    atload"source ${ZINIT_HOME}/plugins/agura-lex---find-the-command/usr/share/doc/find-the-command/ftc.zsh" \
    agura-lex/find-the-command

# Git
zinit ice wait lucid
zinit load wfxr/forgit

# ==============================================================================
#                   External snippets
# ==============================================================================
zinit wait:1 lucid for \
    OMZP::sudo \
    OMZP::systemd

# ==============================================================================
#                   Completion plugins
# ==============================================================================
zinit ice wait'0' lucid for PZTM::completion

# Load completion system
zinit for \
    atload"zicompinit; zicdreplay" \
    blockf \
    lucid \
    wait \
    zsh-users/zsh-completions

# Load autosuggestions separately with its specific hook
zinit wait:0 lucid \
    atload"_zsh_autosuggest_start" \
    for zsh-users/zsh-autosuggestions

# ==============================================================================
#                   FZF Integration
# ==============================================================================
# FZF Tab (load after completions)
zinit wait"0" lucid for Aloxaf/fzf-tab

# FZF Tab styles (after loading fzf-tab)
zinit ice wait:0 lucid
zinit snippet OMZP::fzf
# FZF-tab specific styles
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' show-group brief

# ==============================================================================
#                   Aliases
# ==============================================================================
# File Management
alias ls=lsd
alias cat=bat
alias lf=yazi
alias sxiv=nsxiv

# Development
alias python=python3
alias PG=projectGenerator

# Common command aliases with flags
alias CM="compiledb -n make"
alias grep='grep --color=auto'
alias rocks='sudo luarocks --lua-version 5.1'

# Git
alias config='/usr/bin/git --git-dir=$WORKSPACE/Repos/dotfiles --work-tree=$HOME'
alias cgit='GIT_DIR="${HOME}/Repositories/Maintained/dotbare" GIT_WORK_TREE="${HOME}" git'
alias cvim='GIT_DIR="${HOME}/Repositories/Maintained/dotbare" GIT_WORK_TREE="${HOME}" nvim'

# Package Management
alias pss="paru -Ps"
alias pu="paru -Syu"
alias pU="paru -Syyu"
alias pql="pacman -Ql"
alias pqs="pacman -Qs"
alias pqi="pacman -Qii"

# VPN
alias ns="nordvpn status"
alias nc="nordvpn connect"
alias nd="nordvpn disconnect"

# XDG Compliance
alias wget='wget --hsts-file="${XDG_CACHE_HOME:-$HOME/.cache}/wget-hsts"'
alias yarn='yarn --use-yarnrc "${XDG_CONFIG_HOME:-$HOME/.config}/yarn/config"'

# ==============================================================================
#                   Load Functions
# ==============================================================================
for script in "$ZDOTDIR/functions/"*.sh; do
    source "$script"
done

precmd() {
    precmd() {
        echo
    }
}
