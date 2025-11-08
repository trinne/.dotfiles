#!/bin/bash

# Function to install a package based on the package manager
install_package() {
    brew install $1
}

# Function to check the latest version of a package
check_latest_version() {
    brew info --json=v1 $1 | jq -r ".[0].versions.stable"
}

# Function to check the version of a package
check_package_version() {
    brew list --versions $1 | awk '{print $2}'
}

# Function to display information about a package
display_package_info() {
    package_name=$1
    current_version=$(check_package_version $package_name)
    latest_version=$(check_latest_version $package_name)

    if [[ ! $current_version == $latest_version ]]; then
      package_info="Package: $package_name\n"
      package_info+="Current version: $current_version\n"
      package_info+="Latest version: $latest_version\n"
      package_info+="To update, run:\n"
      package_info+="  brew upgrade $package_name\n"
      package_infos+=("$package_info")
    fi
}

# Function to install or display the package info of a package based on the package manager
verify_version() {
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

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	touch "$HOME/.zprofile"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/usr/local/bin/brew shellenv)"
    else
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
fi
    
brew update

# Install or update necessary tools
tools=(
  asdf
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
  stow
  tmux
  tree
  zsh
)

package_infos=()
for tool in "${tools[@]}"; do
    verify_version "$tool"
done

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My ZSH..."
  curl -L http://install.ohmyz.sh | sh
fi

# Make themes folder
mkdir -p "$HOME/themes"

# Check for updates in Git repositories
check_git_repo_updates "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
check_git_repo_updates "$HOME/.oh-my-zsh/custom/plugins/zsh-z" "https://github.com/agkozak/zsh-z.git"
check_git_repo_updates "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" "https://github.com/romkatv/powerlevel10k.git"
check_git_repo_updates "$HOME/.nvm" "https://github.com/nvm-sh/nvm.git"
check_git_repo_updates "$HOME/.jenv" "https://github.com/jenv/jenv.git"
check_git_repo_updates "$HOME/.tmux/plugins/tpm" "https://github.com/tmux-plugins/tpm.git"

# Set up dotfiles repository
dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_config=".config"

# Handle the Neovim submodule
nvim_config="$dotfiles_dir/nvim"
nvim_submodule="https://github.com/trinne/nvim.git"

# Check if the submodule is initialized
if [ -f "$nvim_config/.config/nvim/.git" ]; then
    echo "Neovim submodule already initialized."
else
    git submodule add "$nvim_submodule" "$nvim_config"
    git submodule update --init --recursive
fi

# Create symlinks using stow
if [ -f "$HOME/.zshrc" ]; then
  echo "Delete .zshrc from '$HOME'"
  rm "$HOME/.zshrc"
fi

stow -v -d "$dotfiles_dir" -t "$HOME" zsh tmux nvim os clj k9s

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
echo "Packages needing an update:"
for info in "${package_infos[@]}"; do
    echo "$info"
done

