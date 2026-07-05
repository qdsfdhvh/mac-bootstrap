#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

SSH_DIR="$HOME/.ssh"
SSH_KEY_PATH="${SSH_KEY_PATH:-$SSH_DIR/id_ed25519}"
SSH_EMAIL="${SSH_EMAIL:-}"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

if [[ -z "$SSH_EMAIL" ]] && have git; then
  SSH_EMAIL="$(git config --global user.email || true)"
fi

if [[ -f "$SSH_KEY_PATH" ]]; then
  success "SSH key already exists: $SSH_KEY_PATH"
else
  if [[ -z "$SSH_EMAIL" ]]; then
    read -r -p "Email/comment for new SSH key: " SSH_EMAIL
  fi

  info "Generating $SSH_KEY_PATH"
  ssh-keygen -t ed25519 -C "$SSH_EMAIL" -f "$SSH_KEY_PATH"
fi

chmod 600 "$SSH_KEY_PATH" 2>/dev/null || true
chmod 644 "$SSH_KEY_PATH.pub" 2>/dev/null || true

if have ssh-add; then
  ssh-add --apple-use-keychain "$SSH_KEY_PATH" >/dev/null 2>&1 || ssh-add "$SSH_KEY_PATH" >/dev/null 2>&1 || true
fi

if have pbcopy && [[ -f "$SSH_KEY_PATH.pub" ]]; then
  pbcopy < "$SSH_KEY_PATH.pub"
  success "Public key copied to clipboard. Add it to GitHub/GitLab before cloning private repos."
else
  warn "Public key path: $SSH_KEY_PATH.pub"
fi

