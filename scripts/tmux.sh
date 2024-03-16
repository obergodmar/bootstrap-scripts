#!/usr/bin/env bash

configure_tmux() {
  if ! [[ -d "$HOME/dotfiles" ]]; then
    clone_dotfiles
  fi

  display_message "Setting tmux..."

  local config_file="$HOME/.tmux.conf"
  local dotfiles_file="$HOME/dotfiles/.tmux.conf"

  if [[ -f "$config_file" ]]; then
    rm -rf "$config_file"

    display_message "Deleted existing tmux.conf config file"
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

  local tpm="$HOME/.tmux/plugins/tpm"
  if ! [[ -d "$tpm" ]]; then
    display_message "Cloning tpm..."

    local link="https://github.com/tmux-plugins/tpm"
    if git clone "$link" "$tpm"; then
      display_message "tpm is cloned"
    else
      display_error "could not clone tpm"
    fi
  fi

  display_message "Setting tmux complete"
}
