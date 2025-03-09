#!/usr/bin/env bash

configure_bat() {
  display_message "Setting bat..."

  local config_dir="$(bat --config-dir)"
  local themes_dir="$config_dir/themes"
  local catpuccin_theme="Catppuccin Macchiato.tmTheme"
  local catpuccin_theme_repo="https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme"

  local dotfiles_file="$HOME/dotfiles/.config/bat/config"

  link_config_file ".config/bat" "config"

  if ! [[ -d "$themes_dir" ]]; then
    display_message "Creating bat theme directory"

    if ! mkdir -p "$themes_dir"; then
      display_error "Could not create bat theme directory"
    fi
  fi

  if [[ -f "$themes_dir/$catpuccin_theme" ]]; then
    display_message "Updating bat catpuccin theme"

    if ! wget -P "$themes_dir" $catpuccin_theme_repo; then
      display_error "Could not update catpuccin theme"
    fi
  else
    display_message "Downloading catpuccin bat theme"

    if ! wget -P "$themes_dir" $catpuccin_theme_repo; then
      display_error "Could not download catpuccin bat theme"
    fi
  fi

  display_message "Updating bat cache"

  if ! bat cache --build; then
    display_error "Could not update bat cache"
  fi

  display_message "Setting bat complete"
}
