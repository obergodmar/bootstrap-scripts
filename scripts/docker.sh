#!/usr/bin/env bash

install_docker() {
  display_message "Installing docker..."

  if ! [[ $PACKAGE_MANAGER == "apt" ]]; then
    display_error "Cannot install docker on $OS"

    return
  fi

  update

  install_with_apt "ca-certificates"

  display_message "Setting docker repository..."

  if ! [[ -f "/etc/apt/keyrings/docker.asc" ]]; then
    sudo install -m 0755 -d /etc/apt/keyrings &&
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc &&
      sudo chmod a+r /etc/apt/keyrings/docker.asc &&
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
      sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    if [[ $? -eq 0 ]]; then
      display_message "Docker repository is successfully added"
    else
      display_error "Could not add docker repository"
      return
    fi
  else
    display_warning "Docker repository is already added"
  fi

  update

  install_with_apt "docker-ce" "docker-ce-cli" "containerd.io" "docker-buildx-plugin" "docker-compose-plugin"
}

uninstall_docker() {
  display_message "Uninstalling docker..."

  if ! [[ $PACKAGE_MANAGER == "apt" ]]; then
    display_warning "Docker uninstall only supported on apt-based systems"
    return
  fi

  # Stop docker service
  display_message "Stopping docker service..."
  sudo systemctl stop docker 2>/dev/null || display_warning "Could not stop docker service"
  sudo systemctl disable docker 2>/dev/null || display_warning "Could not disable docker service"

  # Uninstall docker packages
  uninstall_with_apt "docker-ce" "docker-ce-cli" "containerd.io" "docker-buildx-plugin" "docker-compose-plugin" "docker-ce-rootless-extras"

  # Remove docker repository
  display_message "Removing docker repository..."
  sudo rm -f /etc/apt/sources.list.d/docker.list 2>/dev/null || display_warning "Docker repository file not found"
  sudo rm -f /etc/apt/keyrings/docker.asc 2>/dev/null || display_warning "Docker GPG key not found"

  # Remove docker directories
  remove_file_or_directory "/var/lib/docker" "docker data directory"
  remove_file_or_directory "/var/lib/containerd" "containerd data directory"
  remove_file_or_directory "$HOME/.docker" "docker user directory"

  # Update package cache
  update 2>/dev/null || true

  display_message "Docker uninstallation complete"
}
