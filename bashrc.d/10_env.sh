#!/usr/bin/env bash

export TERM=screen-256color

if [ -z "$SSH_AUTH_SOCK" ] ; then
	eval `ssh-agent -s`
	ssh-add
fi

export BAT_PAGER='less -R'
export PAGER=most
export HISTSIZE=2000
export HISTCONTROL=ignoreboth:erasedups:ignorespace
export FZF_DEFAULT_COMMAND='fd --follow --exclude .git'
export GOPATH=$HOME/go

export LDFLAGS="-L/opt/local/lib/openssl-1.0/"
export CPPFLAGS="-I/opt/local/include/openssl"

# MacPorts's ports
PATH=/opt/local/bin:/opt/local/sbin:/opt/local/libexec/gnubin/:$PATH
# Cargo-installed binaries
PATH=$HOME/.cargo/bin:$PATH
# Golang's binaries
PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
PATH=$HOME/.local/bin:$PATH
# Personal scripts
PATH=$HOME/bin:$PATH
export PATH

# export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
	. /opt/local/etc/profile.d/bash_completion.sh
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
