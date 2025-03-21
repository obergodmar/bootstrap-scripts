#!/usr/bin/env bash

get_package_manager() {
  local os=$1

  if [[ $os == "linux" ]] && exists apt; then
    echo "apt"
  elif [[ $os == "macos" ]] && exists brew; then
    echo "brew"
  fi
}

update_with_package_manager() {
  local cmd="$1"

  local success="Successfully updated"

  if $cmd; then
    display_message "$success"
  else
    display_error "could not update"
  fi

}

update() {
  display_message "Updating..."

  if [[ $PACKAGE_MANAGER == "apt" ]]; then
    update_with_package_manager "sudo apt-get update"
  elif [[ $PACKAGE_MANAGER == "brew" ]]; then
    update_with_package_manager "brew update"
  fi
}

install_with_package_manager() {
  local cmd=$1
  local packages=${2}
  local success="$packages are installed"

  display_message "Installing $packages..."

  if $cmd $packages; then
    display_message "$success"
  else
    display_error "$packages where NOT installed"
  fi
}

install_with_apt() {
  local packages=${@:1}

  install_with_package_manager "sudo apt install -y" "$packages"
}

add_apt_repository() {
  local repo=$1
  local apt_cache_name=$2

  display_message "Adding $repo repository..."

  if ! exists add-apt-repository; then
    install_with_apt software-properties-common
  fi

  if apt-cache policy | grep $apt_cache_name; then
    display_message "$repo repository is already added. Skipping..."

    return
  fi

  if sudo add-apt-repository -y $repo; then
    display_message "$repo repository added"
  else
    display_error "could not add repository"
  fi

  update
}

install_with_brew() {
  local packages="$@"

  install_with_package_manager "brew install" "$packages"
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

  display_message "Downloading $link"
  if curl -Lo "$tmp_file" "$link"; then
    display_message "$name deb package is downloaded"
  else
    display_error "could not download"

    rm $tmp_file
  fi

  if sudo apt install -y $tmp_file; then
    display_message "$success"
  else
    display_error "could not install deb package"
  fi

  rm $tmp_file
}
