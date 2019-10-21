#! /bin/bash

export TERM=screen-256color

git_part () {
	git rev-parse --is-inside-work-tree 2> /dev/null > /dev/null
	if [ $? -eq 0 ]; then
		remote_pattern="# Your branch is (.*) of"

		git_branch="$(git symbolic-ref --short HEAD)"
		git_status="$(git status --porcelain --untracked-files=all)"
		git_status_full="$(git status)"
		git_modified="$(echo "$git_status" | \grep -co 'M')"
		git_untracked="$(echo "$git_status" | \grep -co '??')"
		git_up2date="$(echo "$git_status")"
		git_branch_ahead="$(echo "$git_status_full" | \grep -c 'ahead')"
		git_branch_behind="$(echo "$git_status_full" | \grep -c 'behind')"

		if [[ "$git_branch_ahead" = 1 ]]; then
			git_remote="↑"
		elif [[ "$git_branch_behind" = 1 ]]; then
			git_remote="↓"
		fi

		if [ "$git_untracked" -gt 0 ]; then
			git_branch="$(printf "%b" "\033[31m${git_branch}\033[0m")"
		elif [ "$git_modified" -gt 0 ]; then
			git_branch="$(printf "%b" "\033[33m${git_branch}\033[0m")"
		elif [ "$git_up2date" = "" ]; then
			git_branch="$(printf "%b" "\033[32m${git_branch}\033[0m")"
		fi

		printf "at  %b %b" "$git_branch" "$git_remote"
	fi
}

export PS1="\033[38;5;2m\u\033[0m at \033[33m\h\033[0m in \033[36m\w\033[0m \$(git_part)\n\[\033[38;5;2m\]❭❭\[$(tput sgr0)\] "

if [[ "$STY" ]]
then
	PROMPT_COMMAND='/bin/echo -ne "\033k$HOSTNAME\033\\"'
fi

if [ -z "$SSH_AUTH_SOCK" ] ; then
	eval `ssh-agent -s`
	ssh-add
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
shopt -s extglob
shopt -s histappend
shopt -s dirspell

if hash exa 2>/dev/null; then
    alias ls="exa"
    alias la="ls -la"
else
alias ls="ls --color=auto"
    alias la="ls -lA"
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
alias grep='ack -s'
alias s="sshrc -A -l root"

export PATH=~/bin:$PATH
# added by travis gem
[ -f /home/jerome/.travis/travis.sh ] && source /home/jerome/.travis/travis.sh
[ -f ~/.fzf.bash ] && source ~/.fzf.bash