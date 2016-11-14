#! /bin/bash

DIR=~/dotfiles
FILES=(".vimrc" ".vim/colors/molokai.vim" ".bashrc" ".inputrc" ".screenrc" ".gitconfig" ".sshrc")

function required_binaries {
	for BINARY in "vim"
	do
		hash $BINARY 2>/dev/null || { echo >&2 "${BINARY} is not installed. Aborting."; exit 1; }
	done
}

function pre_copy {
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
	source="$1"; shift
	destination="$1/${source}"; shift
	source="${DIR}/${source}"
	echo "Symlinking $source to $destination..."
	ln -fs "$source" "$destination"
}


required_binaries
pre_copy

for FILE in "${FILES[@]}"
do
	copy "${FILE}" ~
done

post_copy
