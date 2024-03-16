#!/usr/bin/env bash

configure_screen() {
  if ! [[ -d "$HOME/dotfiles" ]]; then
    clone_dotfiles
  fi

  display_message "Setting screen..."

  local config_file="$HOME/.screenrc"
  local dotfiles_file="$HOME/dotfiles/.screenrc"

  if [[ -f "$config_file" ]]; then
    rm -rf "$config_file"

    display_message "Deleted existing screen config file"
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

  display_message "Setting screen complete"
}
