#!/usr/bin/env bash

install_with_luarocks() {
  local name="$1"
  local options="${@:2}"

  local success="$name is installed"
  local error="could not install $name"

  if exists "$name"; then
    display_message "$success"

    return
  fi

  if ! exists luarocks; then
    display_error "$error - luarocs is not installed"
  fi

  display_message "Installing $name..."

  local cmd="sudo luarocks install"
  if [[ -z "$options" ]] && $cmd "$name" || $cmd "$name" "${@:2}"; then
    display_message "$success"
  else
    display_error "$error"
  fi
}
