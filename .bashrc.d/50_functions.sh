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

complete -cf sudo
complete -cf man
complete -F __start_kubectl k

. ~/.bashrc_local
