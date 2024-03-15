#!/usr/bin/env bash

clone_dotfiles() {
  if [[ -d ~/dotfiles ]]; then
    if git -C ~/dotfiles pull; then
      display_message "dotfiles has been updated"
    else
      display_error "could not update dotfiles"

      return 1
    fi
  else
    REPO=https://github.com/obergodmar/dotfiles.git

    if git clone $REPO ~/dotfiles; then
      display_message "dotfiles has been cloned"
    else
      display_error "could not clone dotfiles"

      return 1
    fi
  fi
}
