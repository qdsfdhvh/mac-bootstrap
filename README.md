# mac-bootstrap

Public, non-secret bootstrap for a fresh macOS development machine.

This repo is intentionally boring: it installs the common tools needed to start
working on a new Mac. It does not contain personal dotfiles, SSH private keys,
API tokens, project-specific secrets, or agent session history.

## Install

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/qdsfdhvh/mac-bootstrap/main/bootstrap.sh)"
```

## Optional Private Layer

If you maintain a separate private dotfiles repository, pass it at install time:

```sh
DOTFILES_REPO=git@github.com:<owner>/<repo>.git \
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/qdsfdhvh/mac-bootstrap/main/bootstrap.sh)"
```

Without `DOTFILES_REPO`, the bootstrap installs public tooling and skips the
private dotfiles step.

## What It Does

- Installs Xcode Command Line Tools when missing
- Installs Homebrew when missing
- Installs minimal bootstrap tools from `Brewfile.base`
- Creates a new SSH key if `~/.ssh/id_ed25519` is missing
- Optionally clones and runs a private dotfiles installer
- Installs the rest of the public tools from `Brewfile`

The ordering is intentional: shell/Git/SSH/mise dotfiles should be restored
before the broader tool install. Set `BOOTSTRAP_SKIP_TOOLS=1` to stop after the
minimal bootstrap and private dotfiles layer.

## Local Checkout

The bootstrap keeps its local checkout at:

```text
~/Developer/Personal/mac-bootstrap
```

## Safety Boundary

Do not add secrets here:

- SSH private keys
- API tokens
- `.env` files
- VPN credentials
- personal/private repo names that do not need to be public
- agent session history
