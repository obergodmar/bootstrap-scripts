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

    local prepare_keyrings="sudo install -m 0754 -d /etc/apt/keyrings"
    local fetch_gpg_key="sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc"
    local prepare_docker_key="sudo chmod a+r /etc/apt/keyrings/docker.asc"
    local apt_repository="deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable"

    if ! [[ -f "/etc/apt/keyrings/docker.asc" ]]; then
        if prepare_keyrings && fetch_gpg_key && prepare_docker_key && echo "$apt_repository" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null; then
            display_message "Docker repository is successfully added"
        else
            display_error "Could not add docker repository"
            return
        fi
    else
        display_warning "Docker repository is already added"

        return
    fi

    update

    install_with_apt "docker-ce" "docker-ce-cli" "containerd.io" "docker-buildx-plugin" "docker-compose-plugin"
}
