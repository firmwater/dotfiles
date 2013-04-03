#!/bin/bash
export DOTFILES=$(pwd)

replace () {
	if [ -z "$2" ]; then
		target="$HOME/.$1"
	else
		target="$2"
	fi
	[ -e $target ] && rm $target
	ln "$DOTFILES/$1" $target
}

echo Creating default ~/.bashrc
if [ -e /c ]; then
	# windows
	echo ". $DOTFILES/bashrc_win" > ~/.bashrc
else
	echo ". $DOTFILES/bashrc" > ~/.bashrc
	$DOTFILES/gnome/solarized.sh dark

	replace tmux.conf
	replace tmuxcolors.conf
fi

replace inputrc "$HOME/.inputrc"

./configure_git_defaults.sh
