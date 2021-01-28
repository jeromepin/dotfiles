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
	mkdir -p ~/.bashrc.d
	mkdir -p ~/.vim/colors
	mkdir -p ~/.vim/bundle
}

function copy {
	source="${DIR}/$1"
	destination="$2"
	echo "Symlinking $source to $destination..."
	ln -fs "$source" "$destination"
}

function copy_bashrc_parts {
	for file in bashrc.d/*.sh
	do
		copy $file ~/.bashrc.d/
	done
}

function copy_vscode_settings {
	if [ -d ${HOME}/Library/Application\ Support/Code ]
	then
		copy vscode/settings.json ${HOME}/Library/Application\ Support/Code/User/settings.json
		copy vscode/keybindings.json ${HOME}/Library/Application\ Support/Code/User/keybindings.json
		copy vscode/snippets ${HOME}/Library/Application\ Support/Code/User/snippets
	fi
	if [ -d ${HOME}/Library/Application\ Support/Code\ \~\ Insiders ]
	then
		copy vscode/settings.json ${HOME}/Library/Application\ Support/Code/User/settings.json
		copy vscode/keybindings.json ${HOME}/Library/Application\ Support/Code/User/keybindings.json
		copy vscode/snippets ${HOME}/Library/Application\ Support/Code/User/snippets
	fi
}

function copy_custom_scripts {
	mkdir -p ~/bin
	for FILE in bin/*
	do
		copy $FILE ~/bin
	done
	git clone https://github.com/bigH/git-fuzzy.git ~/bin/git-fuzzy-dir
    ln -s ~/bin/git-fuzzy-dir/bin/git-fuzzy ~/bin/git-fuzzy
	# patch -d ~/bin/git-fuzzy < git-fuzzy-previous-commits-in-status.patch
}

# function post_copy {}

function asdf_install_enable_version {
    asdf install $1 $2
    asdf global $1 $2
}

function asdf_setup {
    asdf plugin add fzf https://github.com/jeromepin/asdf-fzf

	for BINARY in "fd" "neovim" "nodejs" "python" "ripgrep" "yarn"
	do
        asdf plugin add $BINARY
    done

    asdf_install_enable_version fd 8.1.1
    asdf_install_enable_version fzf 0.24.3
    asdf_install_enable_version neovim nightly
    asdf_install_enable_version nodejs 15.2.1
	asdf_install_enable_version python 3.7.9
    asdf_install_enable_version ripgrep 12.1.1
    # asdf_install_enable_version yarn 1.22.10

    pip3 install pynvim
    npm install -g neovim
	nvim -c 'CocInstall -sync coc-python coc-sh coc-pairs coc-actions coc-snippets|qa'
}

ensure_binaries_are_installed
prerequisites

for FILE in "${FILES[@]}"
do
	copy "${FILE}" ~
done

copy_bashrc_parts
copy_vscode_settings
copy_custom_scripts

touch ~/.bashrc_local && echo "Creating un-git-ed ~/.bashrc_local..."

# post_copy
asdf_setup
