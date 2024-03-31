#!/usr/bin/env bash

DOTFILES="$HOME/dotfiles"

clone_dotfiles() {
  if [[ -d "$DOTFILES" ]]; then
    if git -C "$DOTFILES" reset HEAD && git -C "$DOTFILES" checkout -- .; then
      display_message "dotfiles has been reset"
    else
      display_message "could not reset dotfiles"
    fi

    if git -C "$DOTFILES" pull; then
      display_message "dotfiles has been updated"
    else
      display_error "could not update dotfiles"

      return 1
    fi
  else
    local repo=https://github.com/obergodmar/dotfiles.git

    if git clone $repo "$DOTFILES"; then
      display_message "dotfiles has been cloned"
    else
      display_error "could not clone dotfiles"

      return 1
    fi
  fi
}

link_config_file() {
  if ! [[ -d $DOTFILES ]]; then
    clone_dotfiles
  fi

  local config_dir="$1"
  local config_name="$2"
  local config_file="$HOME/$config_dir/$config_name"
  local dotfiles_file="$DOTFILES/$config_dir/$config_name"

  if ! [[ -d "$HOME/$config_dir" ]]; then
    display_message "Creating $config_dir directory"

    if ! mkdir -p "$HOME/$config_dir"; then
      display_error "Could not create $config_dir directory"
    fi
  fi

  if [[ -f "$config_file" ]]; then
    display_message "Config file $config_file exists. Renaming..."

    if mv "$config_file" "$config_file.old"; then
      display_message "Renamed existed config file to $config_file.old"
    fi
  fi

  if [[ -L "$config_file" ]]; then
    display_message "Config link $config_file exists. Updating..."

    if ! rm -rf "$config_file"; then
      display_error "Could not delete link file $config_file"
    fi
  fi

  if ln -s "$dotfiles_file" "$config_file"; then
    display_message "Config file is linked"
  else
    display_error "Could not link config file"
  fi
}
