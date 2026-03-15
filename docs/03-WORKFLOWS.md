# Daily Workflows

Common workflows in **meowvim**.

## Starting

1. Launch `nvim` for dashboard
2. Dashboard shortcuts:
   - `f` - Recent files
   - `p` - Switch projects
   - `n` - Scratch notes
3. Press `<leader>hk` to search keymaps

## Navigation

- `<leader><leader>` - Flash jump anywhere
- `<leader>ff` - File picker
- `<leader>bb` - Buffer picker
- `<leader>mm` - Marks picker
- `<leader>nw` - Workspace symbols (LSP)
- `]d` / `[d` - Next/previous diagnostic
- `<leader>cd` - Diagnostics list (Trouble)
- `F2` - Toggle terminal

### Marks

- `m{a-z}` - Set mark
- `'{a-z}` - Jump to mark
- `<leader>mm` - Browse marks
- `:marks` - List marks

### Windows

- `<leader>wv` / `<leader>ws` - Split vertical/horizontal
- `<leader>wh/j/k/l` - Move between windows
- `<leader>wc` - Close window
- `<leader>wo` - Keep only current window

## Editing

- `<leader>cc` - Code actions (LSP)
- `<leader>cr` - Rename symbol
- `<leader>cf` - Format buffer
- `<leader>nd` - Peek definition
- `<leader>nr` - Find references
- `<leader>ni` - Implementations
- Surround: `sa`, `sd`, `sr` (mini-surround)

Use `<leader>hc` to fuzzy-find commands.

## Git

- `<leader>gg` - LazyGit
- `<leader>gf` - LazyGit for file
- `<leader>gb` - Blame line
- `<leader>gDo` - Open Diffview
- `<leader>gs` / `<leader>gr` / `<leader>gv` - Stage/reset/preview hunk
- `]h` / `[h` - Next/previous hunk
- `<leader>gy` / `<leader>gY` - Copy/open permalink
- `<leader>go` / `<leader>gt` - Conflict resolution (ours/theirs)

### LazyGit

- Auto-syncs with Neovim theme
- Supports all 6 colorschemes
- Full git workflow: stage, commit, push, rebase
- Interactive rebase and conflicts

Use Overseer tasks (`<leader>rr`, `<leader>rl`, `<leader>ro`) for custom tasks.

## Testing & Debug

- `<leader>tS` - Neotest summary
- `<leader>tn` - Run nearest test
- `<leader>tf` - Run file tests
- `<leader>ts` - Run test suite
- `<leader>to` - Test output
- `<leader>td` - Debug test
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue
- `<leader>ds` - Step over
- `<leader>di` - Step in
- `<leader>do` - Step out
- `<leader>du` - Toggle DAP UI

Install adapters via Mason (`<leader>Tm`).

## Writing

- `<leader>cc` - Toggle comments (Treesitter-aware)
- `zg` - Add to dictionary
- `zw` - Mark as incorrect
- `<leader>os` - Toggle spell check
- `<leader>.` - Scratch buffer

## Sessions

Sessions save automatically. Your layout, buffers, and state persist across restarts.

## AI

- Authenticate: `:Copilot auth`
- Inline suggestions auto-trigger
- Configure in `lua/plugins/copilot.lua`

## Tasks

- `<leader>rr` - Task picker (Overseer)
- `<leader>rl` - Rerun last task
- `<leader>ro` - Toggle task list

Create custom tasks in `lua/plugins/overseer.lua` or `.overseer.json`.

## Themes

- `<leader>ok` - Theme switcher
- `:ColorschemeSelect` - Browse themes
- 6 themes with 30+ variants
- Configure transparency in `~/.config/meowvim/config.lua`

### Theme Workflow

1. Press `<leader>ok` or `:ColorschemeSelect`
2. Browse with arrows or search
3. Preview in real-time (cancel with `q`)
4. Enter to apply and save

## Developer Tools

### Performance

- `:MeowvimProfile` or `<leader>oPl` - Plugin load times
- `:StartupTrends` - Startup analysis
- `:MeasureRender` - Buffer rendering
- `:ProfileStart` / `:ProfileStop` - Profile operations

### Keymaps

- `:KeymapConflicts` - Find conflicts
- `:KeymapList [mode]` - List keymaps
- `<leader>hk` - Interactive search

### Config

- `:MeowvimConfig` - Edit config
- `:MeowvimConfigReload` - Reload config
- `:MeowvimConfigValidate` - Check errors
- `:MeowvimConfigShow` - Show config
- `:MeowvimProjects` - Manage projects
- `:MeowvimProject <name>` - Switch project

---

Next: [Troubleshooting](./04-TROUBLESHOOTING.md)
