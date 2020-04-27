# Add local bin path
set PATH $PATH $HOME/bin $HOME/.gem/ruby/2.7.0/bin

# General configuration
set -x BROWSER 'open'
set -x EDITOR '/usr/bin/nvim'
set -x LANG 'es_MX.UTF-8'
set -x TERM 'screen-256color'
set -x TERMINAL 'alacritty'

# Starship prompt (https://starship.rs/)
~/bin/starship init fish | source
