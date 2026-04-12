#!/usr/bin/env bash
set -e

is_sourced=0
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  is_sourced=1
fi

d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
t="${HOME}/.bashrc.custom"

mkdir -p "$t"
cp -f "$d/.bashrc" "$t/.bashrc"
cp -f "$d/.cmdlist" "$t/.cmdlist"

chmod 700 "$t"
chmod 644 "$t/.bashrc" "$t/.cmdlist"

touch "${HOME}/.bashrc"
l='[ -f "$HOME/.bashrc.custom/.bashrc" ] && . "$HOME/.bashrc.custom/.bashrc"'
grep -Fqx "$l" "${HOME}/.bashrc" 2>/dev/null || printf '\n# bashrc custom\n%s\n' "$l" >> "${HOME}/.bashrc"

printf 'Run: source "%s/.bashrc"\n' "${HOME}"