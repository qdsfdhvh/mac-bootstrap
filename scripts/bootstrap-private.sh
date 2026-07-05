#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

PERSONAL_ROOT="${PERSONAL_ROOT:-$HOME/Developer/Personal}"
DOTFILES_REPO="${DOTFILES_REPO:-git@github.com:qdsfdhvh/dotfiles-private.git}"
DOTFILES_ROOT="${DOTFILES_ROOT:-$PERSONAL_ROOT/dotfiles-private}"
DOTFILES_LINK="${DOTFILES_LINK:-$HOME/.dotfiles}"

mkdir -p "$PERSONAL_ROOT"

if ! have gh; then
  fail "GitHub CLI is required before bootstrapping private dotfiles"
fi

if ! gh auth status >/dev/null 2>&1; then
  info "Logging in to GitHub"
  gh auth login
fi

if [[ -d "$DOTFILES_ROOT/.git" ]]; then
  info "Updating $DOTFILES_ROOT"
  git -C "$DOTFILES_ROOT" pull --ff-only
elif [[ ! -e "$DOTFILES_ROOT" ]]; then
  info "Cloning $DOTFILES_REPO to $DOTFILES_ROOT"
  git clone "$DOTFILES_REPO" "$DOTFILES_ROOT"
else
  fail "$DOTFILES_ROOT exists but is not a git checkout"
fi

ln -sfn "$DOTFILES_ROOT" "$DOTFILES_LINK"
success "Linked $DOTFILES_LINK -> $DOTFILES_ROOT"

if [[ -x "$DOTFILES_ROOT/install.sh" ]]; then
  "$DOTFILES_ROOT/install.sh"
else
  warn "$DOTFILES_ROOT/install.sh is missing or not executable"
fi

