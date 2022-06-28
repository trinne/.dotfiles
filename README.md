# Dotfiles

## Usage
`git clone git@github.com:trinne/dotfiles.git`.
Run the provided scripts you want and make sure you symlink everything you need at the end. There is a provided script `links.sh` for this, but please read the output of the scirpts in case there is somethings you have to do manually at the end of the scritps.
It is also recommended for you to read through the scripts so that you understand what is being installed and what the scripts are doing.

## Homebrew
Execute `bash ~/dotfiles/brew.sh`. This installs Homebrew if not already installed and sets up the computer for java/clojure development.

## MacOS
Execute `bash ~/dotfiles/macos.sh`. Sets up sensible defaults for MacOS.

## Themes
Execute `bash ~/dotfiles/themes.sh`. Downloads and sets up Dracula theme for iTerm, Powerlevel10k and zsh. iTerm theme installation needs to be finished manually.

## VIM
Execute `bash ~/dotfiles/vim-plugins.sh`.
`vim-plugins.sh` is a bash-script for installing some basic vim-plugins to use with coding with Vim.
`.vimrc` is a configuration that gives some sensible defaults for Vim. It is based on basic.vim from https://github.com/amix/vimrc

## ZSH
ZSH is insalled via `brew.sh`. Oh My Zsh is installed as well. `.zshrc` contains default .zshrc from Oh My Zsh plus jenv, nvm, theme, p10k and other setups for stuff installed in `brew.sh`

## Leiningen
`.lein/profiles.clj` contains packages and plugins for user. At the time of writing, this contains hashp and cloverage

## ShadowCLJS
`.shadow-cljs/config.edn` contains packages and plugins for user. At the time of writing, this contains hashp