#!/usr/bin/env bash

configure_bat() {
  display_message "Setting bat..."

  local config_dir="$HOME/.config/bat"
  local themes_dir="$config_dir/themes"
  local kanagawa_theme="kanagawa-tmTheme"
  local kanagawa_dir="$themes_dir/$kanagawa_theme"
  local theme_repo="https://github.com/obergodmar/kanagawa-tmTheme.git"

  local dotfiles_file="$HOME/dotfiles/.config/bat/config"

  link_config_file ".config/bat" "config"

  if ! [[ -d "$themes_dir" ]]; then
    display_message "Creating bat theme directory"

    if ! mkdir -p "$themes_dir"; then
      display_error "Could not create bat theme directory"
    fi
  fi

  if [[ -d "$kanagawa_dir" ]]; then
    display_message "Pulling bat kanagawa theme"

    if ! git -C "$kanagawa_dir" pull; then
      display_error "Could not update kanagawa theme"
    fi
  else
    display_message "Clonning kanagawa bat theme"

    if ! git clone "$theme_repo" "$kanagawa_dir"; then
      display_error "Could not clone kanagawa bat theme"
    fi
  fi

  display_message "Updating bat cache"

  if ! bat cache --build; then
    display_error "Could not update bat cache"
  fi

  display_message "Setting bat complete"
}
