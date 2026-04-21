#!/usr/bin/env bash

cd "$(dirname -- "$0")"

ansible_args=("$@")

echo "Choose an option:"
select choice in "Install/Update galaxy roles" playbooks/*.yml; do
  [[ -z "${choice}" ]] && continue

  case "${choice}" in
    "Install/Update galaxy roles")
      if [[ -f requirements.yml ]] && command -v ansible-galaxy >/dev/null 2>&1; then
        ansible-galaxy role install -r requirements.yml -p roles
      else
        echo "requirements.yml or ansible-galaxy not found."
      fi
      continue
      ;;
  esac

  playbook="${choice}"

  extra=()
  if [[ "$(id -u)" -ne 0 ]] && [[ -z "${ANSIBLE_BECOME_PASS:-}" ]] && [[ -z "${ANSIBLE_BECOME_PASSWORD_FILE:-}" ]] \
    && grep -Eiq '^[[:space:]]*(become[[:space:]]*:[[:space:]]*(true|yes|1)|become_user[[:space:]]*:[[:space:]]*(root|0))\b' "$playbook"; then
    extra=(-K)
  fi

  ANSIBLE_ROLES_PATH="$(pwd -P)/roles:$(pwd -P)/playbooks/roles" ansible-playbook -vv -i inventory/hosts.ini "${extra[@]}" "${ansible_args[@]}" "$playbook"
  break
done
