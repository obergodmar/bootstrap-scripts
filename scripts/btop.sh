#!/usr/bin/env bash

configure_btop() {
  display_message "Setting btop..."

  link_config_file ".config/btop" "btop.conf"

  display_message "Setting btop complete"
}

remove_btop_config() {
  display_message "Removing btop configuration..."

  unlink_config_file ".config/btop" "btop.conf"

  # Remove btop cache and themes
  remove_file_or_directory "$HOME/.config/btop" "btop configuration directory"

  display_message "btop configuration removal complete"
}
