#!/usr/bin/env bash

export TERM=screen-256color

if [ -z "$SSH_AUTH_SOCK" ] ; then
	eval `ssh-agent -s`
	ssh-add
fi

export EDITOR=nvim
export BAT_PAGER='less -R'
export PAGER=less
export LESS='--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'
# Set colors for less. Borrowed from https://wiki.archlinux.org/index.php/Color_output_in_console#less .
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export HISTSIZE=2000
export HISTCONTROL=ignoreboth:erasedups:ignorespace
export FZF_DEFAULT_COMMAND='fd --follow --exclude .git'
export GOPATH=$HOME/go
export CARGO_INSTALL_ROOT=$HOME/.cargo


source /opt/local/etc/profile.d/bash_completion.sh

source /opt/local/share/fzf/shell/key-bindings.bash

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

# Visual Studio Code's binaries
PATH=/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin:$PATH

# MacPorts's ports
PATH=/opt/local/bin:/opt/local/sbin:/opt/local/libexec/gnubin/:$PATH
# Homebrew's binaries
PATH=/usr/local/bin:$PATH

# ASDF shims
. $HOME/.asdf/asdf.sh

# Krew
PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Cargo-installed binaries
PATH=$HOME/.cargo/bin:$PATH
# Golang's binaries
PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
# Manually installed binaries
PATH=$HOME/.local/bin:$PATH
# Personal scripts
PATH=$HOME/bin:$PATH

export PATH

#########################################################
#					COMPILATION FLAGS
#########################################################
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib -L/usr/local/opt/bzip2/lib -L/usr/local/opt/readline/lib -L/usr/local/opt/zlib/lib"
export CFLAGS="-I/usr/local/opt/openssl@1.1/include -I/usr/local/opt/bzip2/include -I/usr/local/opt/readline/include -I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include" 
export CPPFLAGS=$CFLAGS
export RUSTFLAGS="-L/opt/local/lib"
