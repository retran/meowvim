# Installation & Upgrade Guide

Welcome to the **meowvim** den! This guide helps you install, verify, and maintain the purr-fect Neovim setup across different environments.

## 1. Requirements

| Level           | Details                                                                  |
| --------------- | ------------------------------------------------------------------------ |
| **Required**    | Neovim ≥ 0.11, Git, true-color capable terminal                          |
| **Recommended** | Node.js ≥ 18, Python ≥ 3.8, Go ≥ 1.19, `ripgrep`, `fd`, `fzf`, Nerd Font |
| **Optional**    | GitHub Copilot, Raycast (for launch scripts), tmux integration           |

> **Tip:** Install a Nerd Font (e.g. JetBrains Mono Nerd Font) and enable it in your terminal to make icons and glyphs display correctly.

## 2. Fresh Installation

Use this path if you want meowvim as your primary Neovim configuration.

```bash
# Backup any existing config (optional but recommended)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone meowvim
git clone https://github.com/retran/meowvim.git ~/.config/nvim

# Launch Neovim to bootstrap plugins
nvim
```

First launch installs the `lazy.nvim` plugin manager, syncs all plugins, and configures LSP servers automatically. Keep the terminal open until installation finishes.

## 3. Installing via project meow

If you already live in the **project meow** ecosystem, meowvim plugs in as part of the dotfiles automation.

```bash
git clone https://github.com/retran/meow.git ~/.meow
cd ~/.meow
git submodule update --init
./bin/meowctl install personal
```

This links meowvim alongside Raycast launchers, shell aliases, and other feline utilities managed by `meowctl`.

## 4. Platform Notes

- **macOS** — iTerm2 or kitty work beautifully; enable “Draw bold text in bright colors” for best contrast.
- **Linux** — ensure `$XDG_CONFIG_HOME` is respected (defaults to `~/.config`), or adjust clone path accordingly.
- **Windows (WSL)** — install Neovim on the WSL side and clone into `/home/<user>/.config/nvim`. Use Windows Terminal with a Nerd Font.

## 5. Optional Dependencies

| Tool      | Purpose              | Install Command                                                  |
| --------- | -------------------- | ---------------------------------------------------------------- |
| `ripgrep` | fast project search  | `brew install ripgrep` · `apt install ripgrep`                   |
| `fd`      | smart file finder    | `brew install fd` · `apt install fd-find`                        |
| `fzf`     | fuzzy finder backend | `brew install fzf` · `apt install fzf`                           |
| `neovide` | GUI client           | `brew install neovide` · see [Neovide docs](https://neovide.dev) |
| `lazygit` | optional git TUI     | `brew install lazygit` · `apt install lazygit`                   |

Install the tools your workflow needs and meowvim will detect them automatically where possible.

## 6. Verifying Installation

After the first launch:

1. Run `:checkhealth` to ensure dependencies are detected.
2. Trigger the dashboard (start Neovim without arguments) and confirm the cat-themed welcome screen appears.
3. Open Mason (`<leader>omm`) to see that language servers are available.
4. Try `:Lazy` to confirm the plugin manager is responsive.

If everything completes without red warnings, you’re ready to code.

## 7. Updating meowvim

### Automated Update (Recommended)

Use the built-in update script with automatic backup and rollback:

```bash
./bin/update-meowvim.sh
```

Features:

- Creates timestamped backups before updating
- Updates configuration files via git pull
- Syncs all plugins via lazy.nvim
- Runs health checks after update
- **Auto-rollback on failure**
- Cleans old backups (keeps last 10)

### Manual Rollback

If you need to rollback to a previous state:

```bash
./bin/update-meowvim.sh --rollback backup_TIMESTAMP
```

### Manual Update

If you prefer manual control:

```bash
# Update configuration files
cd ~/.config/nvim
git pull

# Inside Neovim, refresh plugins and tooling
:Lazy sync
:MasonToolsUpdate

# Run health check
:checkhealth meowvim
```

### Test Configuration

Verify everything works after updates:

```bash
./bin/test-config.sh
```

This runs 9 comprehensive tests covering:

- Neovim startup
- Config system loading
- Health checks
- User config validation
- Plugin integrity
- LSP, Treesitter, keymaps
- Lua syntax

> **Heads up:** If you maintain personal tweaks, commit them to your own branch or fork so you can merge upstream updates gracefully.

## 8. Initial Configuration

After installation, customize your setup:

1. Edit `~/.config/meowvim/config.lua` (created on first run)
2. Choose your theme and settings:

```lua
local config = require("meowvim.config.builder")

config.core({
  theme = "catppuccin",  -- catppuccin, tokyonight, rose-pine, gruvbox, nord, kanagawa
  variant = "mocha",      -- theme-specific variant
  enable_copilot = false, -- true to enable GitHub Copilot
})

config.ui({
  transparency = 0,  -- 0-100% (0 = opaque, 100 = fully transparent)
  statusline_style = "bubbles",
})

return config.build()
```

3. Reload config: `:MeowvimConfigReload` or restart Neovim
4. Use `:ColorschemeSelect` or `<leader>uc` for interactive theme switching

## 9. Migrating from Another Config

1. Backup your previous configuration (`mv ~/.config/nvim ~/.config/nvim.prev`).
2. Follow the fresh installation steps.
3. Copy snippets, custom plugins, or spellfiles from your backup into the new structure.
4. Recreate local overrides in `after/` or dedicated plugin files.

## 10. Uninstalling or Resetting

```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
```

Removing these directories resets Neovim to a clean slate. Restore from your backup if you want to roll back.

---

Need help? Head over to the [Troubleshooting Guide](./04-TROUBLESHOOTING.md) or open an issue with your cat-powered questions.
