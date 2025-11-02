# Daily Workflows & Recipes

This guide highlights common flows that make **meowvim** a comfortable and productive home. Mix and match the sections that match your style.

## 1. Starting Your Day

1. Launch `nvim` with no arguments to land on the cat-inspired dashboard.
2. Use the dashboard shortcuts:
   - `f` for recent files
   - `p` to switch projects
   - `n` for scratch notes
3. Press `<leader>ohk` at any time to search the entire keymap catalog.

## 2. Navigating Like a Cat

- `<leader><space>` — Flash jump to any on-screen location.
- `<leader>ff` — Snacks file picker (respecting `.gitignore`).
- `<leader>bb` — Buffer picker with pin/unpin support.
- `<leader>nw` — Workspace symbol search driven by LSP.
- `]d` / `[d` — Cycle diagnostics; `<leader>cda` opens project diagnostics in Trouble.
- `F2` — Toggle the Snacks floating terminal for quick shell commands.

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

> **Tip:** Use `<leader>ohc` (Snacks command search) to fuzzy-find commands, registers, and keymaps.

## 4. Git & Review Workflow

- `<leader>gss` — Launch Neogit status (stage, commit, push from TUI).
- `<leader>gdo` — Open Diffview to compare branches or commits.
- `<leader>gh*` — Preview hunks, stage/reset, and toggle blame via Gitsigns.
- `<leader>gyy` / `<leader>gyo` — Copy or open permalinks with Gitlinker.
- `<leader>gx*` — Resolve merge conflicts with git-conflict.nvim helpers.

Use Overseer tasks (`<leader>rr`, `<leader>rl`, `<leader>ro`) to run, rerun, or review task output defined in `lua/plugins/overseer.lua`.

## 5. Testing & Debugging

- `<leader>tS` — Toggle the Neotest summary sidebar.
- `<leader>tn` — Run nearest test; `<leader>tf` runs the current file; `<leader>ts` runs the suite.
- `<leader>to` — Open the latest test output; `<leader>td` debugs the nearest test.
- `<leader>dbt` — Toggle breakpoint via nvim-dap.
- `<leader>dc` — Continue execution; `<leader>ds` steps over; `<leader>di` steps in; `<leader>do` steps out; `<leader>du` toggles the DAP UI.

Set up adapters through Mason (`<leader>omm`) and confirm they appear in Neotest/DAP UI.

## 6. Writing & Documentation

- `<leader>cc` — Toggle comments with Treesitter awareness.
- `zg` — Add current word to your personal dictionary; `zw` marks as incorrect.
- `<leader>os` — Toggle spell checking when you need focused writing.
- Use Snacks’ scratch buffers (`<leader>.`) for quick temporary notes.

## 7. Sessions & Multitasking

- `<leader>oSr` — Restore current directory session.
- `<leader>oSl` — Load the most recent session.
- `<leader>oSx` — Stop saving the current session (handy before experimenting).

Sessions remember buffers, splits, folds, and tabs — perfect for juggling multiple projects.

## 8. AI Companions

- Authenticate GitHub Copilot once via `:Copilot auth`.
- Completions flow through nvim-cmp after signing in; inline suggestions are disabled by default (tweak `lua/plugins/copilot.lua` if you prefer them).
- Use Copilot Chat (if installed) or pair with external `meowg1k` workflows for scripted AI assistance.

## 9. Running Tasks & Commands

- `<leader>rr` — Overseer task template picker for npm, Go, dotnet, and custom recipes.
- `<leader>rl` — Re-run the last task.
- `<leader>ro` — Toggle the task list or output window (depending on context).

Create custom tasks by extending `lua/plugins/overseer.lua` or adding per-project configs via `.overseer.json`.

## 10. Launching from Everywhere

- **Raycast** — Scripts under `bin/` let you open meowvim in Neovide, terminal splits, or project roots from Spotlight-like prompts.
- **Neovide** — Launch with `neovide --multigrid` for buttery-smooth GUI, preconfigured in `lua/config/neovide.lua`.
- In Neovide, `<leader>of` toggles fullscreen while `<leader>o+/o-` adjust font scale.
- **tmux** — Bind a key to `tmux split-window -v 'nvim'` and let sessions persist across terminals.

---

Ready to go deeper? Head over to the [Troubleshooting Guide](./04-TROUBLESHOOTING.md) if anything feels off, or explore the [Configuration Guide](./02-CONFIGURATION.md) to craft your own feline workflow.
