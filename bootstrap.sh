#!/usr/bin/env bash

# Takes a fresh Mac from a cloned repo to an active nix-darwin configuration.
# Run this once. Use ./rebuild.sh for later changes.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_LINK="$HOME/.dotfiles"
ZSHRC_LOCAL="$HOME/.zshrc.local"
SDKMAN_DIR_PATH="$HOME/.sdkman"

echo "==> Step 1: Determinate Nix"
if command -v nix >/dev/null 2>&1; then
  echo "    Nix already exists, skipping installation."
else
  curl --proto '=https' --tlsv1.2 -sSf -L \
    https://install.determinate.systems/nix |
    sh -s -- install --no-confirm

  NIX_DAEMON_PROFILE="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
  if [ ! -r "$NIX_DAEMON_PROFILE" ]; then
    echo "Determinate Nix was installed, but $NIX_DAEMON_PROFILE is unavailable." >&2
    exit 1
  fi

  # shellcheck disable=SC1090
  . "$NIX_DAEMON_PROFILE"
fi

NIX_BIN="$(command -v nix || true)"
if [ -z "$NIX_BIN" ]; then
  echo "Nix is unavailable after installation." >&2
  exit 1
fi
echo "    Using $("$NIX_BIN" --version)."

echo "==> Step 2: link this repo at ~/.dotfiles"
if [ -e "$DOTFILES_LINK" ] && [ "$DIR" -ef "$DOTFILES_LINK" ]; then
  echo "    $DOTFILES_LINK already points to this repo."
elif [ -L "$DOTFILES_LINK" ]; then
  ln -sfn "$DIR" "$DOTFILES_LINK"
  echo "    Updated $DOTFILES_LINK -> $DIR."
elif [ -e "$DOTFILES_LINK" ]; then
  echo "$DOTFILES_LINK already exists and is not this repo; refusing to replace it." >&2
  exit 1
else
  ln -s "$DIR" "$DOTFILES_LINK"
  echo "    Created $DOTFILES_LINK -> $DIR."
fi

echo "==> Step 3: personalize the configured username"
# Resolve the real user before any sudo command can change the execution context.
REAL_USER="$(whoami)"
FLAKE_USER="$(sed -nE 's/^[[:space:]]*user = "([^"]+)";.*/\1/p' "$DIR/flake.nix" | head -n1)"

if [ -z "$FLAKE_USER" ]; then
  echo "Could not find the single \"user =\" line in flake.nix." >&2
  exit 1
elif [ "$FLAKE_USER" != "$REAL_USER" ]; then
  echo "    flake.nix is configured for \"$FLAKE_USER\", but the current user is \"$REAL_USER\"."
  read -r -p "    Rewrite flake.nix for \"$REAL_USER\"? [y/N] " REPLY

  if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
    sed -i '' -E "s/^([[:space:]]*user = \")[^\"]+(\";.*)/\1${REAL_USER}\2/" "$DIR/flake.nix"
    echo "    Updated flake.nix."
  else
    echo "No changes made. Update flake.nix before running bootstrap again." >&2
    exit 1
  fi
else
  echo "    flake.nix already matches \"$REAL_USER\"."
fi

echo "==> Step 4: local shell setup"
if [ ! -e "$ZSHRC_LOCAL" ]; then
  touch "$ZSHRC_LOCAL"
  echo "    Created $ZSHRC_LOCAL."
else
  echo "    $ZSHRC_LOCAL already exists."
fi

if [ ! -s "$SDKMAN_DIR_PATH/bin/sdkman-init.sh" ]; then
  (
    SDKMAN_INSTALL_HOME="$(mktemp -d)"
    trap 'rm -rf "$SDKMAN_INSTALL_HOME"' EXIT

    curl --proto '=https' --tlsv1.2 -fsSL https://get.sdkman.io \
      -o "$SDKMAN_INSTALL_HOME/install-sdkman.sh"

    HOME="$SDKMAN_INSTALL_HOME" \
    ZDOTDIR="$SDKMAN_INSTALL_HOME" \
    SDKMAN_DIR="$SDKMAN_DIR_PATH" \
      bash "$SDKMAN_INSTALL_HOME/install-sdkman.sh"
  )

  if [ ! -s "$SDKMAN_DIR_PATH/bin/sdkman-init.sh" ]; then
    echo "SDKMAN installation failed." >&2
    exit 1
  fi

  echo "    Installed SDKMAN in $SDKMAN_DIR_PATH."
else
  echo "    SDKMAN already exists in $SDKMAN_DIR_PATH."
fi

echo "==> Step 5: first nix-darwin switch"
# darwin-rebuild is not available on a fresh Mac, so run the 26.05 tool
# directly. The system configuration itself remains pinned by flake.lock.
sudo "$NIX_BIN" run \
  github:nix-darwin/nix-darwin/nix-darwin-26.05#darwin-rebuild -- \
  switch --flake "$DOTFILES_LINK#mac"

echo "==> Step 6: verify the activated configuration"
"$NIX_BIN" flake check --no-build "$DOTFILES_LINK"

if [ ! -e /run/current-system ]; then
  echo "/run/current-system was not created." >&2
  exit 1
fi

if [ ! -x /run/current-system/sw/bin/darwin-rebuild ]; then
  echo "darwin-rebuild is missing from the active system." >&2
  exit 1
fi

if [ ! -L "$HOME/.zshrc" ]; then
  echo "$HOME/.zshrc is not managed by Home Manager." >&2
  exit 1
fi

echo "==> Bootstrap complete. Use ./rebuild.sh for future changes."
