#!/bin/zsh

if [[ "$(uname -m)" == "arm64" ]]; then
    path=("/opt/local/bin" "/opt/local/sbin" $path)
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export TERM=xterm-256color
export TERMINAL=/opt/homebrew/bin/ghostty
