#!/bin/sh
# Next chapters recreate my personal configuration, enjoy it!
# Author: ivangaravito@gmail.com
# Date: 2020-03-28

chat_reset=$(tput sgr0)
chat_red=$(tput setaf 1)
chat_green=$(tput setaf 2)
chat_yellow=$(tput setaf 3)
chat_blue=$(tput setaf 4)

chapter () {
	echo "${chat_yellow}∴ $1${chat_reset}"
}

begin_msg () {
	tput sc
	echo -en "  ${chat_blue}➜${chat_reset} $1..."
}

end_msg () {
	tput rc
	tput el
	if [ $2 -eq 0 ]; then
		echo -en "  ${chat_green}✔${chat_reset} "
		echo -e $1
	else
		echo -en "  ${chat_red}✘${chat_reset} " 
		echo -e $1
		test -n "$3" && echo -e "    ${chat_red}ERROR >${chat_reset} $3"
	fi
}

show_msg () {
	echo -en "  ${chat_blue}➜${chat_reset} $1"
}

echo "Genesis started, recreating my personal configuration"

chapter "Chapter 1. Directory creation"
MSG="Making user directories"
begin_msg "$MSG"
mkdir -p ~/apps && \
mkdir -p ~/.local/bin && \
ln -s ~/.local/bin ~/bin && \
mkdir -p ~/dev && \
mkdir -p ~/dev-3rd-party
end_msg "$MSG" $?

chapter "Chapter 2. Package creation"
TTY_PKGS="fish zsh tmux neovim"
X11_PKGS="alacritty xsel xclip ttf-fira-code"
PKGS=
if [ "$XDG_SESSION_TYPE" = "tty" ]; then
	MSG="Installing TTY packages"
	PKGS="$TTY_PKGS"
else
	MSG="Installing X11 packages"
	PKGS="$X11_PKGS $TTY_PKGS"
fi
begin_msg "$MSG"
TMP=`sudo pacman --noconfirm --needed -Sq $PKGS`
end_msg "$MSG" $? "$TMP"

chapter "Chapter 3. Custom keybinding creation"
if [ "$XDG_SESSION_TYPE" = "x11" ]; then
	MSG="Configuring custom keybinding"
	begin_msg "$MSG"
	case "$XDG_CURRENT_DESKTOP" in
		GNOME)
			TMP=`sed "s@{{HOME}}@$HOME@g" resources/dconf_custom-keybindings.toml | dconf load '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/'`
			;;
		XFCE)
			TMP=`xfconf-query -c xfce4-keyboard-shortcuts -np "/commands/custom/F12" -t string -s "xfce4-terminal --drop-down"`
			TMP=`xfconf-query -c xfce4-keyboard-shortcuts -np "/commands/custom/<Primary><Alt>t" -t string -s "tmux-terminal.sh"`
			;;
		*)
			TMP=`echo "Using $XDG_CURRENT_DESKTOP, keybindings now available"; false`
			;;
	esac
	end_msg "$MSG" $? "$TMP"
else
	show_msg "Skipping because this is a TTY environment"
fi

chapter "Chapter 4. Alacritty terminal creation"
if [ "$XDG_SESSION_TYPE" = "x11" ]; then
	MSG="Making Alacritty configuration's directory"
	begin_msg "$MSG"
	TMP=`mkdir -p ~/.config/alacritty`
	end_msg "$MSG" $? "$TMP"
	MSG="Configuring Alacritty"
	begin_msg "$MSG"
	TMP=`cp -bf resources/alacritty.yml ~/.config/alacritty/`
	TMP=`cp -bf resources/alacritty-binding.yml ~/.config/alacritty/`
	end_msg "$MSG" $? "$TMP"
else
	show_msg "Skipping because this is a TTY environment"
fi


chapter "Chapter 5. tmux terminal multiplexer creation"
MSG="Making TMUX plugins directory"
begin_msg "$MSG"
TMP=`mkdir -p ~/.tmux/plugins`
end_msg "$MSG" $? "$TMP"
MSG="Downloading TMUX Plugin Manager (TPM)"
begin_msg "$MSG"
if [ -d "~/.tmux/plugins/tpm" ]; then
	TMP=`cd ~/.tmux/plugins/tpm; git pull 2>&1`
