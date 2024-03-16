#!/usr/bin/env bash

configure_lemonade() {
  if ! [[ -d "$HOME/dotfiles" ]]; then
    clone_dotfiles
  fi

  display_message "Setting lemonade..."

  local config_file="$HOME/.config/lemonade.toml"
  local dotfiles_file="$HOME/dotfiles/.config/lemonade.toml"

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

  display_message "Setting lemoande complete"
}
