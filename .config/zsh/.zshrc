# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# The following lines were added by compinstall-----------------------------------------
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' max-errors 3 numeric
zstyle :compinstall filename "$ZDOTDIR/.zshrc"
# End of lines added by compinstall

# Lines configured by zsh-newuser-install------------------------------------------------
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep extendedglob notify
# End of lines configured by zsh-newuser-install

autoload -U bashcompinit
autoload -U colors && colors
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
_comp_options+=(globdots)

# Aliases--------------------------------------------------------------------------------

alias ls=lsd
alias python=python3
alias grep='grep --color=auto'
alias weather='curl wttr.in/"rotterdam"'
alias cat=bat
alias pd='/usr/bin/pdl'
alias nv-settings='nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings'
alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME"/yarn/config'
alias wget '--hsts-file="$XDG_CACHE_HOME"/wget-hsts'
alias config='/usr/bin/git --git-dir=/home/ranjith/Software/Workspaces/Repos/dotfiles --work-tree=/home/ranjith'
alias cvim='GIT_DIR=/home/ranjith/Software/Workspaces/Repos/dotfiles GIT_WORK_TREE=$HOME vim'
alias bs='browser-sync start --server --files "*.js, *.html, *.css"'
alias paclist="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n 100"
alias ydl='youtube-dl --external-downloader aria2c --external-downloader-args "-c -j 3 -x 3 -s 3 -k 1M"'

VISUAL=editor
export VISUAL
export EDITOR=editor

setopt correct

# Colours for Less pager-----------------------------------------------------------------
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Ranger change directory on exit-----------------------------------------------------------
ranger-cd() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
        cd -- "$chosen_dir"
    fi
    rm -f -- "$temp_file"
}

# FZF dotfiles -------------------------------------------------------------------------------
hcd() {
	local dir
	dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m --reverse --prompt='Enter Directory> ') && cd "$dir"
}

# SSH with GNUPG -----------------------------------------------------------------------------
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
	export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null
export GPG_AGENT_INFO


# Zplug-------------------------------------------------------------------------------

source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-completions"

zplug "MichaelAquilina/zsh-you-should-use"

zplug "zsh-users/zsh-history-substring-search"

zplug "zsh-users/zsh-autosuggestions"

zplug "zsh-users/zsh-syntax-highlighting"

zplug "agura-lex/find-the-command"

zplug 'romkatv/powerlevel10k', as:theme, depth:1

zplug "wfxr/forgit"

zplug load 

# Custom completion scripts ---------------------------------------------------------------------
source "$ZPLUG_HOME"/repos/agura-lex/find-the-command/usr/share/doc/find-the-command/ftc.zsh
source "$ZPLUG_HOME"/repos/zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

bashcompinit
eval "$(register-python-argcomplete pipx)"
eval "$(pip completion --zsh)"
eval "$(_PIO_COMPLETE=zsh_source pio)"

# Bindins --------------------------------------------------------------------------------------
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

[[ ! -f $ZDOTDIR/p10k.zsh ]] || source $ZDOTDIR/p10k.zsh
