#!/usr/bin/env bash

alias ls="eza"
alias la="ls -la"

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
