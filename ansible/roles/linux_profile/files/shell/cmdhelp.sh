cmdhelp() {
  local use_color
  use_color=0

  if [[ -t 1 ]]; then
    use_color=1
    if command -v tput >/dev/null 2>&1; then
      if [[ "$(tput colors 2>/dev/null || echo 0)" -lt 8 ]]; then
        use_color=0
      fi
    fi
  fi

  if [[ $# -eq 0 ]]; then
    _cmdhelp_data | _cmdhelp_format "${use_color}"
  else
    local output term
    output="$(_cmdhelp_data)"
    for term in "$@"; do
      output="$(printf '%s\n' "${output}" | grep -iF -- "${term}" || true)"
      [[ -z "${output}" ]] && break
    done
    printf '%s\n' "${output}" | sed '/^$/d' | _cmdhelp_format "${use_color}"
  fi
}

_cmdhelp_format() {
  local use_color
  use_color="${1:-0}"

  awk -v color="${use_color}" '
    BEGIN {
      # Keep it subtle: command stays uncolored, comment is dimmed.
      cmdc  = ""
      hashc = "\033[2;90m" # dim dark gray
      comc  = "\033[2;37m" # dim light gray
      reset = "\033[0m"
    }
    {
      line = $0
      n = index(line, " # ")
      if (n == 0) { print line; next }

      cmd = substr(line, 1, n - 1)
      com = substr(line, n + 3)

      if (color == 1) {
        printf "%s%s%s %s#%s %s%s%s\n", cmdc, cmd, reset, hashc, reset, comc, com, reset
      } else {
        printf "%s # %s\n", cmd, com
      }
    }
  '
}

_cmdhelp_data() {
  cat "$(dirname "${BASH_SOURCE[0]}")/cmdlist"
}
