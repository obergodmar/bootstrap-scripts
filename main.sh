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

display_message "Starting bootstrap script for server $(hostname)"

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
    "autossh"
    "jq"
    "btop"
    "htop"
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
    add_apt_repository "ppa:git-core/ppa" "git-core"
    install_with_apt "${common_tool_names[@]}" "${ubuntu_tool_names[@]}"

    install_lazygit
    install_deb_package "bat" "sharkdp/bat" "bat"

  elif [[ $PACKAGE_MANAGER == "brew" ]]; then
    install_with_brew "${common_tool_names[@]}" "${macos_tool_names[@]}"
  fi

  install_nvm
  install_rust

  if [[ $(get_arch) == "x86_64" ]]; then
    install_with_cargo "bob" "bob-nvim"

    install_nvim
  fi

  install_node
}

configure_tools() {
  configure_bat
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

  if ! [[ -z $INSTALL_DOCKER ]]; then
    install_docker
  fi

  clone_dotfiles

  configure_tools

  install_with_go "shfmt" "mvdan.cc/sh/v3/cmd/shfmt@latest"
  install_with_go "lemonade" "github.com/lemonade-command/lemonade@latest"
  install_with_go "tmux-fastcopy" "github.com/abhinav/tmux-fastcopy@latest"
}

main
