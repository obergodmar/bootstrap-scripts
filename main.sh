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
    "unzip"
    "wget"
    "curl"
    "gzip"
    "tmux"
    "zsh"
    "gcc"
    "make"
    "cmake"
  )
  local ubuntu_tool_names=(
    "ripgrep"
    "fzf"
    "screen"
    "luarocks"
    "duf"
    "ncdu"
    "iftop"
    "vnstat"
    "qrencode"
    "autossh"
    "jq"
    "btop"
    "httpie"
    "trash-cli"
    "entr"
    "fd-find"
    "tar"
    "g++"
    "python3-pip"
    "libxml2-utils"
    "bsdmainutils"
    "wireguard"
    "python3"
    "mycli"
  )
  local macos_tool_names=(
    "ripgrep"
    "fzf"
    "screen"
    "luarocks"
    "duf"
    "ncdu"
    "iftop"
    "vnstat"
    "qrencode"
    "autossh"
    "jq"
    "btop"
    "httpie"
    "trash-cli"
    "entr"
    "fd"
    "gnu-tar"
    "lazygit"
    "bat"
    "git-delta"
    "python3"
    "mycli"
  )
  local windows_tool_names=(
    "mingw-w64-ucrt-x86_64-ripgrep"
    "mingw-w64-ucrt-x86_64-fzf"
    "mingw-w64-ucrt-x86_64-lua-luarocks"
    "mingw-w64-ucrt-x86_64-jq"
    "mingw-w64-ucrt-x86_64-python-send2trash"
    "mingw-w64-ucrt-x86_64-fd"
    "tar"
    "python"
    "mingw-w64-ucrt-x86_64-python-pip"
    "mingw-w64-ucrt-x86_64-bat"
    "mingw-w64-ucrt-x86_64-delta"
    "mingw-w64-ucrt-x86_64-rust"
    "mingw-w64-ucrt-x86_64-go"
  )

  if [[ $PACKAGE_MANAGER == "apt" ]]; then
    install_with_apt "${common_tool_names[@]}" "${ubuntu_tool_names[@]}"

    install_lazygit
    install_deb_package "bat" "sharkdp/bat" "bat"
    install_deb_package "delta" "dandavison/delta" "git-delta"

    python3 -m pip install --user libtmux
  elif [[ $PACKAGE_MANAGER == "brew" ]]; then
    install_with_brew "${common_tool_names[@]}" "${macos_tool_names[@]}"

    python3 -m pip install --user libtmux --break-system-packages
  elif [[ $PACKAGE_MANAGER == "pacman" ]]; then
    install_with_pacman "${common_tool_names[@]}" "${windows_tool_names[@]}"

    python3 -m pip install --user libtmux
  fi

  install_nvm

  if [[ $OS != "windows" ]]; then
    install_rust
    install_gvm
  fi

  install_ohmyzsh

  install_with_cargo "stylua" "stylua" "--features" "lua52"
  install_with_cargo "tree-sitter" "tree-sitter-cli"

  if [[ $(get_arch) == "x86_64" ]] && [[ $OS != 'windows' ]]; then
    install_with_cargo "bob" "bob-nvim"

    install_nvim
  fi

  install_with_cargo "eza" "eza"

  install_luacheck

  install_node
  install_with_npm yarn@1.22.19
  install_with_npm cspell
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

  if [[ $OS != "windows" ]]; then
    install_go
  fi
  install_with_go "shfmt" "mvdan.cc/sh/v3/cmd/shfmt@latest"
  install_with_go "lemonade" "github.com/lemonade-command/lemonade@latest"
  install_with_go "tmux-fastcopy" "github.com/abhinav/tmux-fastcopy@latest"
}

main
