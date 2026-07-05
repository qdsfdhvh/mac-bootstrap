#!/usr/bin/env bash

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

confirm() {
  local prompt="${1:-Continue?}"
  local answer
  read -r -p "$prompt [y/N] " answer
  [[ "$answer" == "y" || "$answer" == "Y" || "$answer" == "yes" || "$answer" == "YES" ]]
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
  local current_dir="$1"
  shift
  mkdir -p "$PERSONAL_ROOT"

  if [[ -f "$current_dir/Brewfile" && "$current_dir" == "$BOOTSTRAP_ROOT" ]]; then
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

  if [[ "$current_dir" != "$BOOTSTRAP_ROOT" ]]; then
    exec "$BOOTSTRAP_ROOT/bootstrap.sh" "$@"
  fi
}
