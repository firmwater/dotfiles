#!/bin/bash
export DOTFILES=$(pwd)

replace () {
	if [ -z "$2" ]; then
		target="$HOME/.$1"
	else
		target="$2"
	fi
	[ -e $target ] && rm $target
	ln "$1" $target
}

config_tmux() {
	echo Replacing tmux configuration files
	cd tmux
	replace tmux.conf
	replace tmuxcolors.conf

	local tmux_ver=$(tmux -V | cut -c 6-)
	if [ 1 -eq "$(echo "$tmux_ver < 2.1" |  bc -l)" ]; then
		replace "tmux-lt-2.1.conf" "$HOME/.tmuxversionspecific.conf"
	else
		replace "tmux-ge-2.1.conf" "$HOME/.tmuxversionspecific.conf"
	fi
	cd ..
}

config_i3() {
	if [ -e ~/.config/i3 ]; then
		echo Replacing i3 window manager configuration
		cd i3
		replace config ~/.config/i3/config
		cd ..
	fi
}

echo Creating default ~/.bashrc
if [ -e /c ]; then
	# windows
	echo ". $DOTFILES/bashrc_win" > ~/.bashrc
elif [ "$(uname)" = "Darwin" ]; then
	# mac
	echo ". $DOTFILES/bashrc" > ~/.bashrc
	echo ". $DOTFILES/bashrc" > ~/.bash_profile

	config_tmux

	read -p 'Hit enter to launch solarized terminal, then click Shell > Use Settings as Default'
	open osx-terminal/solarized-dark.terminal
else
	echo ". $DOTFILES/bashrc" > ~/.bashrc
	$DOTFILES/gnome/solarized.sh dark

	config_tmux
	config_i3

	echo Adding apt-install to /bin
	APT_INSTALL="/bin/apt-install"
	[ -e $APT_INSTALL ] || sudo ln -s $DOTFILES/bin/apt-install $APT_INSTALL
fi

replace inputrc "$HOME/.inputrc"

./configure_git_defaults.sh