#!/usr/bin/env bash

clone_dotfiles() {
  local dotfiles="$HOME/dotfiles"

  if [[ -d "$dotfiles" ]]; then
    if git -C "$dotfiles" reset HEAD && git -C "$dotfiles" checkout -- .; then
      display_message "dotfiles has been reset"
    else
      display_message "could not reset dotfiles"
    fi

    if git -C "$dotfiles" pull; then
      display_message "dotfiles has been updated"
    else
      display_error "could not update dotfiles"

      return 1
    fi
  else
    local repo=https://github.com/obergodmar/dotfiles.git

    if git clone $repo "$dotfiles"; then
      display_message "dotfiles has been cloned"
    else
      display_error "could not clone dotfiles"

      return 1
    fi
  fi
}
