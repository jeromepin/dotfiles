#!/usr/bin/env bash

git_part () {
	if git rev-parse --is-inside-work-tree 2> /dev/null > /dev/null
	then
		git_branch="$(git symbolic-ref --short HEAD)"
		git_status="$(git status --porcelain --untracked-files=all)"
		git_untracked="$(echo "$git_status" | \grep -co '??')"

		if [ "$git_untracked" -gt 0 ]
		then
			# 31 = RED
			git_branch="$(printf "%b" "\033[31m${git_branch}\033[0m")"
		else
			git_modified="$(echo "$git_status" | \grep -co 'M')"
			if [ "$git_modified" -gt 0 ]
			then
				# 33 = ORANGE
				git_branch="$(printf "%b" "\033[33m${git_branch}\033[0m")"
			else
				git_up2date="$(echo "$git_status")"
				if [ "$git_up2date" = "" ]
				then
					# 32 = GREEN
					git_branch="$(printf "%b" "\033[32m${git_branch}\033[0m")"
				fi
			fi
		fi

		printf "at  %b %b" "$git_branch"
	fi
}

if [[ "$STY" ]]
then
	PROMPT_COMMAND='/bin/echo -ne "\033k$HOSTNAME\033\\"'
fi

PS1="\033[38;5;2m\u\033[0m at \033[33m\h\033[0m in \033[36m\w\033[0m \$(git_part)\n\[\033[38;5;2m\]❭❭\[$(tput sgr0)\] "

if [ -f /usr/local/share/kube-ps1/kube-ps1.sh ]
then
	source /usr/local/share/kube-ps1/kube-ps1.sh
	PS1='$(kube_ps1)'$PS1
fi

export PS1
