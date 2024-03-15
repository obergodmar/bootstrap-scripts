#!/usr/bin/env bash

install_bat() {
  install_deb_package "bat" "sharkdp/bat" "bat"
}

configure_bat() {
  if ! [[ -d "$HOME/dotfiles" ]]; then
    clone_dotfiles
  fi

  display_message "Setting bat..."

  local config_dir="$HOME/.config/bat"
  local config_file="$config_dir/config"
  local themes_dir="$config_dir/themes"
  local kanagawa_theme="kanagawa-tmTheme"
  local kanagawa_dir="$themes_dir/$kanagawa_theme"
  local theme_repo="https://github.com/obergodmar/kanagawa-tmTheme.git"

  local dotfiles_file="$HOME/dotfiles/.config/bat/config"

  if ! [[ -d "$config_dir" ]]; then
    display_message "Creating bat config directory"

    if ! mkdir -p "$config_dir"; then
      display_error "Could not create bat config directory"
    fi
  fi

  if [[ -f "$config_file" ]]; then
    rm -rf "$config_file"

    display_message "Deleted existing bat config file"
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
