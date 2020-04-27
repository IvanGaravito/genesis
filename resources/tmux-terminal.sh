#!/bin/bash

CMD_TMUX="$HOME/bin/tmux-terminal-cmd.sh"

case "$XDG_CURRENT_DESKTOP" in
	GNOME|XFCE)
		alacritty --config-file "$HOME/.config/alacritty/alacritty-binding.yml" -e "$CMD_TMUX"
		;;
	KDE)
		konsole --hide-menubar --hide-tabbar --separate -e "$CMD_TMUX"
		;;
	*)
		;;
esac
