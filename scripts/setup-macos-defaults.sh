#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

ensure_macos

warn "No macOS defaults are applied by default yet."
warn "Add only stable, desired settings here after testing them on an existing machine."

