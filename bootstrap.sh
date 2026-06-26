#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This setup only supports macOS." >&2
  exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Xcode Command Line Tools are required."
  echo "Opening installer..."
  xcode-select --install
  echo "Complete the installer dialog, then re-run ./bootstrap.sh"
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

eval "$(brew shellenv)"

export HOMEBREW_NO_INSTALL_CONFIRMATION=1

if ! command -v ansible-playbook >/dev/null 2>&1; then
  echo "Installing Ansible..."
  brew install ansible
fi

ansible-galaxy collection install -r requirements.yml

if [[ -z "${HOMEBREW_SUDO_PASSWORD:-}" ]]; then
  read -rsp "Contraseña de macOS (para instalar apps en /Applications): " HOMEBREW_SUDO_PASSWORD
  echo
fi

ansible-playbook playbook.yml \
  --extra-vars "homebrew_sudo_password=${HOMEBREW_SUDO_PASSWORD}" \
  "$@"

unset HOMEBREW_SUDO_PASSWORD
