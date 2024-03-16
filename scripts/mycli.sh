#!/usr/bin/env bash

configure_mycli() {
  if ! [[ -d "$HOME/dotfiles" ]]; then
    clone_dotfiles
  fi

  display_message "Setting mycli..."

  local config_file="$HOME/.myclirc"
  local dotfiles_file="$HOME/dotfiles/.myclirc"

  if [[ -f "$config_file" ]]; then
    rm -rf "$config_file"

    display_message "Deleted existing $config_file file"
  fi

  if [[ -L "$config_file" ]]; then
    display_message "Config link file exists"
  else
    if ln -s "$dotfiles_file" "$config_file"; then
      display_message "Config file is linked"
    else
      display_error "Could not link config file"
    fi
  fi

  display_message "Setting mycli complete"
}
