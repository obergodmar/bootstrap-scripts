#!/usr/bin/env bash

for script in ./scripts/*; do
  source $script
done

if [[ $(id -u) = 0 ]]; then
  display_error "The script should NOT be executed with root privileges"
  exit 1
fi

SERVER_NAME=$([[ -z $1 ]] && echo "obergodmar" || echo $1)
if [[ -z $1 ]]; then
  display_warning "Name for the server is NOT specified. Continue with '$SERVER_NAME'"
else
  display_message "Starting bootstrap script for server $SERVER_NAME"
fi

install_tools() {
  install_with_package_manager git
  install_with_package_manager bison
  install_with_package_manager rg
  install_with_package_manager fd-find fdfind
  install_with_package_manager fzf
  install_with_package_manager unzip
  install_with_package_manager wget
  install_with_package_manager curl
  install_with_package_manager gzip
  install_with_package_manager tar
  install_with_package_manager tmux
  install_with_package_manager screen
  install_with_package_manager zsh
  install_with_package_manager make
  install_with_package_manager cmake
  install_with_package_manager luarocks
  install_with_package_manager libxml2-utils
  install_with_package_manager mycli

  install_lazygit
  install_bat "$INSTALL"
  install_delta "$INSTALL"

  install_nvm
  install_rust
  install_gvm

  install_ohmyzsh

  install_with_cargo "stylua" "stylua" "--features lua52"
  install_with_cargo "tree-sitter" "tree-sitter-cli"
  install_with_cargo "bob" "bob-nvim"

  install_luacheck

  install_node
  install_with_npm yarn
  install_with_npm cspell
  install_with_npm prettier

  install_nvim
}

configure_tools() {
  configure_git "$SERVER_NAME"
  configure_bat
  configure_lazygit
  configure_ohmyzsh "$SERVER_NAME"
  configure_nvim
  configure_mycli
  configure_tmux
  configure_screen
  configure_lemonade
}

trap "display_error 'shutdown signal received'; exit 1" INT

main() {
  sleep 2

  update
  install_tools
  clone_dotfiles

  configure_tools

  install_go
  install_with_go "shfmt" "mvdan.cc/sh/v3/cmd/shfmt@latest"
  install_with_go "lemonade" "github.com/lemonade-command/lemonade@latest"
}

main
