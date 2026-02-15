# Installation & Upgrade

This guide covers installation, verification, and maintenance of **meowvim**.

## Requirements

| Level           | Details                                                     |
| --------------- | ----------------------------------------------------------- |
| **Required**    | Neovim ≥ 0.11, Git, true-color terminal                     |
| **Recommended** | Node.js ≥ 18, Python ≥ 3.8, Go ≥ 1.19, ripgrep, fd, fzf, Nerd Font |
| **Optional**    | GitHub Copilot, tmux                                         |

Install a Nerd Font (e.g. JetBrains Mono) and enable it in your terminal for icons.

## Fresh Install

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Clone meowvim
git clone https://github.com/retran/meowvim.git ~/.config/nvim

# Start Neovim
nvim
```

First launch installs `lazy.nvim` and syncs all plugins automatically.

## Project Meow Install

If you use the **project meow** ecosystem:

```bash
git clone https://github.com/retran/meow.git ~/.meow
cd ~/.meow
git submodule update --init
./bin/meowctl install personal
```

This links meowvim with your dotfiles.

## Platform Notes

- **macOS** — ghostty, kitty, or iTerm2 recommended
- **Linux** — ensure `$XDG_CONFIG_HOME` is set (defaults to `~/.config`)
- **Windows (WSL)** — install Neovim on WSL side, use Windows Terminal with Nerd Font

## Optional Tools

| Tool      | Purpose           | Install                                    |
| --------- | ----------------- | ------------------------------------------ |
| `ripgrep` | Fast search       | `brew install ripgrep` · `apt install ripgrep` |
| `fd`      | File finder       | `brew install fd` · `apt install fd-find`     |
| `fzf`     | Fuzzy finder      | `brew install fzf` · `apt install fzf`        |
| `neovide` | GUI client        | `brew install neovide`                        |
| `lazygit` | Git TUI           | `brew install lazygit` · `apt install lazygit` |

## Verify Install

After first launch:

1. Run `:checkhealth meowvim`
2. Check dashboard appears (start Neovim without arguments)
3. Open Mason (`<leader>omm`)
4. Run `:Lazy` to verify plugins

## Updates

### Automated (Recommended)

```bash
./bin/update-meowvim.sh
```

Features:
- Timestamped backups
- Git pull + plugin sync
- Health checks
- Auto-rollback on failure
- Keeps last 10 backups

### Manual Rollback

```bash
./bin/update-meowvim.sh --rollback backup_TIMESTAMP
```

### Manual Update

```bash
cd ~/.config/nvim
git pull

# In Neovim:
:Lazy sync
:MasonToolsUpdate
:checkhealth meowvim
```

### Test Config

```bash
./bin/test-config.sh
```

Tests:
- Startup
- Config loading
- Health checks
- Plugin integrity
- LSP, Treesitter
- Syntax

## Initial Config

After install, customize:

1. Edit `~/.config/meowvim/config.lua` (auto-created)
2. Set theme and options:

```lua
return {
  core = {
    theme = "catppuccin",  -- catppuccin, tokyonight, rose-pine, gruvbox, nord, kanagawa
    variant = "mocha",
    enable_copilot = false,
  },

  ui = {
    transparency = 0,  -- 0-100
  },
}
```

3. Reload: `:MeowvimConfigReload` or restart
4. Theme picker: `:ColorschemeSelect` or `<leader>ok`

## Migrate from Another Config

1. Backup old config: `mv ~/.config/nvim ~/.config/nvim.prev`
2. Follow fresh install
3. Copy snippets or plugins from backup
4. Add local changes in `after/`

## Uninstall

```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
```

---

Next: [Configuration](./02-CONFIGURATION.md)
