#!/usr/bin/env bash

echo "Create themes folder"
mkdir -r ~/themes

echo "Install dracula themes"
cd themes
git clone https://github.com/dracula/iterm.git
git clone https://github.com/dracula/powerlevel10k.git
git clone https://github.com/dracula/zsh.git

ln -s powerlevel10k/files/.p10k.zsh ~/.p10k.zsh
ln -s zsh/dracula.zsh-theme ~/.oh-my-zsh/custom/themes/dracula.zsh-theme

echo "Themes installed"
echo "iTerm theme needs to be configured from the iTerm preferences"

