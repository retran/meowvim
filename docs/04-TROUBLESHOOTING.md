# Troubleshooting

Common fixes for **meowvim** issues.

## Health Check

Run this first:

```vim
:checkhealth meowvim
```

Checks:
- Neovim version
- Config system
- Dependencies (ripgrep, fd, lazygit)
- LSP servers
- Plugins
- Treesitter parsers

## Installation & Startup

### `E492: Not an editor command: Lazy`
**Cause**: `lazy.nvim` install failed

**Fix**:
```bash
rm -rf ~/.local/share/nvim/lazy
nvim
```

### Stuck on "Installing plugins..."
- Check internet connection
- Verify Git is in `$PATH`
- Run `:Lazy sync` manually
- Check `:messages`

### Icons appear as boxes
- Install a Nerd Font (e.g. JetBrainsMono Nerd Font)
- Set it in your terminal (ghostty, kitty, iTerm2, etc.)

## Config Issues

### Config not loading
- Run `:MeowvimConfigValidate`
- Check `~/.config/meowvim/config.lua` exists
- View config: `:MeowvimConfigShow`
- Reload: `:MeowvimConfigReload`

### Theme not applying
- Use `:ColorschemeSelect` or `<leader>ok`
- Check config:
  ```lua
  core = { theme = "catppuccin", variant = "mocha" }
  ```
- Available: catppuccin, tokyonight, rose-pine, gruvbox, nord, kanagawa, everforest, nightfox, zenbones, solarized-osaka, ayu, dracula, monokai-pro, onedark, material, melange, github

### Changes not taking effect
- Auto-reload has 500ms debounce
- Force reload: `:MeowvimConfigReload`
- Check errors: `:MeowvimConfigValidate`

## LSP Issues

### `LSP: No client with id ...`
- Install the server via mise or manually
- Check `lua/plugins/nvim-lspconfig.lua`
- Restart Neovim

### Formatting does nothing
- Check formatter is installed (via mise or manually)
- Run `:ConformInfo`
- Configure priorities in `lua/plugins/conform.lua`

### Diagnostics missing
- Run `:LspInfo` to check server
- Check `lua/plugins/nvim-lspconfig.lua`

## Treesitter & Syntax

### `:TSInstall` fails
- Requires C compiler (`clang` or `gcc`)
- macOS: Install Xcode Command Line Tools
- Linux: `apt install build-essential`
- Run `:TSUpdate` after install

### Folding issues
- Uses Treesitter expressions
- Toggle: `zi`
- Reset: `zr`
- Check `vim.opt.foldexpr` in `lua/config/options.lua`

## Performance

| Issue | Fix |
| ----- | --- |
| Slow startup | `:MeowvimProfile`, `:StartupTrends` |
| Lag while typing | Disable virtual text: `:lua vim.diagnostic.config({ virtual_text = false })` |
| High memory | Use hbac: `<leader>bp` to pin buffers; close Diffview/Neotest |

### Performance Tools

- `:MeowvimProfile` - Plugin load times
- `:StartupTrends` - Startup analysis
- `:MeasureRender` - Render benchmark
- `:ProfileStart` / `:ProfileStop` - Profile operations

Increase `vim.opt.updatetime` (e.g. 500) for lower-powered machines.

## Keymap Conflicts

- `:KeymapConflicts` - Show conflicts
- `:KeymapList [mode]` - List keymaps
- `<leader>hk` - Interactive search

Add overrides in `after/plugin/keymaps.lua`. Adjust which-key in `lua/plugins/which-key.lua`.

## Git

### LazyGit not launching
- Install: `brew install lazygit` or `apt install lazygit`
- Theme syncs automatically
- Check `~/.config/lazygit/config.yml` for manual override
- Test: `:LazyGit` or `<leader>gg`

### Neogit missing `diff-so-fancy`
- Install: `brew install diff-so-fancy`
- Or disable in `lua/plugins/neogit.lua`

### Diffview not opening
- Run `:Lazy sync`
- Check Git ≥ 2.30 installed

## Copilot & AI

### `:Copilot auth` fails
- Check Node.js ≥ 18: `node --version`
- Sign out: `:Copilot signout`
- Retry auth
- Check `:Copilot panel` for logs

### No suggestions
- Check status: `:Copilot status`
- Enable: `:Copilot enable`
- Check supported filetype (disabled in git commits, help)
- Verify `auto_trigger = true` in `lua/plugins/copilot.lua:19`

### Suggestions not accepting
- Accept inline suggestion: `<C-l>`
- Dismiss inline suggestion: `<Esc>` (stays in insert mode)
- NES (Next Edit Suggestions): `<M-l>` accept+goto, `<M-j>` accept, `<M-h>` dismiss
- See [Keymaps](KEYMAPS.md#completion--copilot)

### Completion popup missing
- Trigger: `<C-Space>`
- Check LSP: `:LspInfo`
- Check `lua/plugins/nvim-cmp.lua` (configures blink.cmp)

### Completion keymaps not working
- Navigation: `<C-j>` (down), `<C-k>` (up), `<C-l>` (smart accept: Copilot first, then cmp)
- Tab indents, Enter creates newline (by design)
- See [Keymaps](KEYMAPS.md#completion--copilot)

## Plugin Issues

- Clean: `:Lazy clean`
- Clear cache:
  ```bash
  rm -rf ~/.local/share/nvim/{lazy,treesitter,site,packer*}
  ```
- Restore snapshot: `:Lazy restore`

## Update & Rollback

### Safe updates

```bash
./bin/update-meowvim.sh
```

Features:
- Timestamped backup
- Plugin updates
- Health checks
- Auto-rollback

### Manual rollback

```bash
./bin/update-meowvim.sh --rollback backup_TIMESTAMP
```

### Test config

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

## Logging

- `:messages` - Recent output
- `:checkhealth meowvim` - Health check
- `:checkhealth` - All subsystems
- `:Lazy log` - Plugin logs
- Log file: `~/.local/state/nvim/log`

## Reset

When all else fails:

```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim  # optional
nvim
```

This keeps your config but clears plugins and cache.

---

Still stuck? Open an issue with:
- Logs
- `nvim --version`
- Description of the problem
