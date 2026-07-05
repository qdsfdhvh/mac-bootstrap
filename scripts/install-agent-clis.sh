#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

ensure_homebrew

if ! have codex; then
  info "Installing Codex via Homebrew cask"
  brew install --cask codex || warn "Codex install failed; install manually from https://github.com/openai/codex"
fi

if ! have mise; then
  fail "mise is required before installing npm-based agent CLIs"
fi

info "Ensuring Node is installed through mise"
mise install -y node@latest

install_npm_global() {
  local binary="$1"
  local package="$2"

  if have "$binary"; then
    success "$binary already installed"
    return
  fi

  info "Installing $package"
  if ! mise exec node@latest -- npm install -g "$package"; then
    warn "Failed to install $package; install $binary manually"
  fi
}

install_npm_global "claude" "@anthropic-ai/claude-code"
install_npm_global "pi" "@earendil-works/pi-coding-agent"

if have rtk; then
  success "rtk installed: $(rtk --version)"
else
  info "Installing rtk"
  brew install rtk || warn "Failed to install rtk"
fi

