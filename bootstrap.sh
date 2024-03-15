#!/usr/bin/env bash

TMP="/tmp"
SUPPORT_COLORS=$([[ "$?" == "0" ]] && [[ "$TERM" == "xterm"* ]])

display_message() {
  command -v tput &>/dev/null
  if $SUPPORT_COLORS; then
    # GREEN!
    tput sgr0
    tput setaf 2
    echo "$1"
    tput sgr0
  else
    echo "$1"
  fi
}

display_warning() {
  command -v tput &>/dev/null
  if $SUPPORT_COLORS; then
    # YELLOW!
    tput sgr0
    tput setaf 3
    echo "WARNING: $1"
    tput sgr0
  else
    echo "$1"
  fi
  return 1
}

display_error() {
  command -v tput &>/dev/null
  if $SUPPORT_COLORS; then
    tput sgr0
    tput setaf 1
    echo "ERROR: $1" >&2
    tput sgr0
  else
    echo "ERROR: $1" >&2
  fi
  return 1
}

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

UPDATE="sudo apt-get update"
INSTALL="sudo apt-get install -y"

exists() {
  command -v "$1" >/dev/null 2>&1
}

get_version() {
  return curl -s "https://api.github.com/repos/$1/releases/latest" | grep -Po '"tag_name": "v\K[^"]*'
}

update() {
  display_message "Updating..."
  $UPDATE
}

install_with_package_manager() {
  SUCCESS="$1 is installed"

  if [[ -z $2 ]] && exists $1 || exists $2; then
    display_message "$SUCCESS"

    return
  fi

  display_message "Installing $1..."
  if $INSTALL $1; then
    display_message "$SUCCESS"
  else
    display_error "$1 was NOT installed"
  fi
}

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

install_lazygit() {
  SUCCESS="lazygit is installed"

  if exists lazygit; then
    display_message "$SUCCESS"

    return
  fi

  display_message "Installing lazygit..."

  VERSION=$(get_version "jesseduffield/lazygit")
  LINK="https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${VERSION}_Linux_x86_64.tar.gz"
  TMP_FILE="$TMP/lazygit.tar.gz"
  DIST_FILE="$TMP/lazygit"

  if curl -Lo "$TMP_FILE" "$LINK"; then
    display_message "lazygit release file is downloaded"
  else
    display_error "could not download"

    return
  fi

  if tar xf $TMP_FILE -C $TMP; then
    display_message "lazygit is unpacked"
  else
    display_error "could not unpack file"

    rm $TMP_FILE
    return
  fi

  if sudo install $DIST_FILE /usr/local/bin; then
    display_message "$SUCCESS"
  else
    display_error "could not install unpacked file"
  fi

  rm $TMP_FILE
  rm $DIST_FILE
}

install_bat() {
  SUCCESS="bat is installed"

  if exists bat; then
    display_message "$SUCCESS"

    return
  fi

  display_message "Installing bat..."

  VERSION=$(get_version "sharkdp/bat")
  LINK="https://github.com/sharkdp/bat/releases/latest/download/bat_${VERSION}_amd64.deb"
  TMP_FILE="$TMP/bat.deb"

  if curl -Lo "$TMP_FILE" "$LINK"; then
    display_message "bat deb package is downloaded"
  else
    display_error "could not download"

    rm $TMP_FILE
  fi

  if sudo apt install $TMP_FILE; then
    display_message "$SUCCESS"
  else
    display_error "could not install deb package"
  fi

  rm $TMP_FILE
}

install_nvm() {
  SUCCESS="nvm is installed"

  if exists nvm; then
    display_message "$SUCCESS"

    return
  fi

  display_message "Installing nvm..."

  VERSION=$(get_version "nvm-sh/nvm")
  INSTALL_SCRIPT=$(curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${VERSION}/install.sh")

  if PROFILE=/dev/null bash -c $INSTALL_SCRIPT; then
    display_message "$SUCCESS"
  else
    display_error "could not install nvm"
  fi
}

main() {
  update
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

  install_lazygit
  install_bat

  install_ohmyzsh

  install_nvm
}

main
