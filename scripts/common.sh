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

exists() {
  command -v "$1" >/dev/null 2>&1
}

get_version() {
  local repo=$1
  local link="https://api.github.com/repos/$repo/releases/latest"
  local version=$(curl -s $link | grep -Po '"tag_name": "v?\K[^"]*')

  echo $version
}
