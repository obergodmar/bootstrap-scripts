#!/usr/bin/env bash

configure_btop() {
  display_message "Setting btop..."

  link_config_file ".config/btop" "btop.conf"

  display_message "Setting btop complete"
}
