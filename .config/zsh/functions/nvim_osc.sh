#!/bin/zsh

# OSC 133 (Prompt Marking)
function osc133_prompt() {
    printf '\033]133;A\033\\'
}
precmd_functions+=(osc133_prompt)
