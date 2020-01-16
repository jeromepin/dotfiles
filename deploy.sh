#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ -n $1 ]]
then
	DIR=$1
fi

FILES=(".bashrc" ".config/flake8" ".gitconfig" ".inputrc" ".sshrc" ".tmux.conf" ".tudurc" ".vimrc" ".vim/colors/molokai.vim")

function ensure_binaries_are_installed {
	for BINARY in "vim" "asdf"
	do
		hash $BINARY 2>/dev/null || { echo >&2 "${BINARY} is not installed. Aborting."; exit 1; }
	done
}

function prerequisites {
	mkdir -p ~/.vim/colors
	mkdir -p ~/.vim/bundle

	if [ ! -d ~/.vim/bundle/Vundle.vim ]
	then
		git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	fi	
}

function post_copy {
	vim +PluginInstall +qall
}

function copy {
	destination="$2/${source}"
	source="${DIR}/$1"
	echo "Symlinking $source to $destination..."
	ln -fs "$source" "$destination"
}



ensure_binaries_are_installed
prerequisites

for FILE in "${FILES[@]}"
do
	copy "${FILE}" ~
done

touch ~/.bashrc_local && echo "Creating un-git-ed ~/.bashrc_local..."

post_copy
