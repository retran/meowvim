# Troubleshooting & Health Checks

Even the most graceful cats occasionally land on a wobbly surface. This guide collects common fixes for **meowvim** so you can get back to prowling quickly.

## 0. Health Check System

meowvim includes a comprehensive health check system:

```vim
:checkhealth meowvim
```

This checks:
- Neovim version compatibility
- Configuration system integrity
- External dependencies (ripgrep, fd, lazygit, etc.)
- LSP server installations
- Mason tool availability
- Plugin loading status
- Treesitter parser installations

Run this **first** when troubleshooting issues.

## 1. Installation & Startup

### `E492: Not an editor command: Lazy`
- **Cause:** `lazy.nvim` did not install correctly (likely due to network hiccups).
- **Fix:** Remove the plugin directory and restart Neovim:
  ```bash
  rm -rf ~/.local/share/nvim/lazy
  nvim
  ```

### Stuck on "Installing plugins..."
- Ensure you have an active internet connection.
- Verify Git is installed and available in `$PATH`.
- Try running `:Lazy sync` manually and inspect the output (`:messages`).

### Icons appear as boxes or question marks
- Install a Nerd Font (e.g., `JetBrainsMono Nerd Font`) and set it in your terminal.
- On macOS Terminal, enable "Use Option as Meta" for better keybindings.

## 2. Configuration System Issues

### Config not loading or errors on startup
- Run `:MeowvimConfigValidate` to check for syntax errors
- Check `~/.config/meowvim/config.lua` exists (created on first run)
- View current config: `:MeowvimConfigShow`
- Reload config: `:MeowvimConfigReload`

### Theme not applying
- Use `:ColorschemeSelect` or `<leader>uc` to select theme interactively
- Check config: `config.core({ theme = "catppuccin", variant = "mocha" })`
- Available themes: catppuccin, tokyonight, rose-pine, gruvbox, nord, kanagawa

### Config changes not taking effect
- Config has auto-reload with 500ms debounce
- Force reload with `:MeowvimConfigReload`
- Check for syntax errors with `:MeowvimConfigValidate`

## 3. Language Server (LSP) Issues

### `LSP: No client with id ...`
- Open Mason (`<leader>omm`) or run `:Mason` and make sure the server you expect is installed.
- Check `lua/plugins/nvim-lspconfig.lua` to confirm the language is configured.
- Restart Neovim after installing new servers (LSP loads on startup).

### Formatting does nothing
- Confirm the formatter exists via Mason.
- Run `:ConformInfo` to see which formatter will run for the current filetype.
- If multiple formatters are configured, configure priorities in `lua/plugins/conform.lua`.

### Diagnostics missing or delayed
- Verify diagnostics display is enabled via `:LspInfo`, and review `lua/plugins/nvim-lspconfig.lua` if you customized diagnostic settings.
- Run `:LspInfo` to check if the server is attached to the buffer.

## 4. Treesitter & Syntax

### `:TSInstall` fails
- Treesitter parsers require a C compiler (`clang` or `gcc`).
- Install Xcode Command Line Tools (macOS) or `build-essential` (Linux).
- Run `:TSUpdate` after installing the compiler.

### Folding behaves strangely
- Folding uses Treesitter expressions. Toggle folding with `zi` and reset with `zr`.
- Check `vim.opt.foldexpr` in `lua/config/options.lua` if you want to experiment with alternatives.

## 5. Performance Concerns

| Symptom | Suggested Fix |
| ------- | --------------- |
| Slow startup | Run `:MeowvimProfile` or `<leader>oL` to see plugin load times; use `:StartupTrends` for historical analysis. |
| Lag while typing | Disable diagnostic virtual text in `lua/plugins/nvim-lspconfig.lua` or via `:lua vim.diagnostic.config({ virtual_text = false })`. |
| High memory usage | Use hbac plugin (`<leader>bp` to pin important buffers); close Diffview/Neotest panes when not in use. |

