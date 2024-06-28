function b64e
    printf "$1" | base64
    printf ""
end

function b64d
    printf "$1" | base64 --decode
    printf "\n"
end
