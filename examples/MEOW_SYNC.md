# ~/.meow Theme Sync

This document explains how to use the `sync` mode to synchronize Neovim themes with your shell tools.

## Overview

**Three modes available:**
- `manual` - Toggle day/night with `<leader>oK`
- `auto` - Sync with OS appearance (macOS/Windows/Linux)
- `sync` - Sync with `~/.meow` file (for shell tools integration)

## How Sync Mode Works

1. **Shell tools** write theme information to `~/.meow`
2. **Neovim** watches `~/.meow` and applies theme automatically
3. **In sync mode, Neovim is read-only** - it won't change themes via UI

## File Format: ~/.meow

Simple shell-friendly key-value format:

```bash
# Meowvim theme sync file
MEOW_THEME=catppuccin
MEOW_VARIANT=mocha
```

## Enabling Sync Mode

### In Neovim:
```vim
:DayNightMode sync
```

Or press `<leader>ok` → "Mode" → "Sync - sync with ~/.meow"

### Programmatically:
```lua
require("meowvim.day_night").set_mode("sync")
```

## Example: Shell Script Integration

See `examples/meow-theme-sync.sh` for a complete example.

### Basic Usage:

```bash
# Write theme to ~/.meow
cat > ~/.meow <<EOF
MEOW_THEME=catppuccin
MEOW_VARIANT=mocha
EOF
```

Neovim will automatically apply the theme!

### Auto-sync with OS (like Neovim's auto mode):

```bash
#!/usr/bin/env bash
# Run this in background or as a cron job

while true; do
  if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q "Dark"; then
    # Dark mode
    echo "MEOW_THEME=catppuccin" > ~/.meow
    echo "MEOW_VARIANT=mocha" >> ~/.meow
  else
    # Light mode
    echo "MEOW_THEME=catppuccin" > ~/.meow
    echo "MEOW_VARIANT=latte" >> ~/.meow
  fi
  sleep 5
done
```

## Integration Examples

### Terminal (e.g., iTerm2, Alacritty)

Your terminal theme switcher can write to `~/.meow`:

```bash
# When switching terminal theme
switch_terminal_theme() {
  local theme=$1
  
  if [[ "$theme" == "dark" ]]; then
    echo "MEOW_THEME=catppuccin" > ~/.meow
    echo "MEOW_VARIANT=mocha" >> ~/.meow
  else
    echo "MEOW_THEME=catppuccin" > ~/.meow
    echo "MEOW_VARIANT=latte" >> ~/.meow
  fi
}
```

### tmux

In your tmux theme switcher:

```bash
# tmux theme change hook
set-hook -g client-attached 'run-shell "your-theme-script.sh"'
```

### bat, delta, and other CLI tools

Write a wrapper that:
1. Detects current theme
2. Configures CLI tools
3. Writes to `~/.meow`

```bash
sync_cli_tools() {
  local theme=$1
  
  # Configure bat
  export BAT_THEME="Catppuccin-$theme"
  
  # Configure delta
  export DELTA_FEATURES="catppuccin-$theme"
  
  # Update Neovim
  echo "MEOW_THEME=catppuccin" > ~/.meow
  echo "MEOW_VARIANT=$theme" >> ~/.meow
}
```

## Available Themes

All 17 theme families with 100+ variants:
- catppuccin (mocha, latte, frappe, macchiato)
- tokyonight (storm, night, moon, day)
- dracula
- github (github_dark, github_light, ...)
- And many more!

See `:ColorschemeSelect` for full list.

## Theme Name Mapping

When writing to `~/.meow`, use exact theme names:

| Theme Family | Example Variants |
|--------------|------------------|
| catppuccin | mocha, latte, frappe, macchiato |
| tokyonight | storm, night, moon, day |
| rose-pine | main, moon, dawn |
| everforest | dark_medium, light_soft |
| nightfox | nightfox, dayfox |
| github | github_dark, github_light |
| dracula | (no variant) |
| melange | (no variant) |

## Troubleshooting

### Theme not changing?

1. Check file exists: `cat ~/.meow`
2. Check Neovim is in sync mode: `:lua print(vim.g.day_night_mode)`
3. Check file watcher is active: Look for "Started watching ~/.meow" message

### Invalid theme name?

Check available themes:
```vim
:lua vim.print(require("meowvim.colorscheme_switcher").get_themes())
```

### Want to switch back to manual/auto?

```vim
:DayNightMode manual
" or
:DayNightMode auto
```

## Tips

1. **Test manually first:**
   ```bash
   # Enable sync mode in Neovim
   :DayNightMode sync
   
   # Then change ~/.meow file
   echo "MEOW_THEME=dracula" > ~/.meow
   ```

2. **Use shell functions:**
   Add to your `.bashrc` or `.zshrc`:
   ```bash
   meow_dark() {
     echo "MEOW_THEME=catppuccin" > ~/.meow
     echo "MEOW_VARIANT=mocha" >> ~/.meow
   }
   
   meow_light() {
     echo "MEOW_THEME=catppuccin" > ~/.meow
     echo "MEOW_VARIANT=latte" >> ~/.meow
   }
   ```

3. **Keep it simple:** Start with the provided `meow-theme-sync.sh` script

## Benefits of Sync Mode

- **Unified theme management** across terminal, tmux, bat, Neovim, etc.
- **Shell tools control** - Your shell/terminal is the source of truth
- **Simple integration** - Just write to a text file
- **No Neovim API needed** - Works from any shell script

## See Also

- Example script: `examples/meow-theme-sync.sh`
- Theme list: Press `<leader>ok` in Neovim
- Preset pairs: `:DayNightPreset`
