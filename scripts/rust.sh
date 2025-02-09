#!/usr/bin/env bash

update_rust() {
  if rustup update stable; then
    display_message "rust is updated"
  else
    display_error "could not update rust"
  fi
}

install_rust() {
  local success="rust is installed"
  local cargo_dir="$HOME/.cargo"

  if [[ -d "$cargo_dir" ]]; then
    display_message "$success"
    update_rust

    return
  fi

  display_message "Installing rust..."

  local install_script=$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)

  if echo "$install_script" | sh -s -- -y; then
    display_message "$success"
  else
    display_error "could not install rust"
  fi
}

install_with_cargo() {
  local bin="$1"
  local crate_name="$2"
  local options="${@:3}"

  local success="$crate_name is installed"

  if exists $bin; then
    display_message "$success"

    return
  fi

  local cargo="$HOME/.cargo/bin/cargo"

  if [[ -f "$cargo" ]]; then
    install_rust
  fi

  display_message "Installing $crate_name..."

  echo $cargo install "$crate_name" "$options"

  if [[ -z "$options" ]] && $cargo install "$crate_name" || $cargo install "$crate_name" "${@:3}"; then
    display_message "$success"
  else
    display_error "could not install $crate_name"
  fi
}
