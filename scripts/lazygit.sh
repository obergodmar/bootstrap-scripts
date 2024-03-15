#!/usr/bin/env bash

install_lazygit() {
  TMP=${TMP:-/tmp}

  SUCCESS="lazygit is installed"

  if exists lazygit; then
    display_message "$SUCCESS"

    return
  fi

  display_message "Installing lazygit..."

  VERSION=$(get_version "jesseduffield/lazygit")
  LINK="https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${VERSION}_Linux_x86_64.tar.gz"
  TMP_FILE="$TMP/lazygit.tar.gz"
  DIST_FILE="$TMP/lazygit"

  if curl -Lo "$TMP_FILE" "$LINK"; then
    display_message "lazygit release file is downloaded"
  else
    display_error "could not download"

    return
  fi

  if tar xf $TMP_FILE -C $TMP; then
    display_message "lazygit is unpacked"
  else
    display_error "could not unpack file"

    rm $TMP_FILE
    return
  fi

  if sudo install $DIST_FILE /usr/local/bin; then
    display_message "$SUCCESS"
  else
    display_error "could not install unpacked file"
  fi

  rm $TMP_FILE
  rm $DIST_FILE
}
