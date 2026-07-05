# mac-bootstrap

Public, non-secret bootstrap for a fresh macOS development machine.

This repository installs shared tooling only. Personal dotfiles, agent settings,
SSH host aliases, and service login recovery live in a separate private
repository.

## One-line Install

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/qdsfdhvh/mac-bootstrap/main/bootstrap.sh)"
```

## Local Layout

```text
~/Developer/Personal/mac-bootstrap
~/Developer/Personal/<private-dotfiles-repo>
~/.dotfiles -> ~/Developer/Personal/<private-dotfiles-repo>
```

## What This Installs

- Xcode Command Line Tools, when missing
- Homebrew
- Packages and apps in `Brewfile`
- mise runtimes from `mise.toml`
- agent CLIs: Codex via Homebrew, Claude Code and Pi via npm/mise fallback
- a new SSH key if `~/.ssh/id_ed25519` is missing
- the private dotfiles repository, when `DOTFILES_REPO` is provided or entered
  interactively after GitHub auth is available

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
gh repo create <owner>/<private-dotfiles-repo> --private
```

To keep the public bootstrap generic, the private repository URL is not
hardcoded. Provide it at install time:

```sh
DOTFILES_REPO=git@github.com:<owner>/<private-dotfiles-repo>.git \
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/qdsfdhvh/mac-bootstrap/main/bootstrap.sh)"
```
