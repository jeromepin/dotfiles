# If we're on OS X
if [ "$(uname)" == "Darwin" ]
then
	export PATH=$PATH:/opt/homebrew-cask/Caskroom
	alias cask="brew cask"
else
	# Allow to change directory without 'cd' word, just path
	shopt -s autocd
	shopt -s dirspell
fi


# Enable autocomplete for sudo and man command
complete -cf sudo
complete -cf man

shopt -s cdspell
shopt -s nocaseglob
shopt -s checkhash
shopt -s checkwinsize
shopt -s cmdhist
shopt -s hostcomplete
shopt -s no_empty_cmd_completion
shopt -s progcomp

# Prevent to append same command to history
export HISTCONTROL=ignoredups

# PS1 (prompt) setup
PS1="\[\e[00;37m\][ \[\e[0m\]\[\e[00;31m\]\u\[\e[0m\]\[\e[00;36m\]@\h\[\e[0m\]\[\e[00;37m\] ] [ \[\e[0m\]\[\e[00;36m\]\w\[\e[0m\]\[\e[00;37m\] ]\n\[\e[0m\]\[\e[00;31m\]>>\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

# Aliases
alias ls="ls -G"
alias ll="ls -l"
alias la="ls -la"
alias grep="grep --color=auto"
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias tree="tree --dirsfirst -aAC"

# Update PATH for local binaries
export PATH=$PATH:/usr/local/bin
