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

  display_message "Downloading $link"
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
  display_message "Setting lazygit..."

  link_config_file ".config/lazygit" "config.yml"

  display_message "Setting lazygit complete"
}
