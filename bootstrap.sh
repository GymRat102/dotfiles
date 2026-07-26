#!/usr/bin/env bash
set -euo pipefail

# This script currently handles username personalization and local shell setup.
# It could later install Nix, create the ~/.dotfiles symlink, and run the first
# nix-darwin switch, but those actions intentionally do not belong here yet.

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REAL_USER="$(whoami)"
FLAKE_USER="$(sed -nE 's/^[[:space:]]*user = "([^"]+)";.*/\1/p' "$DIR/flake.nix" | head -n1)"
ZSHRC_LOCAL="$HOME/.zshrc.local"
SDKMAN_DIR_PATH="$HOME/.sdkman"

if [ ! -e "$ZSHRC_LOCAL" ]; then
  touch "$ZSHRC_LOCAL"
  echo "Created $ZSHRC_LOCAL."
else
  echo "$ZSHRC_LOCAL already exists."
fi

if [ ! -s "$SDKMAN_DIR_PATH/bin/sdkman-init.sh" ]; then
  (
    SDKMAN_INSTALL_HOME="$(mktemp -d)"
    trap 'rm -rf "$SDKMAN_INSTALL_HOME"' EXIT

    curl -fsSL https://get.sdkman.io \
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

  echo "Installed SDKMAN in $SDKMAN_DIR_PATH."
else
  echo "SDKMAN already exists in $SDKMAN_DIR_PATH."
fi

if [ -z "$FLAKE_USER" ]; then
  echo "Could not find the single \"user =\" line in flake.nix."
  exit 1
elif [ "$FLAKE_USER" = "$REAL_USER" ]; then
  echo "flake.nix already matches \"$REAL_USER\"."
  exit 0
fi

echo "flake.nix is configured for \"$FLAKE_USER\", but the current user is \"$REAL_USER\"."
read -r -p "Rewrite flake.nix for \"$REAL_USER\"? [y/N] " REPLY

if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
  sed -i '' -E "s/^([[:space:]]*user = \")[^\"]+(\";.*)/\1${REAL_USER}\2/" "$DIR/flake.nix"
  echo "Updated flake.nix."
else
  echo "No changes made."
  exit 1
fi
