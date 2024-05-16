#!/usr/bin/env bash

ssh-add --apple-use-keychain

export TERM=screen-256color
export EDITOR="nvim"
export BAT_PAGER='less -R'
export PAGER=most
export HISTSIZE=2000
export HISTCONTROL=ignoreboth:erasedups:ignorespace
export FZF_DEFAULT_COMMAND='fd --follow --exclude .git'
export GOPATH=$HOME/go

# Homebrew
PATH=/opt/homebrew/bin:$PATH
# Cargo-installed binaries
PATH=$HOME/.cargo/bin:$PATH
# Personal scripts
PATH=$HOME/bin:$PATH

export PATH

eval "$(fzf --bash)"
