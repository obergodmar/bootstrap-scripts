#!/usr/bin/env bash

configure_screen() {
  display_message "Setting screen..."

  link_config_file "." ".screenrc"

  display_message "Setting screen complete"
}
