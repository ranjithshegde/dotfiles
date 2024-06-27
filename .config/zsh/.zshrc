# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Completion configuration added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' max-errors 3 numeric
zstyle :compinstall filename "$ZDOTDIR/.zshrc"

# History configuration
HISTSIZE=1000
SAVEHIST=600
setopt HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS HIST_REDUCE_BLANKS HIST_VERIFY

# Miscellaneous options
setopt autocd beep extendedglob notify correct

# Bash compatibility and colors
autoload -U bashcompinit colors && colors
bashcompinit

# Completion system setup
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)

# Aliases
alias ls=lsd
alias cat=bat
alias ll='ls -la'
alias sxiv='nsxiv'
alias pss="paru -Ps"
alias python=python3
alias pu="paru -Syu"
alias pU="paru -Syyu"
alias pql="pacman -Ql"
alias pqs="pacman -Qs"
alias pqi="pacman -Qii"
alias ns="nordvpn status"
alias nc="nordvpn connect"
alias PG="projectGenerator"
alias CM="compiledb -n make"
alias nd="nordvpn disconnect"
alias pd='/usr/local/bin/pdl'
alias grep='grep --color=auto'
alias weather='curl wttr.in/hague'
alias rfetch='rsfetch -PdehHklrNstU@'
alias rocks='sudo luarocks --lua-version 5.1'
alias wget='wget --hsts-file="${XDG_CACHE_HOME:-$HOME/.cache}/wget-hsts"'
alias yarn='yarn --use-yarnrc "${XDG_CONFIG_HOME:-$HOME/.config}/yarn/config"'
alias config='/usr/bin/git --git-dir=$WORKSPACE/Repos/dotfiles --work-tree=$HOME'
alias systat='sudo systemctl status'
alias systart='sudo systemctl start'
alias systop='sudo systemctl stop'
alias sysre='sudo systemctl restart'
alias usystat='systemctl --user status'
alias usystart='systemctl --user start'
alias usystop='systemctl --user stop'
alias usysre='systemctl --user restart'
alias srest='systemctl suspend'

if [[ "${MACHINE_TYPE}" = "laptop" ]]; then
        alias cvim='GIT_DIR=$WORKSPACE/Repos/dotfiles GIT_WORK_TREE=$HOME vim'
        alias cgit='GIT_DIR=$WORKSPACE/Repos/dotfiles GIT_WORK_TREE=$HOME git'
    else
        alias cvim='GIT_DIR="${HOME}/Repositories/Maintained/dotbare" GIT_WORK_TREE="${HOME}" nvim'
        alias cgit='GIT_DIR="${HOME}/Repositories/Maintained/dotbare" GIT_WORK_TREE="${HOME}" git'
fi

# Zplug configuration
source "${ZPLUG_HOME}/init.zsh"
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-completions"
zplug "MichaelAquilina/zsh-you-should-use"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "agura-lex/find-the-command"
zplug 'romkatv/powerlevel10k', as:theme, depth:1
zplug "wfxr/forgit"
zplug "lincheney/fzf-tab-completion"
zplug load

# Custom completion scripts
source "${ZPLUG_HOME}/repos/agura-lex/find-the-command/usr/share/doc/find-the-command/ftc.zsh"
source "${ZPLUG_HOME}/repos/zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh"
source "${ZPLUG_HOME}/repos/lincheney/fzf-tab-completion/zsh/fzf-zsh-completion.sh"
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
eval "$(register-python-argcomplete pipx)"
eval "$(_PIO_COMPLETE=zsh_source pio)"
eval "$(zoxide init zsh)"
compdef _dotnet_zsh_complete dotnet

# Key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^I' fzf_completion
bindkey '^[[Z' fzf_completion

# Source Powerlevel10k configuration if it exists
[[ ! -f $ZDOTDIR/p10k.zsh ]] || source $ZDOTDIR/p10k.zsh
