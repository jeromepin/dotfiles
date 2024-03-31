#!/usr/bin/env bash

b64e () {
    printf "$1" | base64
    printf ""
}

b64d () {
    printf "$1" | base64 --decode
    printf "\n"
}

simple_http_server () {
    python3 -m http.server 8000 --bind 127.0.0.1
}

# broot --print-shell-function bash
function br {
    local cmd cmd_file code
    cmd_file=$(mktemp)
    if broot --outcmd "$cmd_file" "$@"; then
        cmd=$(<"$cmd_file")
        rm -f "$cmd_file"
        eval "$cmd"
    else
        code=$?
        rm -f "$cmd_file"
        return "$code"
    fi
}

# From https://github.com/Sanix-Darker/dotfiles/commit/1c606b22e6ab2dd62638ff840e042eb394dae2b2
# GIT_FZF_DEFAULT_OPTS="
# 	$FZF_DEFAULT_OPTS
# 	--ansi
# 	--reverse
# 	--height=100%
# 	--bind shift-down:preview-down
# 	--bind shift-up:preview-up
# 	--bind pgdn:preview-page-down
# 	--bind pgup:preview-page-up
# 	--bind q:abort
# 	$GIT_FZF_DEFAULT_OPTS
# "

# git-fuzzy-diff ()
# {
# 	PREVIEW_PAGER="less --tabs=4 -Rc"
# 	ENTER_PAGER=${PREVIEW_PAGER}
# 	if [ -x "$(command -v delta)" ]; then
# 		PREVIEW_PAGER="delta | ${PREVIEW_PAGER}"
# 		ENTER_PAGER="delta | sed -e '1,4d' | ${ENTER_PAGER}"
# 	fi

# 	# Don't just diff the selected file alone, get related files first using
# 	# '--name-status -R' in order to include moves and renames in the diff.
# 	# See for reference: https://stackoverflow.com/q/71268388/3018229
# 	PREVIEW_COMMAND='git diff --color=always '$@' -- \
# 		$(echo $(git diff --name-status -R '$@' | grep {}) | cut -d" " -f 2-) \
# 		| '$PREVIEW_PAGER

# 	# Show additional context compared to preview
# 	ENTER_COMMAND='git diff --color=always '$@' -U10000 -- \
# 		$(echo $(git diff --name-status -R '$@' | grep {}) | cut -d" " -f 2-) \
# 		| '$ENTER_PAGER

# 	git diff --name-only $@ | \
# 		fzf ${GIT_FZF_DEFAULT_OPTS} --exit-0 --preview "${PREVIEW_COMMAND}" \
# 		--preview-window=top:85% --bind "enter:execute:${ENTER_COMMAND}"
# }

# git-fuzzy-log ()
# {
# 	PREVIEW_COMMAND='f() {
# 		set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}")
# 		[ $# -eq 0 ] || (
# 			git show --no-patch --color=always $1
# 			echo
# 			git show --stat --format="" --color=always $1 |
# 			while read line; do
# 				tput dim
# 				echo " $line" | sed "s/\x1B\[m/\x1B\[2m/g"
# 				tput sgr0
# 			done |
# 			tac | sed "1 a \ " | tac
# 		)
# 	}; f {}'

# 	ENTER_COMMAND='(grep -o "[a-f0-9]\{7\}" | head -1 |
# 		xargs -I % bash -ic "git-fuzzy-diff %^1 %") <<- "FZF-EOF"
# 		{}
# 		FZF-EOF'

# 	git log --graph --color=always --format="%C(auto)%h %s%d " | \
# 		fzf ${GIT_FZF_DEFAULT_OPTS} --no-sort --tiebreak=index \
# 		--preview "${PREVIEW_COMMAND}" --preview-window=top:15 \
# 		--bind "enter:execute:${ENTER_COMMAND}"
# }

complete -cf sudo
complete -cf man
complete -o default -F __start_kubectl k

. ~/.bashrc_local
