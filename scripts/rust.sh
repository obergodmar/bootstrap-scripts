#!/usr/bin/env bash

install_rust() {
  SUCCESS="rust is installed"

  if exists rustc; then
    display_message "$SUCCESS"

    return
  fi

  display_message "Installing rust..."

  INSTALL_SCRIPT=$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)

  if echo "$INSTALL_SCRIPT" | sh -s -- --y --no-modify-path; then
    display_message "$SUCCESS"
  else
    display_error "could not install rust"
  fi
}
