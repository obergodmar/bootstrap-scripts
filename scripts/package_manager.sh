#!/usr/bin/env bash

UPDATE="sudo apt-get update"
INSTALL="sudo apt-get install -y"

update() {
  display_message "Updating..."
  $UPDATE
}

install_with_package_manager() {
  SUCCESS="$1 is installed"

  if [[ -z $2 ]] && exists $1 || exists $2; then
    display_message "$SUCCESS"

    return
  fi

  display_message "Installing $1..."
  if $INSTALL $1; then
    display_message "$SUCCESS"
  else
    display_error "$1 was NOT installed"
  fi
}
