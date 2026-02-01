#!/usr/bin/env bash
# Example script: Sync ~/.meow with OS theme
# This demonstrates how shell tools can write to ~/.meow for Neovim to sync

MEOW_FILE="$HOME/.meow"

# Function to detect OS theme
get_os_theme() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q "Dark"; then
      echo "dark"
    else
      echo "light"
    fi
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux - try GNOME first
    if command -v gsettings &> /dev/null; then
      theme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null)
      if echo "$theme" | grep -qi "dark"; then
        echo "dark"
      else
        echo "light"
      fi
    else
      # Default to dark if can't detect
      echo "dark"
    fi
  else
    # Default to dark for other systems
    echo "dark"
  fi
}

# Function to write theme to ~/.meow
write_meow_theme() {
  local mode=$1
  local theme=$2
  local variant=$3
  
  cat > "$MEOW_FILE" <<EOF
# Meowvim theme sync file
# Written by shell theme sync script
# Mode: $mode
MEOW_THEME=$theme
MEOW_VARIANT=$variant
EOF
}

# Main logic
main() {
  local os_mode=$(get_os_theme)
  
  if [[ "$os_mode" == "dark" ]]; then
    # Use your preferred dark theme
    write_meow_theme "dark" "catppuccin" "mocha"
    echo "Set ~/.meow to dark theme: catppuccin-mocha"
  else
    # Use your preferred light theme
    write_meow_theme "light" "catppuccin" "latte"
    echo "Set ~/.meow to light theme: catppuccin-latte"
  fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
