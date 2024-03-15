#!/usr/bin/env bash

install_ohmyzsh() {
  ZSH_SUCCESS="Oh my zsh is installed"

  if [[ -d ~/.oh-my-zsh ]]; then
    display_message "$ZSH_SUCCESS"
  else
    INSTALL_SCRIPT=$(curl -fsSL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh")
    if sh -c $INSTALL_SCRIPT "" --unattended; then
      display_message "$ZSH_SUCCESS"
    else
      display_error "Oh my zsh was NOT installed"
    fi
  fi

  # Installing zsh-autosuggestions zsh plugin
  ZSH_AS=https://github.com/obergodmar/zsh-autosuggestions
  TARGET=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  ZSH_AS_SUCCESS="zsh plugin 'zsh-autosuggestions' is installed"

  if [[ -d $TARGET ]]; then
    display_message "$ZSH_AS_SUCCESS"
  else
    if git clone $ZSH_AS $TARGET; then
      display_message "$ZSH_AS_SUCCESS"
    else
      display_error "zsh plugin 'zsh-autosuggestions' was NOT installed"
    fi
  fi
}
