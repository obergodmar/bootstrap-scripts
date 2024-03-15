#!/usr/bin/env bash

install_gvm() {
  SUCCESS="gvm is installed"

  if exists gvm; then
    display_message "$SUCCESS"

    return
  fi

  display_message "Installing gvm..."

  INSTALL_SCRIPT=$(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)

  if GVM_NO_UPDATE_PROFILE="true" bash -c $INSTALL_SCRIPT; then
    display_message "$SUCCESS"
  else
    display_error "could not install gvm"
  fi
}
