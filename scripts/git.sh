#!/usr/bin/env bash

echo_run() {
  local command="$1 ${@:2}"

  echo "$command"

  $1 $2 $3 $4 "$5"
}

configure_git() {
  local server_name=$1

  display_message "Setting global .gitconfig..."

  local git_cmd="git config --global"

  echo_run $git_cmd user.name "Vitaly ($server_name)"
  echo_run $git_cmd user.email "obergodmar@gmail.com"

  echo_run $git_cmd core.editor "nvim"
  echo_run $git_cmd core.pager "delta"

  echo_run $git_cmd interactive.diffFilter "delta --color-only"

  echo_run $git_cmd merge.conflictstyle "diff3"

  echo_run $git_cmd diff.colorMoved "default"

  echo_run $git_cmd delta.true-color "always"
  echo_run $git_cmd delta.syntax-theme "Kanagawa"
  echo_run $git_cmd delta.features "decorations"
  echo_run $git_cmd delta.whitespace-error-style "22 reverse"
  echo_run $git_cmd delta.line-numbers "true"
  echo_run $git_cmd delta.navigate "true"
  echo_run $git_cmd delta.light "false"
  echo_run $git_cmd delta.file-style "blue"
  echo_run $git_cmd delta.minus-style "syntax '#43242B'"
  echo_run $git_cmd delta.minus-non-emph-style "syntax '#43242B'"
  echo_run $git_cmd delta.minus-emph-style "'#1F1F28' '#C34043'"
  echo_run $git_cmd delta.minus-empty-line-marker-style "normal '#43242B'"
  echo_run $git_cmd delta.zero-style "syntax"
  echo_run $git_cmd delta.plus-style "syntax '#2B3328'"
  echo_run $git_cmd delta.plus-non-emph-style "syntax '#2B3328'"
  echo_run $git_cmd delta.plus-emph-style "'#1F1F28' '#76946A'"
  echo_run $git_cmd delta.plus-empty-line-marker-style "normal '#2B3328'"
  echo_run $git_cmd delta.line-numbers-plus-style "green"
  echo_run $git_cmd delta.line-numbers-minus-style "red"
  echo_run $git_cmd delta.line-numbers-left-format "{nm: >4}┊"
  echo_run $git_cmd delta.line-numbers-right-format "{np: >4}┊"
  echo_run $git_cmd delta.line-numbers-left-style "red"
  echo_run $git_cmd delta.line-numbers-right-style "green"

  echo_run $git_cmd delta.decorations.commit-decoration-style "normal box ul"
  echo_run $git_cmd delta.decorations.file-style "normal ul"
  echo_run $git_cmd delta.decorations.file-decoration-style "normal box"
  echo_run $git_cmd delta.decorations.hunk-header-decoration-style "normal box ul"

  display_message "Setting global .gitconfig complete"
}
