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
    python3 -m http.server 8000 --bind 0.0.0.0
}

complete -cf sudo
complete -cf man
complete -F __start_kubectl k

. ~/.bashrc_local
