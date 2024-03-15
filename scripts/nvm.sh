#!/usr/bin/env bash

install_nvm() {
  SUCCESS="nvm is installed"

  if [[ -d ~/.nvm ]]; then
    display_message "$SUCCESS"

    return
  fi

  display_message "Installing nvm..."

  VERSION=$(get_version "nvm-sh/nvm")
  INSTALL_SCRIPT=$(curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${VERSION}/install.sh")

  if PROFILE=/dev/null bash -c $INSTALL_SCRIPT; then
    display_message "$SUCCESS"
  else
    display_error "could not install nvm"
  fi
}
