
prompt_context_no_sudo_check () {
  local current_state="DEFAULT"
  typeset -AH context_states
  context_states=("ROOT" "yellow" "SUDO" "red" "DEFAULT" "white" "REMOTE" "green" "REMOTE_SUDO" "yellow")
  local content=""
  if [[ "$POWERLEVEL9K_ALWAYS_SHOW_CONTEXT" == true ]] || [[ "$(whoami)" != "$DEFAULT_USER" ]] || [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
    content="${POWERLEVEL9K_CONTEXT_TEMPLATE}"
  elif [[ "$POWERLEVEL9K_ALWAYS_SHOW_USER" == true ]]; then
    content="$(whoami)"
  else
    return
  fi
  if [[ $(print -P "%#") == '#' ]]; then
    current_state="ROOT"
  elif [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
    # if sudo -n true 2> /dev/null
    # then
    # 	current_state="REMOTE_SUDO"
    # else
    current_state="REMOTE"
    # fi
  # elif sudo -n true 2> /dev/null; then
  #   current_state="SUDO"
  fi
  "$1_prompt_segment" "${0}_${current_state}" "$2" "$DEFAULT_COLOR" "${context_states[$current_state]}" "${content}"
}

###
# !!!
# https://github.com/bhilburn/powerlevel9k/issues/852
