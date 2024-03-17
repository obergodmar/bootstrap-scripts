#!/usr/bin/env bash

install_lazygit() {
  TMP=${TMP:-/tmp}

  local success="lazygit is installed"

  if exists lazygit; then
    display_message "$success"

    return
  fi

  display_message "Installing lazygit..."

  local version=$(get_version "jesseduffield/lazygit")
  if [[ -z $version ]]; then
    display_error "could not fetch latest version"

    return
  fi

  local arch=$(get_arch)

  local link="https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_${arch}.tar.gz"
  local tmp_file="$TMP/lazygit.tar.gz"
  local dist_file="$TMP/lazygit"

  if curl -Lo "$tmp_file" "$link"; then
    display_message "lazygit release file is downloaded"
  else
    display_error "could not download"

    return
  fi

  if tar xf "$tmp_file" -C $TMP; then
    display_message "lazygit is unpacked"
  else
    display_error "could not unpack file"

    rm "$tmp_file"
    return
  fi

  if sudo install "$dist_file" /usr/local/bin; then
    display_message "$success"
  else
    display_error "could not install unpacked file"
  fi

  rm "$tmp_file"
  rm "$dist_file"
}

configure_lazygit() {
  if ! [[ -d "$HOME/dotfiles" ]]; then
    clone_dotfiles
  fi

  display_message "Setting lazygit..."

  local config_dir="$HOME/.config/lazygit"
  local config_file="$config_dir/config.yml"

  local dotfiles_file="$HOME/dotfiles/.config/lazygit/config.yml"

  if ! [[ -d "$config_dir" ]]; then
    display_message "Creating lazygit config directory"

    if ! mkdir -p "$config_dir"; then
      display_error "Could not create lazygit config directory"
    fi
  fi

  if [[ -f "$config_file" ]]; then
    rm -rf "$config_file"

    display_message "Deleted existing $config_file file"
  fi

  if [[ -L "$config_file" ]]; then
    display_message "Config link file exists"
  else
    if ln -s "$dotfiles_file" "$config_file"; then
      display_message "Config file is linked"
    else
      display_error "Could not link config file"
    fi
  fi

  display_message "Setting lazygit complete"
}
