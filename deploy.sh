#! /bin/bash

FILES=('.bashrc', '.inputrc', 'screenrc', '.vim', '.vimrc')

# If we're on OS X
if [ "$(uname)" == "Darwin" ]
then
	FILES=("${FILES[@]}", '.bashrc_bsd')
else
	FILES=("${FILES[@]}", '.bashrc_lin')
fi

for file in "${FILE[@]}"
do
	ln -sf "~/dotfiles/$file" ~
done
