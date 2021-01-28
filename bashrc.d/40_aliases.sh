#!/usr/bin/env bash

if hash exa 2>/dev/null; then
    alias ls="exa"
    alias la="ls -la"
else
    if [ "$(uname)" == "Darwin" ]; then
        alias ls="ls -G"
    else
        alias ls="ls --color=auto"
    fi
    alias la="ls -lA"
fi

if hash gsed 2>/dev/null; then
    alias sed="gsed"
fi

alias sl="ls"
alias ll="ls -l"
alias rm="rm -f"
alias grep="grep --color=auto"
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias tree="tree --dirsfirst -aAC"
alias less="less -r"
alias apt="sudo apt"
alias grep='rg'
alias k="kubectl"
alias s="sshrc -A -l root"
alias vim="nvim"
alias pip="python3 -m pip"
alias delta="delta --side-by-side --line-numbers"
