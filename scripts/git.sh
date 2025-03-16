#!/usr/bin/env bash

echo_run() {
  local command="$1 ${@:2}"

  echo "$command"

  $1 $2 $3 $4 "$5"
}

configure_git() {
  display_message "Setting global .gitconfig..."

  local gitconfig="$HOME/.gitconfig"

  if [[ -f "$gitconfig" ]]; then
    display_warning "Global .gitconfig already exists"

    if mv "$gitconfig" "$gitconfig.old"; then
      display_message "Renamed existed .gitconfig to .gitconfig.old"
    fi
  fi

  local git_cmd="git config --global"

  # https://github.com/catppuccin/delta
  local delta_theme="$HOME/dotfiles/delta/themes/catppuccin.gitconfig"

  echo_run $git_cmd user.name "${GIT_USER_NAME:-"Vitaly ($SERVER_NAME)"}"
  echo_run $git_cmd user.email "${GIT_USER_EMAIL:-"obergodmar@gmail.com"}"

  echo_run $git_cmd core.editor "nvim"
  echo_run $git_cmd core.pager "delta"

  echo_run $git_cmd interactive.diffFilter "delta --color-only"

  echo_run $git_cmd merge.conflictStyle "zdiff3"

  echo_run $git_cmd include.path "$delta_theme"

  echo_run $git_cmd delta.features "catppuccin-macchiato"

  echo_run $git_cmd delta.navigate "true"

  display_message "Setting global .gitconfig complete"
}
