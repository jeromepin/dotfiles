#! /bin/bash

dir=~/dotfiles

function copyFile {
	source="$1"; shift
	destination="$1/$source"; shift
	source="$dir/$source"
	echo "Symlinking $source to $destination..."
	ln -fs "$source" "$destination"
}

for file in ".vimrc" ".bashrc" ".inputrc" ".screenrc" ".gitconfig" ".sshrc"
do
	copyFile $file ~
done

copyFile .vim/colors/molokai.vim ~/.vim/colors/molokai.vim
