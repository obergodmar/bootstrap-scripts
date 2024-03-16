#!/usr/bin/env bash

install_gvm() {
  local success="gvm is installed"

  if exists gvm; then
    display_message "$success"

    return
  fi

  display_message "Installing gvm..."

  local install_script=$(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)

  if echo "$install_script" | bash; then
    display_message "$success"
  else
    display_error "could not install gvm"
  fi
}

source_gvm() {
  local gvm="$HOME/.gvm/scripts/gvm"

  if ! [[ -s "$HOME/.gvm/scripts/gvm" ]]; then
    install_gvm
  fi

  source "$gvm"
}

install_go() {
  local success="go is installed"

  source_gvm

  if exists go; then
    display_message "$success"

    return
  fi

  display_message "Installing go..."

  if gvm install go1.22.0 -B; then
    display_message "$success"
  else
    display_error "could not install go"
  fi

  if gvm alias create default go1.22.0; then
    display_message "Setting go1.22.0 as default version";
    else
      display_error "could not set default version go"
  fi
}

install_with_go() {
  local bin="$1"
  local link="$2"
  local success="$bin is installed"

  source_gvm

  if exists "$bin"; then
    display_message "$success"

    return
  fi

  display_message "Installing $bin..."

  if go install "$link"; then
    display_message "$success"
  else
    display_error "could not install $bin"
  fi
}
