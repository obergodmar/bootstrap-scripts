#!/usr/bin/env bash

configure_screen() {
  display_message "Setting screen..."

  link_config_file "." ".screenrc"

  display_message "Setting screen complete"
}

remove_screen_config() {
  display_message "Removing screen configuration..."

  unlink_config_file "." ".screenrc"

  display_message "screen configuration removal complete"
}
