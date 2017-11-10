#!/bin/bash
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ANSIBLE_DIR="${SOURCE_DIR}/../ansible"
GALAXY_REQUIREMENTS_PATH="${ANSIBLE_DIR}/requirements.yml"
GALAXY_ROLES_PATH="${ANSIBLE_DIR}/galaxy_roles"

echo "Installing ansible-galaxy roles..."
ansible-galaxy install --role-file="${GALAXY_REQUIREMENTS_PATH}" --roles-path="${GALAXY_ROLES_PATH}" --force

echo "Running playbook..."
ANSIBLE_ROLES_PATH="${GALAXY_ROLES_PATH}" ansible-playbook -v -i "localhost," -c local ansible/macosx-rea.yml
