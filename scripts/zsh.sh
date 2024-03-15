#!/usr/bin/env bash

install_ohmyzsh() {
  local zsh_success="Oh my zsh is installed"

  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    display_message "$zsh_success"
  else
    local install_script=$(curl -fsSL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh")

    if sh -c $install_script "" --unattended; then
      display_message "$zsh_success"
    else
      display_error "Could not install ohmyzsh"
    fi
  fi

  # Installing zsh-autosuggestions zsh plugin
  local as_repo=https://github.com/obergodmar/zsh-autosuggestions
  local target="${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}/plugins/zsh-autosuggestions"
  local as_sucess="zsh plugin 'zsh-autosuggestions' is installed"

  if [[ -d $target ]]; then
    display_message "Pulling zsh autosuggestions"

    if ! git -C $target pull; then
      display_error "Could not pull zsh autosuggestions"
    fi
  else
    if git clone $as_repo $target; then
      display_message "$as_sucess"
    else
      display_error "zsh plugin 'zsh-autosuggestions' was NOT installed"
    fi
  fi
}
