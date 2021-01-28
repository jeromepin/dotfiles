#!/usr/bin/env bash

# From https://github.com/liskin/dotfiles/blob/68964611b4b578b646cf5f13a47a4ee77e93e740/.bashrc

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	  *) return;;
esac

for i in ~/.bashrc.d/*.sh; do
	if [[ $__bashrc_bench ]]; then
		TIMEFORMAT="$i: %R"
		time . "$i"
		unset TIMEFORMAT
	else
		. "$i"
	fi
done; unset i
