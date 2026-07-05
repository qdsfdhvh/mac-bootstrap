#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PERSONAL_ROOT="${PERSONAL_ROOT:-$HOME/Developer/Personal}"
BOOTSTRAP_REPO="${BOOTSTRAP_REPO:-https://github.com/qdsfdhvh/mac-bootstrap.git}"
BOOTSTRAP_ROOT="${BOOTSTRAP_ROOT:-$PERSONAL_ROOT/mac-bootstrap}"

info() {
  printf '\033[34m==>\033[0m %s\n' "$*"
}

success() {
  printf '\033[32mOK\033[0m %s\n' "$*"
}

warn() {
  printf '\033[33mWARN\033[0m %s\n' "$*" >&2
}

fail() {
  printf '\033[31mFAIL\033[0m %s\n' "$*" >&2
  exit 1
}

have() {
  command -v "$1" >/dev/null 2>&1
}

ensure_macos() {
  [[ "$(uname -s)" == "Darwin" ]] || fail "This bootstrap currently supports macOS only"
}

ensure_xcode_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    return
  fi

  warn "Xcode Command Line Tools are missing"
  xcode-select --install || true
  fail "Finish the Xcode Command Line Tools installer, then rerun bootstrap.sh"
}

ensure_homebrew() {
  if ! have brew; then
    info "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  have brew || fail "Homebrew install finished but brew is still not on PATH"
}

ensure_git() {
  if have git; then
    return
  fi

  info "Installing git"
  brew install git
}

ensure_bootstrap_checkout() {
  mkdir -p "$PERSONAL_ROOT"

  if [[ -f "$SCRIPT_DIR/Brewfile" && "$SCRIPT_DIR" == "$BOOTSTRAP_ROOT" ]]; then
    return
  fi

  if [[ -d "$BOOTSTRAP_ROOT/.git" ]]; then
    info "Updating $BOOTSTRAP_ROOT"
    git -C "$BOOTSTRAP_ROOT" pull --ff-only
  elif [[ ! -e "$BOOTSTRAP_ROOT" ]]; then
    info "Cloning $BOOTSTRAP_REPO to $BOOTSTRAP_ROOT"
    git clone "$BOOTSTRAP_REPO" "$BOOTSTRAP_ROOT"
  else
    fail "$BOOTSTRAP_ROOT exists but is not a git checkout"
  fi

  exec "$BOOTSTRAP_ROOT/bootstrap.sh" "$@"
}

ensure_macos
ensure_xcode_clt
ensure_homebrew
ensure_git
ensure_bootstrap_checkout "$@"

source "$SCRIPT_DIR/scripts/lib.sh"

info "Installing Homebrew bundle"
brew bundle --file "$BOOTSTRAP_ROOT/Brewfile"

info "Installing mise runtimes"
if have mise; then
  mise trust "$BOOTSTRAP_ROOT/mise.toml" >/dev/null 2>&1 || true
  mise install -y -C "$BOOTSTRAP_ROOT"
else
  fail "mise is not available after brew bundle"
fi

"$BOOTSTRAP_ROOT/scripts/install-agent-clis.sh"
"$BOOTSTRAP_ROOT/scripts/setup-ssh.sh"
"$BOOTSTRAP_ROOT/scripts/bootstrap-private.sh"

success "mac-bootstrap complete"