### Performance Tools

- `:MeowvimProfile` or `<leader>oL` — View plugin load times dashboard
- `:StartupTrends` — Analyze startup time trends over last 100 starts
- `:MeasureRender` — Benchmark current buffer rendering
- `:ProfileStart` / `:ProfileStop` — Profile Neovim operations

Set `vim.opt.updatetime` higher (e.g., 500) if your machine is lower-powered.

## 6. Keymap Conflicts

meowvim includes tools to detect and resolve keymap conflicts:

- `:KeymapConflicts` — Show all duplicate or conflicting keymaps
- `:KeymapList [mode]` — List all keymaps for a specific mode (n, v, i, etc.)
- `<leader>ohk` — Interactive keymap search

Place overrides in `after/plugin/keymaps.lua` to run after defaults. If which-key popups feel noisy, adjust timings and layout in `lua/plugins/which-key.lua`.

## 7. Git Integration

### LazyGit not launching or theme issues
- Install lazygit: `brew install lazygit` or `apt install lazygit`
- Theme auto-syncs on launch; check `~/.config/lazygit/config.yml` if manual override needed
- Run `:LazyGit` to test, or use `<leader>gg` keybinding

### Neogit complains about missing `diff-so-fancy`
- Install via package manager (`brew install diff-so-fancy`) or disable the dependency inside `lua/plugins/neogit.lua`.

### Diffview does not open
- Ensure you have run `:Lazy sync` (Diffview is lazily loaded on command).
- Check that `git` ≥ 2.30 is installed; Diffview relies on modern diff features.

## 8. Copilot & AI

### `:Copilot auth` fails
- Ensure Node.js ≥ 18 is installed (`node --version`).
- Sign out via `:Copilot signout` and retry authentication.
- Check the Copilot status window (`:Copilot panel`) for logs.

### Copilot suggestions missing
- Inline suggestions are enabled by default; toggle them by editing `lua/plugins/copilot.lua`.
- Make sure `copilot.lua` is enabled (see `lua/plugins/copilot.lua`).
- Confirm you're in a supported filetype; Copilot is disabled in some contexts.

## 9. Plugins Misbehaving

- Run `:Lazy clean` to remove unused directories.
- Clear caches:
  ```bash
  rm -rf ~/.local/share/nvim/{lazy,treesitter,site,packer*}
  ```
  Then relaunch Neovim.
- If an update broke something, use `:Lazy restore` to roll back to the previous snapshot (`lazy-lock.json`).

## 10. Update & Rollback

### Safe updates with automatic backup

```bash
./bin/update-meowvim.sh
```

This script:
- Creates timestamped backup
- Updates all plugins
- Runs health checks
- Auto-rollback on failure

### Manual rollback

```bash
./bin/update-meowvim.sh --rollback backup_TIMESTAMP
```

### Test configuration integrity

```bash
./bin/test-config.sh
```

Runs comprehensive tests:
- Neovim startup test
- Config loading verification
- Health checks
- User config validation
- Plugin integrity
- LSP, Treesitter, keymaps
- Lua syntax validation

## 11. Logging & Diagnostics

- `:messages` — shows most recent command output
- `:checkhealth meowvim` — comprehensive health check for meowvim
- `:checkhealth` — check all Neovim subsystems
- `:Lazy log` — plugin manager logs (open the file path printed)
- Neovim log file: `~/.local/state/nvim/log` (increase verbosity with `:set viminfo?` or `:verbose` commands)

Collect relevant snippets when opening an issue so we can help faster.

## 12. Starting Over

When all else fails:

```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim # optional
nvim
```

This clears plugin installations and caches while keeping your configuration intact.

---

Still puzzled? Open a discussion or issue with logs, Neovim version (`nvim --version`), and a short description of what went sideways. We’re happy to help fellow project meow cats land on their feet.
