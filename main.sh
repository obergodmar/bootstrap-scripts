#!/usr/bin/env bash

for script in ./scripts/*; do
  source $script
done

if [[ $(id -u) = 0 ]]; then
  display_warning "The script should NOT be executed with root privileges"
fi

if ! [[ -f '.env' ]]; then
  display_warning 'There is no .env file'
else
  source .env
fi

SERVER_NAME=${SERVER_NAME:-obergodmar}
display_message "Starting bootstrap script for server $SERVER_NAME"

OS=$(get_os)
if [[ $OS == "unsupported os" ]]; then
  display_error "$OS"

  exit 1
fi

PACKAGE_MANAGER=$(get_package_manager "$OS")
if [[ -z $PACKAGE_MANAGER ]]; then
  display_error "Cannot find a package manager for $OS"

  exit 1
fi

install_tools() {
  local common_tool_names=(
    "git"
    "bison"
    "ripgrep"
    "fzf"
    "unzip"
    "wget"
    "curl"
    "gzip"
    "tmux"
    "screen"
    "zsh"
    "gcc"
    "python3"
    "make"
    "cmake"
    "luarocks"
    "mycli"
    "duf"
    "iftop"
    "vnstat"
    "qrencode"
    "autossh"
    "jq"
    "btop"
  )
  local ubuntu_tool_names=(
    "fd-find"
    "tar"
    "g++"
    "python3-pip"
    "libxml2-utils"
    "bsdmainutils"
    "trash-cli"
    "wireguard"
    "libcurl4-gnutls-dev"
    "tidy"
  )
  local macos_tool_names=(
    "fd"
    "gnu-tar"
    "lazygit"
    "bat"
    "git-delta"
    "tidy-html5"
  )

  if [[ $PACKAGE_MANAGER == "apt" ]]; then
    install_with_apt "${common_tool_names[@]}" "${ubuntu_tool_names[@]}"

    install_lazygit
    install_deb_package "bat" "sharkdp/bat" "bat"
    install_deb_package "delta" "dandavison/delta" "git-delta"

    install_with_luarocks lua-curl "CURL_INCDIR=/usr/include/x87_64-linux-gnu"
    install_with_luarocks nvim-nio
    install_with_luarocks mimetypes
    install_with_luarocks xml2lua

    python3 -m pip install --user libtmux
  elif [[ $PACKAGE_MANAGER == "brew" ]]; then
    install_with_brew "${common_tool_names[@]}" "${macos_tool_names[@]}"

    python3 -m pip install --user libtmux --break-system-packages
  fi

  install_nvm
  install_rust
  install_gvm

  install_ohmyzsh

  install_with_cargo "stylua" "stylua" "--features" "lua52"
  install_with_cargo "tree-sitter" "tree-sitter-cli"
  install_with_cargo "bob" "bob-nvim"

  install_with_luarocks luacheck

  install_node
  install_with_npm yarn
  install_with_npm cspell
  install_with_npm prettier

  install_nvim
}

configure_tools() {
  configure_git
  configure_bat
  configure_lazygit
  configure_ohmyzsh
  configure_nvim
  configure_mycli
  configure_tmux
  configure_screen
  configure_lemonade
  configure_btop
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
