#!/usr/bin/env bash
set -e

d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
t="${HOME}/.bashrc.custom"
rc="${HOME}/.bashrc"
line='[ -f "$HOME/.bashrc.custom/.bashrc" ] && . "$HOME/.bashrc.custom/.bashrc"'

if [[ "${1:-}" == "/disable" || "${1:-}" == "disable" || "${1:-}" == "--disable" ]]; then
  # Remove the source line (and the optional comment line just above it).
  if [[ -f "$rc" ]]; then
    tmp="$(mktemp)"
    awk -v l="$line" '
      { a[NR]=$0 }
      END {
        for (i=1; i<=NR; i++) {
          if (a[i] == l) {
            if (i > 1 && a[i-1] == "# bashrc custom") { a[i-1]="" }
            a[i] = ""
          }
        }
        for (i=1; i<=NR; i++) if (a[i] != "") print a[i]
      }
    ' "$rc" >"$tmp"
    mv "$tmp" "$rc"
  fi

  rm -f "$t/.bashrc" "$t/.cmdlist" 2>/dev/null || true
  rmdir "$t" 2>/dev/null || true
  echo "Disabled. Restart your shell or run: source \"$rc\""
  exit 0
fi

mkdir -p "$t"
cp -f "$d/.bashrc" "$t/.bashrc"
cp -f "$d/.cmdlist" "$t/.cmdlist"

chmod 700 "$t"
chmod 644 "$t/.bashrc" "$t/.cmdlist"

touch "$rc"
grep -Fqx "$line" "$rc" 2>/dev/null || printf '\n# bashrc custom\n%s\n' "$line" >> "$rc"

if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  # When sourced, reload into the current shell.
  # shellcheck disable=SC1090
  source "$rc" >/dev/null 2>&1 || true
else
  printf 'Run: source "%s"\n' "$rc"
fi
