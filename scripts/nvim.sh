#!/usr/bin/env bash

install_luacheck() {
  local success="luacheck is installed"
  local error="could not install luacheck"

  if exists luacheck; then
    display_message "$success"

    return
  fi

  if ! exists luarocks; then
    display_error "$error"
  fi

  display_message "Installing luacheck..."

  local luarocks=$([[ -f $(which sudo) ]] && echo "sudo luarocks" || echo "luarocks")
  if $luarocks install luacheck; then
    display_message "$success"
  else
    display_error "$error"
  fi
}

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
    display_message "Pulling nvim config dir..."

    if git -C "$nvim_dir" pull; then
      display_message "nvim config dir is updated"
    else
      display_error "could not pull nvim config dir"
    fi

  else
    local repo="https://github.com/obergodmar/nvim.git"

    display_message "Cloning nvim config dir..."

    if git clone "$repo" "$nvim_dir"; then
      display_message "nvim config is cloned"
    else
      display_error "could not clone nvim config dir"
    fi
  fi

  display_message "Setting neovim complete"
}
