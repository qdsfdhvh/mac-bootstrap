# mac-bootstrap

Public, non-secret bootstrap for a fresh macOS development machine.

This repository installs shared tooling only. Personal dotfiles, agent settings,
SSH host aliases, and service login recovery live in the private
`qdsfdhvh/dotfiles-private` repository.

## One-line Install

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/qdsfdhvh/mac-bootstrap/main/bootstrap.sh)"
```

## Local Layout

```text
~/Developer/Personal/mac-bootstrap
~/Developer/Personal/dotfiles-private
~/.dotfiles -> ~/Developer/Personal/dotfiles-private
```

## What This Installs

- Xcode Command Line Tools, when missing
- Homebrew
- Packages and apps in `Brewfile`
- mise runtimes from `mise.toml`
- agent CLIs: Codex via Homebrew, Claude Code and Pi via npm/mise fallback
- a new SSH key if `~/.ssh/id_ed25519` is missing
- the private dotfiles repository, after GitHub auth is available

## What This Must Not Contain

- SSH private keys
- API tokens
- `.env` files
- company VPN secrets
- agent session history

## Useful Commands

```sh
./bootstrap.sh
./scripts/setup-ssh.sh
./scripts/install-agent-clis.sh
./scripts/bootstrap-private.sh
```

To create the companion private repository:

```sh
gh repo create qdsfdhvh/dotfiles-private --private
```

