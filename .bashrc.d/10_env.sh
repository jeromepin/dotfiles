#!/usr/bin/env bash

export TERM=screen-256color

if [ -z "$SSH_AUTH_SOCK" ] ; then
	eval `ssh-agent -s`
	ssh-add
fi

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
