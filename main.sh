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
    "ncdu"
    "iftop"
    "vnstat"
    "qrencode"
    "autossh"
    "jq"
    "btop"
    "htop"
    "httpie"
    "trash-cli"
    "entr"
  )
  local ubuntu_tool_names=(
    "fd-find"
    "tar"
    "g++"
    "python3-pip"
    "libxml2-utils"
    "bsdmainutils"
    "wireguard"
  )
  local macos_tool_names=(
    "fd"
    "gnu-tar"
    "lazygit"
    "bat"
    "git-delta"
    "gnu-sed"
  )

  if [[ $PACKAGE_MANAGER == "apt" ]]; then
    add_apt_repository "ppa:git-core/ppa"
    install_with_apt "${common_tool_names[@]}" "${ubuntu_tool_names[@]}"

    install_lazygit
    install_deb_package "bat" "sharkdp/bat" "bat"
    install_deb_package "delta" "dandavison/delta" "git-delta"

  elif [[ $PACKAGE_MANAGER == "brew" ]]; then
    install_with_brew "${common_tool_names[@]}" "${macos_tool_names[@]}"
  fi

  install_nvm
  install_rust
  install_gvm

  install_ohmyzsh

  install_with_cargo "stylua" "stylua" "--features" "lua52"
  install_with_cargo "tree-sitter" "tree-sitter-cli"

  if [[ $(get_arch) == "x86_64" ]]; then
    install_with_cargo "bob" "bob-nvim"

    install_nvim
  fi

  install_with_cargo "eza" "eza"

  install_luacheck

  install_node
  install_with_npm yarn@1.22.19
  install_with_npm prettier

  install_bun
}

configure_tools() {
  configure_git
  configure_bat
  configure_lazygit
  configure_ohmyzsh
  configure_nvim
  configure_mycli
  configure_tmux
  python3 -m pip install --user libtmux
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
  install_with_go "tmux-fastcopy" "github.com/abhinav/tmux-fastcopy@latest"
}

main
