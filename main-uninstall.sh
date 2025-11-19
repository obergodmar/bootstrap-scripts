#!/usr/bin/env bash

for script in ./scripts/*; do
  source $script
done

if [[ $(id -u) = 0 ]]; then
  display_warning "The uninstall script should NOT be executed with root privileges"
fi

if ! [[ -f '.env' ]]; then
  display_warning 'There is no .env file'
else
  source .env
fi

SERVER_NAME=${SERVER_NAME:-obergodmar}
display_message "Starting uninstall script for server $SERVER_NAME"

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

uninstall_tools() {
  display_message "Starting tools uninstallation..."

  # Uninstall tools exactly as they were installed in main.sh

  # Go tools (matching install_with_go calls in main.sh)
  uninstall_with_go "shfmt" "mvdan.cc/sh/v3/cmd/shfmt@latest"
  uninstall_with_go "lemonade" "github.com/lemonade-command/lemonade@latest"
  uninstall_with_go "tmux-fastcopy" "github.com/abhinav/tmux-fastcopy@latest"

  # Node tools (matching install_with_npm calls in main.sh)
  uninstall_with_npm "yarn@1.22.19"
  uninstall_with_npm "prettier"

  # Python tools (matching install_with_pip calls in main.sh)
  uninstall_with_pip "libtmux"
  uninstall_with_pip "mdformat"

  # Cargo tools (matching install_with_cargo calls in main.sh)
  uninstall_with_cargo "stylua" "stylua"
  uninstall_with_cargo "tree-sitter" "tree-sitter-cli"
  if [[ $(get_arch) == "x86_64" ]]; then
    uninstall_with_cargo "bob" "bob-nvim"
  fi
  uninstall_with_cargo "eza" "eza"

  # Uninstall version managers and their environments
  uninstall_gvm
  uninstall_nvm_and_node
  uninstall_rust_and_cargo
  uninstall_bun
  remove_python_environment

  # Uninstall system packages
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
    uninstall_with_apt "${common_tool_names[@]}" "${ubuntu_tool_names[@]}"
    uninstall_deb_packages
    remove_apt_repositories
  elif [[ $PACKAGE_MANAGER == "brew" ]]; then
    uninstall_with_brew "${common_tool_names[@]}" "${macos_tool_names[@]}"
  fi

  if ! [[ -z $INSTALL_DOCKER ]]; then
    uninstall_docker
  fi
}

remove_configurations() {
  display_message "Removing configurations..."

  remove_git_config
  remove_bat_config
  remove_lazygit_config
  remove_ohmyzsh_config
  remove_nvim_config
  remove_mycli_config
  remove_tmux_config
  remove_screen_config
  remove_lemonade_config
  remove_btop_config
}

cleanup_dotfiles() {
  display_message "Cleaning up dotfiles..."
  remove_dotfiles
}

trap "display_error 'shutdown signal received'; exit 1" INT

main() {
  sleep 2

  display_warning "This will remove all installed tools and configurations!"
  read -p "Are you sure you want to continue? (y/N): " -n 1 -r
  echo

  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    display_message "Uninstall cancelled"
    exit 0
  fi

  remove_configurations
  cleanup_dotfiles
  uninstall_tools

  display_message "Uninstall completed!"
  display_warning "You may need to restart your shell or system to complete the removal"
}

main
