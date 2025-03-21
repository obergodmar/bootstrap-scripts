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
        sudo install -m 0754 -d /etc/apt/keyrings &&
            sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc &&
            sudo chmod a+r /etc/apt/keyrings/docker.asc &&
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

        if [[ $? -eq 0 ]]; then
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
