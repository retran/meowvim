#!/bin/sh

ICON_PATH="${ICON_PATH:-$HOME/.config/nvim/assets/icon.ascii}"

if [ ! -f "$ICON_PATH" ]; then
  exit 0
fi

while IFS= read -r line; do
  echo "$line"
  sleep 0.001
done < "$ICON_PATH"
