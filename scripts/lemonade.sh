#!/usr/bin/env bash

configure_lemonade() {
  display_message "Setting lemonade..."

  link_config_file ".config" "lemonade.toml"

  display_message "Setting lemoande complete"
}

remove_lemonade_config() {
  display_message "Removing lemonade configuration..."

  unlink_config_file ".config" "lemonade.toml"

  display_message "lemonade configuration removal complete"
}
