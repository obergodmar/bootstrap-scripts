#!/usr/bin/env bash

install_bun() {
  local success="bun is installed"
  local bun_dir="$HOME/.bun"

  if [[ -d "$bun_dir" ]]; then
    display_message "$success"

    return
  fi

  display_message "Installing bun..."

  local install_script=$(curl -fsSL https://bun.sh/install)

  if echo "$install_script" | bash; then
    display_message "$success"
  else
    display_error "could not install bun"
  fi
}

