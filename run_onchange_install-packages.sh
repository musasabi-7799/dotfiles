#!/bin/bash

# -----------------------------------------------------------------------------
# Packages
# -----------------------------------------------------------------------------
manage_os_packages() {
  if (type 'apt' >/dev/null 2>&1); then
    sudo apt update
    sudo apt upgarde

    packages=(
      git
      zsh
    )

    # Since it is difficult to get appimages to work in a container,
    # use the package manager to install them.
    if [[ -e /.dockerenv || -v GITHUB_ACTIONS ]]; then
      packages+=(
        tmux
        neovim
        fish
      )

      rm ~/.local/bin/tmux
      rm ~/.local/bin/nvim
      rm ~/.local/bin/fish
    fi

    for package in "${packages[@]}"; do
      sudo apt install -y "$package"
    done
  elif (type 'dnf' >/dev/null 2>&1); then
    sudo dnf update

    packages=(
      epel-release
      git
      zsh
    )

    # Since it is difficult to get appimages to work in a container,
    # use the package manager to install them.
    if [[ -e /.dockerenv || -v GITHUB_ACTIONS ]]; then
      packages+=(
        tmux
        neovim
        fish
      )

      rm ~/.local/bin/tmux
      rm ~/.local/bin/nvim
      rm ~/.local/bin/fish
    fi

    for package in "${packages[@]}"; do
      sudo dnf install -y "$package"
    done
  else
    echo 'This OS is not supported!'
    exit 1
  fi
}

manage_os_packages

# -----------------------------------------------------------------------------
# Shell
# -----------------------------------------------------------------------------
# Plugin manager
if ! (type 'sheldon' >/dev/null 2>&1); then
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh |
    bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
fi

# Prompt
if ! (type 'starship' >/dev/null 2>&1); then
  curl -fsSL https://starship.rs/install.sh |
    sh -s -- --yes --bin-dir ~/.local/bin
fi

# -----------------------------------------------------------------------------
# Terminal
# -----------------------------------------------------------------------------
# Plugin manager
if [[ ! -e ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
