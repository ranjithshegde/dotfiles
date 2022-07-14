# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# The following lines were added by compinstall-----------------------------------------
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' max-errors 3 numeric
zstyle :compinstall filename "$ZDOTDIR/.zshrc"
# End of lines added by compinstall

HISTSIZE=2000
SAVEHIST=2000
setopt autocd beep extendedglob notify
setopt correct

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

zplug "lincheney/fzf-tab-completion"

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
source /opt/vcpkg/scripts/vcpkg_completion.zsh

# Bindins --------------------------------------------------------------------------------------
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


source "$ZPLUG_HOME"/repos/lincheney/fzf-tab-completion/zsh/fzf-zsh-completion.sh
bindkey '^I' fzf_completion

[[ ! -f $ZDOTDIR/p10k.zsh ]] || source $ZDOTDIR/p10k.zsh
