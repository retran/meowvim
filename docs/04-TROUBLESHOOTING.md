# Troubleshooting & Health Checks

Even the most graceful cats occasionally land on a wobbly surface. This guide collects common fixes for **meowvim** so you can get back to prowling quickly.

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
- Install a Nerd Font (e.g., `JetBrainsMono Nerd Font`) and set it in your terminal or Neovide.
- On macOS Terminal, enable "Use Option as Meta" for better keybindings.

## 2. Language Server (LSP) Issues

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

## 3. Treesitter & Syntax

### `:TSInstall` fails
- Treesitter parsers require a C compiler (`clang` or `gcc`).
- Install Xcode Command Line Tools (macOS) or `build-essential` (Linux).
- Run `:TSUpdate` after installing the compiler.

### Folding behaves strangely
- Folding uses Treesitter expressions. Toggle folding with `zi` and reset with `zr`.
- Check `vim.opt.foldexpr` in `lua/config/options.lua` if you want to experiment with alternatives.

## 4. Performance Concerns

| Symptom | Suggested Fix |
| ------- | --------------- |
| Slow startup | Run `:Lazy profile` to find heavy plugins; disable unused ones. |
| Lag while typing | Disable diagnostic virtual text in `lua/plugins/nvim-lspconfig.lua` or via `:lua vim.diagnostic.config({ virtual_text = false })`. |
| High memory usage | Limit open buffers, close Diffview/Neotest panes when not in use. |

Set `vim.opt.updatetime` higher (e.g., 500) if your machine is lower-powered.

## 5. Keymap Conflicts

- Use `<leader>ohk` to inspect overlapping keymaps.
- Place overrides in `after/plugin/keymaps.lua` to run after defaults.
- If which-key popups feel noisy, adjust timings and layout in `lua/plugins/which-key.lua`.

## 6. Git Integration

### Neogit complains about missing `diff-so-fancy`
- Install via package manager (`brew install diff-so-fancy`) or disable the dependency inside `lua/plugins/neogit.lua`.

### Diffview does not open
- Ensure you have run `:Lazy sync` (Diffview is lazily loaded on command).
- Check that `git` ≥ 2.30 is installed; Diffview relies on modern diff features.

## 7. Copilot & AI

### `:Copilot auth` fails
- Ensure Node.js ≥ 18 is installed (`node --version`).
- Sign out via `:Copilot signout` and retry authentication.
- Check the Copilot status window (`:Copilot panel`) for logs.

### Copilot suggestions missing
- Inline suggestions are disabled by default; toggle them by editing `lua/plugins/copilot.lua`.
- Make sure `copilot.lua` and `copilot-cmp` are enabled (see `lua/plugins/copilot*.lua`).
- Confirm you're in a supported filetype; Copilot is disabled in some contexts.

## 8. Plugins Misbehaving

- Run `:Lazy clean` to remove unused directories.
- Clear caches:
  ```bash
  rm -rf ~/.local/share/nvim/{lazy,treesitter,site,packer*}
  ```
  Then relaunch Neovim.
- If an update broke something, use `:Lazy restore` to roll back to the previous snapshot (`lazy-lock.json`).

## 9. Logging & Diagnostics

- `:messages` — shows most recent command output.
- `:checkhealth` — first stop for environment issues.
- `:Lazy log` — plugin manager logs (open the file path printed).
- Neovim log file: `~/.local/state/nvim/log` (increase verbosity with `:set viminfo?` or `:verbose` commands).

Collect relevant snippets when opening an issue so we can help faster.

## 10. Starting Over

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
