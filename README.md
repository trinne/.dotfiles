# Dotfiles

## Usage
Make sure you have vim installed. Then just clone the repository to your `$HOME`-directory.
`git clone git@github.com:trinne/dotfiles.git`.
Execute `bash ~/dotfiles/vim-plugins.sh` and create a symlink for the vimrc `ln -s ~/dotfiles/vimrc ~.vimrc`

## VIM
`vim-plugins.sh` is a bash-script for installing some basic vim-plugins to use with coding with Vim.
`vimrc` is a vimrc-configuration that gives some sensible defaults for Vim. It is based on basic.vim from https://github.com/amix/vimrc

## TMUX
`tmux.conf` is a tmux.conf configuration that gives some sensible defaults for tmux. It also adds Powerline-statusbar to the tmux
(Powerline needs to be installed separately https://powerline.readthedocs.io/).