else
	TMP=`git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 2>&1`
fi
end_msg "$MSG" $? "$TMP"
MSG="Configuring TMUX"
begin_msg "$MSG"
TMP=`cp -bf resources/tmux.conf ~/.tmux.conf`
end_msg "$MSG" $? "$TMP"
show_msg "Press prefix + I (capital i, as in Install)"

chapter "Chapter 6. Starship cross-shell prompt creation"
MSG="Downloading and installing starfish"
begin_msg "$MSG"
TMP=`curl -fsSL https://starship.rs/install.sh | bash -s -- -y -b ~/bin`
end_msg "$MSG" $? "$TMP"
MSG="Configuring Starfish"
begin_msg "$MSG"
TMP=`cp -bf resources/starship.toml ~/.config/`
end_msg "$MSG" $? "$TMP"

chapter "Chapter 7. Fish (main shell) creation"
MSG="Changing to Fish the default user shell"
begin_msg "$MSG"
TMP=`sudo usermod -s "$(which fish)" $USER`
end_msg "$MSG" $? "$TMP"
MSG="Creating Fish's configuration directory"
begin_msg "$MSG"
TMP=`mkdir -p ~/.config/fish`
end_msg "$MSG" $? "$TMP"
MSG="Configuring Fish shell"
begin_msg "$MSG"
TMP=`cp -bf resources/config.fish ~/.config/fish/`
end_msg "$MSG" $? "$TMP"

chapter "Chapter 8. Bash (main shell) creation"
MSG="Configuring Bash shell"
begin_msg "$MSG"
X=`cat ~/.bashrc | grep "# <<-- ivangaravito/genesis -->> #"`
if [ -z "$X" ]; then
	TMP=`cat resources/bashrc >> ~/.bashrc`
else
	TMP=`echo "Already configured!"`
fi
end_msg "$MSG" $? "$TMP"

chapter "Chapter 9. Zsh (main shell) creation"
MSG="Configuring Zsh shell"
begin_msg "$MSG"
TMP=`cp -bf resources/zshrc ~/.zshrc`
end_msg "$MSG" $? "$TMP"

chapter "Chapter 10. NeoVim creation"
MSG="Creating NeoVim's configuration directory"
begin_msg "$MSG"
TMP=`mkdir -p ~/.config/nvim ~/.vim/bundle`
end_msg "$MSG" $? "$TMP"
MSG="Configuring NeoVim"
begin_msg "$MSG"
TMP=`cp -bf resources/vimrc ~/.config/nvim/init.vim`
end_msg "$MSG" $? "$TMP"
MSG="Installing plugin manager"
begin_msg "$MSG"
if [ ! -d "~/.vim/bundle/vim-plug" ]; then
	TMP=`git clone https://github.com/junegunn/vim-plug.git ~/.vim/bundle/vim-plug 2>&1`
fi
end_msg "$MSG" $? "$TMP"
show_msg "Enter nvim and type ':PlugInstall' to install plugins"

chapter "Chapter 11. TMUX Terminal creation"
if [ "$XDG_SESSION_TYPE" = "x11" ]; then
	MSG="Downloading TMUX logo"
	begin_msg "$MSG"
	TMP=`curl https://raw.githubusercontent.com/tmux/tmux/master/logo/tmux-logomark.svg > ~/.local/share/icons/tmux-logomark.svg`
	end_msg "$MSG" $? "$TMP"
	MSG="Installing scripts for TMUX Terminal"
	begin_msg "$MSG"
	TMP=`cp -bf resources/tmux-terminal.sh ~/bin/`
	TMP=`cp -bf resources/tmux-terminal-cmd.sh ~/bin/`
	end_msg "$MSG" $? "$TMP"
	MSG="Installing XDG desktop menu for TMUX Terminal"
	begin_msg "$MSG"
	TMP=`sed "s@{{HOME}}@$HOME@g" resources/tmux-terminal.desktop > ~/.local/share/applications/tmux-terminal.desktop`
	end_msg "$MSG" $? "$TMP"
	MSG="Updating XDG desktop menu entries"
	begin_msg "$MSG"
	TMP=`xdg-desktop-menu forceupdate`
	end_msg "$MSG" $? "$TMP"
else
	show_msg "Skipping because this is a TTY environment"
fi
