cmdhelp() {
  local cmdhelp_dir cmdhelp_file query use_color

  cmdhelp_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
  cmdhelp_file="${cmdhelp_dir}/.cmdlist"
  query="$*"
  use_color=0

  if [[ -t 1 ]]; then
    use_color=1
    if command -v tput >/dev/null 2>&1; then
      if [[ "$(tput colors 2>/dev/null || echo 0)" -lt 8 ]]; then
        use_color=0
      fi
    fi
  fi

  {
    if [[ -z "${query}" ]]; then
      cat -- "${cmdhelp_file}"
    else
      grep -i -- "${query}" "${cmdhelp_file}"
    fi
  } | awk -v color="${use_color}" '
    BEGIN {
      cmdc="\033[1;36m";  # bold cyan
      comc="\033[2;37m";  # dim light gray
      hashc="\033[2;90m"; # dim dark gray
      reset="\033[0m";
    }
    {
      n = index($0, " # ");
      if (n == 0) { print; next; }
      cmd = substr($0, 1, n-1);
      com = substr($0, n+3);
      if (color == 1) {
        printf "%s%s%s %s#%s %s%s%s\n", cmdc, cmd, reset, hashc, reset, comc, com, reset;
      } else {
        print cmd " # " com;
      }
    }
  '
}
