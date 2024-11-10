#!/usr/bin/env bash

install_nvim() {
  local success="nvim is installed"
  local version="stable"

  if exists nvim; then
    display_message "$success"

    return
  fi

  local bob="$HOME/.cargo/bin/bob"
  if [[ -f "$bob" ]]; then
    install_with_cargo "bob" "bob-nvim"
  fi

  display_message "Installing nvim..."

  if $bob install "$version"; then
    display_message "$success"
  else
    display_error "could not install nvim"
  fi

  if $bob use "$version"; then
    display_message "nvim is set"
  else
    display_error "could not set nvim"
  fi
}

configure_nvim() {
  local nvim_dir="$HOME/.config/nvim"

  if [[ -d "$nvim_dir" ]]; then
    display_warning "nvim config dir exists. Update it yourself..."

  else
    local repo="https://github.com/obergodmar/nvim.git"

    display_message "Cloning nvim config dir..."

    if git clone -b "cause/devops" "$repo" "$nvim_dir"; then
      display_message "nvim config is cloned"
    else
      display_error "could not clone nvim config dir"
    fi
  fi

  display_message "Setting neovim complete"
}
