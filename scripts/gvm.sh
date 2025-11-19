#!/usr/bin/env bash

install_gvm() {
  local success="gvm is installed"
  local gvm_dir="$HOME/.gvm"

  if [[ -d "$gvm_dir" ]]; then
    display_message "$success"

    return
  fi

  display_message "Installing gvm..."

  local install_script=$(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)

  if echo "$install_script" | bash; then
    display_message "$success"
  else
    display_error "could not install gvm"
  fi
}

source_gvm() {
  local gvm="$HOME/.gvm/scripts/gvm"

  if ! [[ -s "$HOME/.gvm/scripts/gvm" ]]; then
    install_gvm
  fi

  source "$gvm"
}

install_go() {
  local success="go is installed"

  source_gvm

  display_message "Installing go..."

  if gvm install go1.22.0 -B; then
    display_message "$success"
  else
    display_error "could not install go"
  fi

  if gvm alias create default go1.22.0; then
    display_message "Setting go1.22.0 as default version"
  else
    display_error "could not set default version go"
  fi
}

install_with_go() {
  local bin="$1"
  local link="$2"
  local success="$bin is installed"

  source_gvm

  if exists "$bin"; then
    display_message "$success"

    return
  fi

  display_message "Installing $bin..."

  if go install "$link"; then
    display_message "$success"
  else
    display_error "could not install $bin"
  fi
}

uninstall_gvm() {
  display_message "Uninstalling gvm and go..."

  local gvm_dir="$HOME/.gvm"
  remove_file_or_directory "$gvm_dir" "gvm directory"

  # Remove go workspace if exists
  remove_file_or_directory "$HOME/go" "go workspace directory"

  display_message "gvm and go uninstallation complete"
}

uninstall_with_go() {
  local bin="$1"
  local link="$2"
  local success="$bin is uninstalled"

  if ! exists "$bin"; then
    display_message "$bin is not installed"
    return
  fi

  # Try to remove the binary from go/bin
  local tool_path=$(which "$bin" 2>/dev/null)
  if [[ -n "$tool_path" ]] && ([[ "$tool_path" == *"go/bin/"* ]] || [[ "$tool_path" == *".gvm/"* ]]); then
    display_message "Removing $bin..."
    if rm -f "$tool_path" 2>/dev/null; then
      display_message "$success"
    else
      display_warning "Could not remove $bin"
    fi
  else
    display_message "$bin was not installed via go install or not found in go path"
  fi
}
