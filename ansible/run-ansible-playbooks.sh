#!/usr/bin/env bash

cd "$(dirname -- "$0")"
roles_path="$(pwd -P)/roles:$(pwd -P)/playbooks/roles"

echo "Choose a playbook to run:"
select playbook in playbooks/*.yml; do
  [[ -z "${playbook}" ]] && continue
  ANSIBLE_ROLES_PATH="$roles_path" ansible-playbook -vv -i inventory/hosts.ini "${playbook}"
  break
done
