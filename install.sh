#!/bin/bash

# Function to install a package based on the package manager
install_package() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install $1
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get install -y $1
    else
        echo "Unsupported operating system"
        exit 1
    fi
}

# Function to check the latest version of a package
check_latest_version() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew info --json=v1 $1 | jq -r ".[0].versions.stable"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        apt show $1 | grep Version | awk '{print $2}'
    else
        echo "Unsupported operating system"
        exit 1
    fi
}

# Function to check the version of a package
check_package_version() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew list --versions $1 | awk '{print $2}'
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        dpkg -l | grep -E "^ii.*$1" | awk '{print $3}'
    else
        echo "Unsupported operating system"
        exit 1
    fi
}

# Function to display information about a package
display_package_info() {
    package_name=$1
    current_version=$(check_package_version $package_name)
    latest_version=$(check_latest_version $package_name)

    package_info="Package: $package_name\n"
    package_info+="Current version: $current_version\n"
    package_info+="Latest version: $latest_version\n"
    package_info+="To update, run:\n"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        package_info+="  brew upgrade $package_name\n"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        package_info+="  sudo apt-get install --only-upgrade $package_name\n"
    else
        echo "Unsupported operating system"
        exit 1
    fi

    package_infos+=("$package_info")
}

# Function to install or display the package info of a package based on the package manager
install_package() {
    package_name=$1
    current_version=$(check_package_version $package_name)

    if [[ "$current_version" == "" ]]; then
        echo "Installing $package_name..."
        install_package $package_name
    else
        display_package_info $package_name
    fi
}

# Function to check for updates in a Git repository
check_git_repo_updates() {
    repo_dir=$1
    repo_name=$2

    if [ -d "$repo_dir" ]; then
        if [ -d "$repo_dir/.git" ]; then
            git -C "$repo_dir" remote update >/dev/null 2>&1
            if [ "$(git -C "$repo_dir" rev-parse HEAD)" != "$(git -C "$repo_dir" rev-parse "@{u}")" ]; then
                package_infos+=("Package: $repo_name\nUpdates available. Run:\n  git -C $repo_dir pull\n")
            fi
        else
            echo "Given repo directory is not a Git repository."
        fi
    else
        git clone "$repo_name" "$repo_dir"
    fi
}

# Update package managers
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew update
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get update
else
    echo "Unsupported operating system"
    exit 1
fi

# Install or update necessary tools
tools=(
  awscli
  clojure
  ctop
  direnv
  fzf
  git-remote-codecommit
  gradle
  graphviz
  helm
  httpie
  jdtls
  jq
  k9s
  kubectl
  leiningen
  mkdocs
  neovim
  odo-dev
  openjdk
  openssl
  plantuml
  python
  ripgrep
  stern
  tmux
  tree
  zsh
)

package_infos=()
for tool in "${tools[@]}"; do
    install_package "$tool"
done

# Check for updates in Git repositories
check_git_repo_updates "$HOME/.nvm" "https://github.com/nvm-sh/nvm.git"
check_git_repo_updates "$HOME/.jenv" "https://github.com/jenv/jenv.git"
check_git_repo_updates "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" "https://github.com/romkatv/powerlevel10k.git"
check_git_repo_updates "$HOME/.tmux/plugins/tpm" "https://github.com/tmux-plugins/tpm.git"

# Install NVM
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
else
    echo "NVM is already installed."
fi

# Install stow
install_or_update_package "stow"

# Set up dotfiles repository
dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_config=".config"

# Create symlinks using stow
stow -v -d "$dotfiles_dir" -t "$HOME" zsh tmux

# Handle the Neovim submodule
nvim_config="$dotfiles_dir/nvim"
nvim_submodule="https://github.com/trinne/nvim.git"

# Check if the submodule is initialized
if [ -f "$nvim_config/.git" ]; then
    echo "Neovim submodule already initialized."
else
    git submodule add "$nvim_submodule" "$nvim_config"
    git submodule update --init --recursive
fi

# Set up symlinks for Neovim
stow -v -d "$dotfiles_dir" -t "$HOME/.config/nvim" neovim

# Set Zsh as the default shell
chsh -s "$(which zsh)"

# Configure Git globally
echo "Enter your Git username: "
read git_username
echo "Enter your Git email address: "
read git_email

git config --global user.name "$git_username"
git config --global user.email "$git_email"

# Display information about installed packages and repositories needing an update
echo -e "\nPackages needing an update:"
for info in "${package_infos[@]}"; do
    echo -e "$info"
done

