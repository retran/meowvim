# Daily Workflows & Recipes

This guide highlights common flows that make **meowvim** a comfortable and productive home. Mix and match the sections that match your style.

## 1. Starting Your Day

1. Launch `nvim` with no arguments to land on the cat-inspired dashboard.
2. Use the dashboard shortcuts:
   - `f` for recent files
   - `p` to switch projects
   - `n` for scratch notes
3. Press `<leader>hk` at any time to search the entire keymap catalog.

## 2. Navigating Like a Cat

- `<leader><leader>` — Flash jump to any on-screen location (f/t movements also show jump labels).
- `<leader>ff` — Snacks file picker (respecting `.gitignore`).
- `<leader>bb` — Buffer picker.
- `<leader>mm` — Search marks with Snacks picker.
- `<leader>nw` — Workspace symbol search driven by LSP.
- `]d` / `[d` — Cycle diagnostics; `<leader>cd` opens project diagnostics in Trouble.
- `F2` — Toggle the Snacks floating terminal for quick shell commands.

### Marks Workflow

Use marks to navigate important locations:
- `m{a-z}` — Set mark at current position  
- `'{a-z}` — Jump to mark
- `<leader>mm` — Browse all marks with Snacks picker
- `:marks` — List all marks

### Quick Pane Management

- `<leader>wv` / `<leader>ws` — Split windows vertically/horizontally.
- `<leader>wh`/`<leader>wj`/`<leader>wk`/`<leader>wl` — Move between windows.
- `<leader>wc` — Close current window; `<leader>wo` keeps only the current pane.

## 3. Editing & Refactoring

- `<leader>cc` — Trigger code actions via LSP.
- `<leader>cr` — Rename symbol across the buffer/project.
- `<leader>cf` — Format with Conform.nvim (auto-selects best tool).
- `<leader>nd` — Peek definitions with Glance; `<leader>nr` finds references, `<leader>ni` implementations.
- Surround editing via mini-surround (`sa`, `sd`, `sr`) and autopairs by default.

> **Tip:** Use `<leader>hc` (Snacks command search) to fuzzy-find commands, registers, and keymaps.

### Code Screenshots

Code screenshot feature has been removed. Use external tools for screenshots.

## 4. Git & Review Workflow

- `<leader>gg` — Launch LazyGit full TUI.
- `<leader>gf` — LazyGit for current file history.
- `<leader>gb` — Git blame line.
- `<leader>gDo` — Open Diffview to compare branches or commits.
- `<leader>gs` / `<leader>gr` / `<leader>gv` — Stage, reset, and preview hunks via Gitsigns.
- `]h` / `[h` — Navigate between hunks.
- `<leader>gy` / `<leader>gY` — Copy or open permalinks with Gitlinker.
- `<leader>go` / `<leader>gt` — Resolve merge conflicts (choose ours/theirs).

### LazyGit Integration

LazyGit provides a powerful TUI for git operations:
- Automatically syncs with your current Neovim theme
- Supports all 6 colorschemes (Catppuccin, TokyoNight, Rose Pine, etc.)
- Full git workflow: stage, commit, push, rebase, cherry-pick
- Interactive rebase and conflict resolution

Use Overseer tasks (`<leader>rr`, `<leader>rl`, `<leader>ro`) to run, rerun, or review task output defined in `lua/plugins/overseer.lua`.

## 5. Testing & Debugging

- `<leader>tS` — Toggle the Neotest summary sidebar.
- `<leader>tn` — Run nearest test; `<leader>tf` runs the current file; `<leader>ts` runs the suite.
- `<leader>to` — Open the latest test output; `<leader>td` debugs the nearest test.
- `<leader>db` — Toggle breakpoint via nvim-dap.
- `<leader>dc` — Continue execution; `<leader>ds` steps over; `<leader>di` steps in; `<leader>do` steps out; `<leader>du` toggles the DAP UI.

Set up adapters through Mason (`<leader>Tm`) and confirm they appear in Neotest/DAP UI.

## 6. Writing & Documentation

- `<leader>cc` — Toggle comments with ts-comments.nvim (Treesitter-aware).
- `zg` — Add current word to your personal dictionary; `zw` marks as incorrect.
- `<leader>os` — Toggle spell checking when you need focused writing.
- Use Snacks’ scratch buffers (`<leader>.`) for quick temporary notes.

## 7. Sessions & Multitasking

Sessions are automatically managed by meowvim. Your layout, buffers, and state persist across restarts automatically. No manual session management needed.

## 8. AI Companions

- Authenticate GitHub Copilot once via `:Copilot auth`.
- Copilot uses inline suggestions by default; adjust them in `lua/plugins/copilot.lua` if you prefer a quieter flow.
- For scripted AI assistance, pair with external workflows like `meowg1k`.

## 9. Running Tasks & Commands

- `<leader>rr` — Overseer task template picker for npm, Go, dotnet, and custom recipes.
- `<leader>rl` — Re-run the last task.
- `<leader>ro` — Toggle the task list or output window (depending on context).

Create custom tasks by extending `lua/plugins/overseer.lua` or adding per-project configs via `.overseer.json`.

## 10. Theming & Customization

- `<leader>ok` — Interactive colorscheme switcher with live preview.
- `:ColorschemeSelect` — Browse all 6 themes with 30+ variants.
- Themes: Catppuccin, TokyoNight, Rose Pine, Gruvbox, Nord, Kanagawa.
- Configure transparency (0-100%) in `~/.config/meowvim/config.lua`.

### Theme Workflow

1. Press `<leader>ok` or run `:ColorschemeSelect`
2. Browse themes with arrow keys or search
3. Preview themes in real-time (cancel with `q` to restore)
4. Press Enter to apply and save

All themes support transparency and integrate with LazyGit, lualine, and other plugins.

## 11. Developer Productivity

### Performance Tools

- `:MeowvimProfile` or `<leader>oPl` — View plugin load times dashboard
- `:StartupTrends` — Analyze startup time trends
- `:MeasureRender` — Benchmark buffer rendering
- `:ProfileStart` / `:ProfileStop` — Profile Neovim operations

### Keymap Management

- `:KeymapConflicts` — Detect duplicate or conflicting keymaps
- `:KeymapList [mode]` — List all keymaps for a specific mode
- `<leader>hk` — Interactive keymap search

### Configuration Management

- `:MeowvimConfig` — Open user config file
- `:MeowvimConfigReload` — Reload config and apply changes
- `:MeowvimConfigValidate` — Validate config against schema
- `:MeowvimConfigShow` — Display current configuration
- `:MeowvimProjects` — List all projects
- `:MeowvimProject <name>` — Switch to project

## 12. Launching from Everywhere

- **Raycast** — Scripts under `bin/` let you open meowvim in terminal splits or project roots from Spotlight-like prompts.
- **tmux** — Bind a key to `tmux split-window -v 'nvim'` and let sessions persist across terminals.
- **LazyGit** — Use `<leader>gg` to launch LazyGit.

---

Ready to go deeper? Head over to the [Troubleshooting Guide](./04-TROUBLESHOOTING.md) if anything feels off, or explore the [Configuration Guide](./02-CONFIGURATION.md) to craft your own feline workflow.
