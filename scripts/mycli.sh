#!/usr/bin/env bash

configure_mycli() {
  display_message "Setting mycli..."

  link_config_file "." ".myclirc"

  display_message "Setting mycli complete"
}
