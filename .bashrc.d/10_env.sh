#!/usr/bin/env bash

export TERM=screen-256color

if [ -z "$SSH_AUTH_SOCK" ] ; then
	eval `ssh-agent -s`
	ssh-add
fi

export EDITOR=nvim
export BAT_PAGER='less -R'
export PAGER=most
export HISTSIZE=2000
export HISTCONTROL=ignoreboth:erasedups:ignorespace
export FZF_DEFAULT_COMMAND='fd --follow --exclude .git'
export GOPATH=$HOME/go
export CARGO_INSTALL_ROOT=$HOME/.cargo

# export LDFLAGS="-L/opt/local/lib/openssl-1.0/"
export CFLAGS="-I/opt/local/include -I/opt/local/include/openssl"
export CPPFLAGS=$CFLAGS
export RUSTFLAGS="-L/opt/local/lib"

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
	. /opt/local/etc/profile.d/bash_completion.sh
fi

if [ -f $HOME/lib/azure-cli ]; then
	source $HOME/lib/azure-cli/az.completion
fi

#########################################################
#						PATH
#########################################################
if [ -f $HOME/google-cloud-sdk/path.bash.inc ]; then
	. $HOME/google-cloud-sdk/path.bash.inc
	. $HOME/google-cloud-sdk/completion.bash.inc
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Visual Studio Code's binaries
PATH=/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin:$PATH

# MacPorts's ports
PATH=/opt/local/bin:/opt/local/sbin:/opt/local/libexec/gnubin/:$PATH

# ASDF shims
. $HOME/.asdf/asdf.sh

# Krew
PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Cargo-installed binaries
PATH=$HOME/.cargo/bin:$PATH
# Golang's binaries
PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
PATH=$HOME/.local/bin:$PATH
# Personal scripts
PATH=$HOME/bin:$PATH

export PATH
