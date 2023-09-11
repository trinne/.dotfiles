#!/usr/bin/env bash

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/tuomas.rinne/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

echo "Installing Git..."
brew install git

echo "Git config"
echo "Enter user.name for git config:"
read gitUserName
git config --global user.name $gitUserName

echo "Enter user.email for git config:"
read gitUserEmail
git config --global user.email $gitUserEmail

echo "Install nvm"
brew install nvm
mkdir -r ~/.nvm

echo "Install java"
brew install openjdk
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

echo "Install jenv"
brew install jenv
jenv add /opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home

echo "Installing other brew stuff..."
cli_apps=(
  awscli@1
  clojure
  ctop
  direnv
  git-remote-codecommit
  gradle
  graphviz
  helm
  httpie
  jq
  leiningen
  mkdocs
  odo-dev
  openssl
  plantuml
  python
  romkatv/powerlevel10k/powerlevel10k
  riprgep
  tmux
  tree
)
brew install ${cli_apps[@]}

echo "Installing homebrew cask"
brew tap homebrew/cask

#Install Zsh & Oh My Zsh
echo "Installing Oh My ZSH..."
curl -L http://install.ohmyz.sh | sh

echo "Setting up Zsh plugins..."
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/agkozak/zsh-z.git

echo "Setting ZSH as shell..."
chsh -s /bin/zsh

# Apps
apps=(
  alfred
  docker
  firefox
  google-chrome
  rectangle
  spotify
  intellij-idea
  iterm2
  tunnelblick
  visual-studio-code
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps with Cask..."
brew install --cask  --appdir="/Applications" ${apps[@]}

echo "Installing cask-fonts"
brew tap homebrew/cask-fonts

brew install font-menlo-for-powerline

echo "To use java, set the correct java version to use by calling 'jenv global/local <version-number>'"
echo "The correct version number can be aquired by running 'brew info openjdk'"

echo "Everything is now installed."
read -p "Press [Enter] key to finish the setup process..."
