#!/usr/bin/env bash

configure_tmux() {
  display_message "Setting tmux..."

  link_config_file "." ".tmux.conf"

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

remove_tmux_config() {
  display_message "Removing tmux configuration..."

  unlink_config_file "." ".tmux.conf"

  # Remove tmux plugin manager and plugins
  remove_file_or_directory "$HOME/.tmux" "tmux plugins directory"

  display_message "tmux configuration removal complete"
}
