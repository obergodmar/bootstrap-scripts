#!/usr/bin/env bash

install_with_go() {
  local bin="$1"
  local link="$2"
  local success="$bin is installed"

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
