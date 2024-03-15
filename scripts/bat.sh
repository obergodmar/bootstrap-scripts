#!/usr/bin/env bash

install_bat() {
  TMP=${TMP:-/tmp}

  SUCCESS="bat is installed"

  if exists bat; then
    display_message "$SUCCESS"

    return
  fi

  display_message "Installing bat..."

  VERSION=$(get_version "sharkdp/bat")
  LINK="https://github.com/sharkdp/bat/releases/latest/download/bat_${VERSION}_amd64.deb"
  TMP_FILE="$TMP/bat.deb"

  if curl -Lo "$TMP_FILE" "$LINK"; then
    display_message "bat deb package is downloaded"
  else
    display_error "could not download"

    rm $TMP_FILE
  fi

  if sudo apt install $TMP_FILE; then
    display_message "$SUCCESS"
  else
    display_error "could not install deb package"
  fi

  rm $TMP_FILE
}
