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
