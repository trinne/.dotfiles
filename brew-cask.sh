#!/usr/bin/env bash

# Apps
apps=(
  alfred
  docker
  firefox
  google-chrome
  intellij-idea
  iterm2
  min
  opera
  rectangle
  spotify
  tunnelblick
  visual-studio-code
)

echo "installing apps with Cask..."
brew install --cask  ${apps[@]}

echo "To use java, set the correct java version to use by calling 'jenv global/local <version-number>'"
echo "The correct version number can be aquired by running 'brew info openjdk'"

echo "Everything is now installed."
read -p "Press [Enter] key to finish the setup process..."
