#!/usr/bin/env bash
set -euo pipefail

ZSHRC_LOCAL="$HOME/.zshrc.local"
SDKMAN_DIR_PATH="$HOME/.sdkman"
SDKMAN_ZSHRC_MARKER="# SDKMAN setup managed by dotfiles"

if [ ! -e "$ZSHRC_LOCAL" ]; then
  echo "$ZSHRC_LOCAL does not exist. Run ./bootstrap.sh first, or create it manually." >&2
  exit 1
fi

if [ ! -s "$SDKMAN_DIR_PATH/bin/sdkman-init.sh" ]; then
  (
    SDKMAN_INSTALL_HOME="$(mktemp -d)"
    trap 'rm -rf "$SDKMAN_INSTALL_HOME"' EXIT

    curl --proto '=https' --tlsv1.2 -fsSL 'https://get.sdkman.io?rcupdate=false' \
      -o "$SDKMAN_INSTALL_HOME/install-sdkman.sh"

    SDKMAN_DIR="$SDKMAN_DIR_PATH" bash "$SDKMAN_INSTALL_HOME/install-sdkman.sh"
  )

  if [ ! -s "$SDKMAN_DIR_PATH/bin/sdkman-init.sh" ]; then
    echo "SDKMAN installation failed." >&2
    exit 1
  fi

  echo "    Installed SDKMAN in $SDKMAN_DIR_PATH."
else
  echo "    SDKMAN already exists in $SDKMAN_DIR_PATH."
fi

if ! grep -qF "$SDKMAN_ZSHRC_MARKER" "$ZSHRC_LOCAL"; then
  cat >> "$ZSHRC_LOCAL" <<'EOF'
# SDKMAN setup managed by dotfiles
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
EOF
  echo "    Added SDKMAN shell setup to $ZSHRC_LOCAL."
else
  echo "    SDKMAN shell setup already exists in $ZSHRC_LOCAL."
fi
