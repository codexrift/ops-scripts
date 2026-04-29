_cmd_help_data() {
  cat "$(dirname "${BASH_SOURCE[0]}")/cmdlist"
}

# Compatibility: keep `cmd_help` as an alias for the fzf-powered picker.
cmd_help() {
  cmd_help_fzf "$@"
}

cmd_help_fzf() {
  if ! command -v fzf >/dev/null 2>&1; then
    printf '%s\n' "fzf is not installed. Install it (e.g., apt install fzf) or use cmd_help." >&2
    return 1
  fi

  local selection command_text query
  query="${*:-}"

  # Show full "command # comment" line and let both parts be searchable.
  selection="$(_cmd_help_data | fzf --layout=reverse --height=60% --prompt='cmd> ' ${query:+-q "$query"})" || true
  [[ -n "${selection}" ]] || return 0

  # Strip the comment for insertion; keep full line available in the UI.
  command_text="${selection%% # *}"
  command_text="${command_text%$'\r'}"

  if [[ "${READLINE_LINE+x}" == "x" ]]; then
    READLINE_LINE="${command_text}"
    READLINE_POINT=${#READLINE_LINE}
    return 0
  fi

  printf '%s\n' "${command_text}"
}

__cmd_help_fzf_widget() {
  cmd_help_fzf
}

# Bind Ctrl-x f to open cmd_help via fzf (bash/readline).
# Bind in common keymaps so it works in both emacs and vi modes.
if [[ -n "${BASH_VERSION-}" && $- == *i* ]]; then
  for keymap in emacs-standard emacs-meta vi-insert vi-command; do
    bind -m "${keymap}" -x '"\C-xf":__cmd_help_fzf_widget' 2>/dev/null || true
  done
fi
