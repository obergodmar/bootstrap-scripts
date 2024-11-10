#!/usr/bin/env bash

install_with_go() {
  local bin="$1"
  local link="$2"
  local success="$bin is installed"

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
