#!/bin/sh

# SPDX-License-Identifier: MIT
# Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

# @file: scripts/icon.sh
# @brief: Script to display ASCII art icon with animation.

ICON_PATH="${ICON_PATH:-$HOME/.config/nvim/assets/icon.ascii}"

if [ ! -f "$ICON_PATH" ]; then
  exit 0
fi

while IFS= read -r line; do
  echo "$line"
  sleep 0.001
done <"$ICON_PATH"
