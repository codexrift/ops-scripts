#!/usr/bin/env bash
set -e

cd "$(dirname -- "$0")"

inventory_file="${INVENTORY:-inventory/hosts.ini}"
playbook_path="${1:-}"
[[ $# -gt 0 ]] && shift || true

if [[ -z "${playbook_path}" ]]; then
  echo "Choose playbook:" >&2
  select playbook_path in playbooks/*.yml; do break; done
fi

exec ansible-playbook -i "${inventory_file}" "${playbook_path}" "$@"
