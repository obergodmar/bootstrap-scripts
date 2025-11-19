#!/usr/bin/env bash

VENV_DIR="$HOME/.venv"

create_venv() {
  if [[ -d "$VENV_DIR" ]]; then
    display_message "Python virtual environment already exists at $VENV_DIR"

    return
  fi

  display_message "Creating Python virtual environment at $VENV_DIR..."

  if python3 -m venv "$VENV_DIR"; then
    display_message "Python virtual environment created at $VENV_DIR"
  else
    display_error "Could not create Python virtual environment at $VENV_DIR"
  fi
}

install_with_pip() {
  local package_name="$1"

  local pip="$VENV_DIR/bin/pip"

  local success="$package_name is installed"

  if [[ -f "$pip" ]]; then
    create_venv
  else
    display_error "Python virtual environment not found at $VENV_DIR"

    return
  fi

  if $pip show "$package_name" &>/dev/null; then
    display_message "$success"

    return
  fi

  display_message "Installing $package_name..."

  if $pip install "$package_name"; then
    display_message "$success"
  else
    display_error "Could not install $package_name"
  fi
}

uninstall_with_pip() {
  local package_name="$1"
  local pip="$VENV_DIR/bin/pip"
  local success="$package_name is uninstalled"

  if ! [[ -f "$pip" ]]; then
    display_message "Python virtual environment not found, $package_name cannot be uninstalled"
    return
  fi

  if ! $pip show "$package_name" &>/dev/null; then
    display_message "$package_name is not installed in virtual environment"
    return
  fi

  display_message "Uninstalling $package_name..."

  if $pip uninstall -y "$package_name" 2>/dev/null; then
    display_message "$success"
  else
    display_warning "Could not uninstall $package_name"
  fi
}

remove_python_environment() {
  display_message "Removing Python virtual environment..."

  # Remove virtual environment completely
  remove_file_or_directory "$VENV_DIR" "Python virtual environment"

  display_message "Python environment removal complete"
}
