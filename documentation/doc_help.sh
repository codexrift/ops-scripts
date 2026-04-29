#!/usr/bin/env bash
set -euo pipefail

doc_help() {
  local docs_root
  docs_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  if [[ $# -eq 0 ]]; then
    cat <<'EOF'
Usage: doc_help <term> [term2 ...]

Searches under the documentation folder (recursively) for:
- file name matches (case-insensitive substring)
- file content matches (case-insensitive fixed string)

Output: matching file paths relative to the documentation folder.
EOF
    return 0
  fi

  local all_files
  all_files="$(find "${docs_root}" -type f -print)"

  local tmpdir
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "${tmpdir}"' RETURN

  local i term
  i=0
  for term in "$@"; do
    i=$((i + 1))

    # 1) File name matches
    printf '%s\n' "${all_files}" \
      | grep -iF -- "${term}" \
      > "${tmpdir}/term_${i}.files.name" || true

    # 2) File content matches (treat as text; suppress errors for binary/permission)
    # -r: recursive, -l: list files, -i: ignore case, -F: fixed string
    # Use the doc root as the search base to avoid "argument list too long".
    grep -rliF -- "${term}" "${docs_root}" > "${tmpdir}/term_${i}.files.content" 2>/dev/null || true

    cat "${tmpdir}/term_${i}.files.name" "${tmpdir}/term_${i}.files.content" \
      | sort -u \
      > "${tmpdir}/term_${i}.files.any"
  done

  # Intersect results across all terms (AND semantics).
  cp "${tmpdir}/term_1.files.any" "${tmpdir}/result"
  if [[ $# -gt 1 ]]; then
    for ((i = 2; i <= $#; i++)); do
      comm -12 "${tmpdir}/result" "${tmpdir}/term_${i}.files.any" > "${tmpdir}/result.next" || true
      mv "${tmpdir}/result.next" "${tmpdir}/result"
    done
  fi

  # Print relative paths (to documentation root)
  sed "s#^${docs_root}/##" "${tmpdir}/result"
}

doc_help "$@"
