#!/usr/bin/env bash

install_nvm() {
  local success="nvm is installed"

  if [[ -d "$HOME/.nvm" ]]; then
    display_message "$success"

    return
  fi

  display_message "Installing nvm..."

  local version=$(get_version "nvm-sh/nvm")
  if [[ -z $version ]]; then
    display_error "could not fetch latest version"

    return
  fi

  local install_script=$(curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${version}/install.sh")

  if PROFILE=/dev/null bash -c $install_script; then
    display_message "$success"
  else
    display_error "could not install nvm"
  fi
}

source_nvm() {
  local nvm_dir="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  local nvm="$nvm_dir/nvm.sh"

  if ! [[ -s "$nvm" ]]; then
    install_nvm
  fi

  source "$nvm"
}

install_node() {
  local success="node is installed"

  source_nvm

  if exists node; then
    display_message "$success"

    return
  fi

  display_message "Installing node..."

  if nvm install v20; then
    display_message $success
  else
    display_error "could not install node"
  fi
}

install_with_npm() {
  local package="$1"
  local success="$package is installed"

  source_nvm

  if exists "$package"; then
    display_message "$success"

    return
  fi

  display_message "Installing $package..."

  if npm install -g "$package"; then
    display_message "$success"
  else
    display_error "could not install $package"
  fi
}
