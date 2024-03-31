#!/usr/bin/env bash

install_ohmyzsh() {
  local zsh_success="Oh my zsh is installed"
  local ohmyzsh="$HOME/.oh-my-zsh"

  if [[ -d "$ohmyzsh" ]]; then
    display_message "$zsh_success"
  else
    local repo="https://github.com/ohmyzsh/ohmyzsh.git"

    if git clone "$repo" "$ohmyzsh"; then
      display_message "$zsh_success"
    else
      display_error "Could not install ohmyzsh"
    fi
  fi

  # Installing zsh-autosuggestions zsh plugin
  local as_repo=https://github.com/obergodmar/zsh-autosuggestions
  local target="${ZSH_CUSTOM:-"$ohmyzsh/custom"}/plugins/zsh-autosuggestions"
  local as_sucess="zsh plugin 'zsh-autosuggestions' is installed"

  if [[ -d $target ]]; then
    display_message "Pulling zsh autosuggestions"

    if ! git -C $target pull; then
      display_error "Could not pull zsh autosuggestions"
    fi
  else
    if git clone $as_repo $target; then
      display_message "$as_sucess"
    else
      display_error "zsh plugin 'zsh-autosuggestions' was NOT installed"
    fi
  fi
}

configure_ohmyzsh() {
  display_message "Setting ohmyzsh..."

  local obergodmar_theme="$HOME/.oh-my-zsh/themes/obergodmar.zsh-theme"
  if [[ -f "$obergodmar_theme" ]]; then
    display_message "ohmyzsh theme exists. Renaming..."

    if mv "$obergodmar_theme" "$obergodmar_theme.old"; then
      display_message "Renamed existed theme file to $obergodmar_theme.old"
    fi
  fi

  display_message "Creating ohmyzsh theme"
  if touch "$obergodmar_theme"; then
    cat >$obergodmar_theme <<EOF
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{\$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{\$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{\$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{\$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_RUBY_PROMPT_PREFIX="%{\$fg_bold[red]%}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{\$reset_color%}"

PROMPT='
%{\$fg_bold[green]%}%~%{\$reset_color%}\$(git_prompt_info)\$(virtualenv_prompt_info) ${OH_MY_ZSH_NAME:-$SERVER_NAME} ⌚ %{\$fg_bold[red]%}%*%{\$reset_color%}
$ '

RPROMPT='\$(ruby_prompt_info)'

VIRTUAL_ENV_DISABLE_PROMPT=0
ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX=" %{\$fg[green]%}🐍"
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="%{\$reset_color%}"
ZSH_THEME_VIRTUALENV_PREFIX=\$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX
ZSH_THEME_VIRTUALENV_SUFFIX=\$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX
EOF

    display_message "ohmyzsh theme created"
  else
    display_error "could not create theme file"
  fi

  link_config_file "." ".zshrc"

  display_message "Setting ohmyzsh complete"

  if [[ $SHELL == */zsh ]]; then
    display_message "zsh is default shell"

    return
  fi

  display_message "Setting zsh as default shell"
  if chsh -s $(which zsh); then
    display_message "zsh is default shell"
  else
    display_error "could not set zsh as default shell"
  fi
}
