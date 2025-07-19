#!/bin/bash
# Use the ICON_PATH environment variable if set, otherwise default to ~/.config/nvim/assets/icon.ascii
ICON_PATH="${ICON_PATH:-$HOME/.config/nvim/assets/icon.ascii}"
cat "$ICON_PATH"
