# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi



# The following lines were added by compinstall-----------------------------------------

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' max-errors 3 numeric
zstyle :compinstall filename $ZDOTDIR/.zshrc

# End of lines added by compinstall

# Lines configured by zsh-newuser-install------------------------------------------------
HISTFILE="$XDG_DATA_HOME"/zsh/history
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep extendedglob notify
# End of lines configured by zsh-newuser-install


autoload -U colors && colors
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
_comp_options+=(globdots)
export HISTFILE="$XDG_DATA_HOME"/zsh/history


# Aliases--------------------------------------------------------------------------------

# alias ls='ls --color=auto'
alias ls=lsd
alias python=python3
alias grep='grep --color=auto'
alias weather='curl wttr.in/"rotterdam"'
alias cat=bat
alias pd='/usr/bin/pdl'
# alias bbook='abook --config "$XDG_CONFIG_HOME"/abook/abookrc --datafile "$XDG_DATA_HOME"/abook/addressbook'
alias nv-settings='nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings'
alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME"/yarn/config'
alias wget '--hsts-file="$XDG_CACHE_HOME"/wget-hsts'

alias config='/usr/bin/git --git-dir=/home/ranjith/Software/Workspaces/Repos/dotfiles --work-tree=/home/ranjith'
alias cvim='GIT_DIR=/home/ranjith/Software/Workspaces/Repos/dotfiles GIT_WORK_TREE=$HOME vim'
alias bs='browser-sync start --server --files "*.js, *.html, *.css"'
alias paclist="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n 100"

VISUAL=editor
# VISUAL='nvr -s --nostart --remote-tab-wait +"set bufhidden=delete"'
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


# Ranger change directory on exit-------------------------------------------------------

ranger-cd() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
        cd -- "$chosen_dir"
    fi
    rm -f -- "$temp_file"
}

hcd() {
	local dir
	dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m --reverse --prompt='Enter Directory> ') && cd "$dir"
}

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


source "$ZPLUG_HOME"/repos/agura-lex/find-the-command/usr/share/doc/find-the-command/ftc.zsh
source "$ZPLUG_HOME"/repos/zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# source "$ZDOTDIR"/functions/status.sh

eval "$(pip completion --zsh)"


bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# source "/usr/lib/emsdk/emsdk_env.sh"

# # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.config/zsh/p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $ZDOTDIR/p10k.zsh ]] || source $ZDOTDIR/p10k.zsh
