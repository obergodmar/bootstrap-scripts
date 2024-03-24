#!/usr/bin/env bash

UPDATE="sudo apt-get update"
INSTALL="sudo apt install -y"

update() {
  display_message "Updating..."

  $UPDATE
}

install_with_package_manager() {
  local packages=${@:1}
  local success="$packages are installed"

  display_message "Installing $packages..."

  if $INSTALL $packages; then
    display_message "$success"
  else
    display_error "$packages where NOT installed"
  fi
}

install_deb_package() {
  TMP=${TMP:-/tmp}

  local bin=$1
  local repo_name=$2
  local package_name=$3
  local success="$bin is installed"

  if exists $bin; then
    display_message "$success"

    return
  fi

  display_message "Installing $bin..."

  local version=$(get_version "$repo_name")
  if [[ -z $version ]]; then
    display_error "could not fetch latest version"

    return
  fi

  local arch=$(get_arch)
  if [[ $arch == "x86_64" ]]; then
    arch="amd64"
  elif [[ $arch == "32-bit" ]]; then
    arch="i686"
  fi

  local link="https://github.com/$repo_name/releases/latest/download/${package_name}_${version}_${arch}.deb"
  local tmp_file="$TMP/${bin}.deb"

  if curl -Lo "$tmp_file" "$link"; then
    display_message "$name deb package is downloaded"
  else
    display_error "could not download"

    rm $tmp_file
  fi

  if $INSTALL $tmp_file; then
    display_message "$success"
  else
    display_error "could not install deb package"
  fi

  rm $tmp_file
}
