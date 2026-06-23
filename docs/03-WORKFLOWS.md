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

- `<leader><space>` - Flash jump anywhere
- `<leader>ff` - File picker
- `<leader>bb` - Buffer picker
- `<leader>sm` - Marks picker
- `<leader>sw` - Workspace symbols (LSP)
- `]d` / `[d` - Next/previous diagnostic
- `<leader>cd` - Diagnostics list (Snacks picker)
- `F2` - Toggle terminal

### Marks

- `m{a-z}` - Set mark
- `'{a-z}` - Jump to mark
- `<leader>sm` - Browse marks
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
- `<leader>gDd` - Open Diffview explorer
- `<leader>gHs` / `<leader>gHr` / `<leader>gHv` - Stage/reset/preview hunk
- `]h` / `[h` - Next/previous hunk
- `<leader>gy` / `<leader>gY` - Copy/open permalink
- `<leader>gxo` / `<leader>gxt` - Conflict resolution (ours/theirs)

### LazyGit

- Auto-syncs with Neovim theme
- Supports all colorschemes
- Full git workflow: stage, commit, push, rebase
- Interactive rebase and conflicts

Use Overseer tasks (`<leader>xr`, `<leader>xl`, `<leader>xo`) for custom tasks.

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

Install debug adapters via mise or manually per the DAP plugin config.

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
- Inline suggestions auto-trigger in insert mode
- `<C-l>` - Accept inline suggestion (or selected completion item)
- `<Esc>` - Dismiss inline suggestion (stay in insert mode)
- NES (Next Edit Suggestions): `<M-l>` accept+goto, `<M-j>` accept, `<M-h>` dismiss
- Toggle: `<leader>oC`
- Configure in `lua/plugins/copilot.lua`

## Tasks

- `<leader>xr` - Task picker (Overseer)
- `<leader>xl` - Rerun last task
- `<leader>xo` - Toggle task list

Create custom tasks in `lua/plugins/overseer.lua` or `.overseer.json`.

## Code Review

AI-assisted inline code review via `meow.review.nvim`:

- `<leader>ra` - Add comment (modal; Tab cycles type, `<C-s>` confirms)
- `<leader>rd` - Delete comment
- `<leader>rE` - Edit comment (pre-filled modal)
- `<leader>rv` - View comment
- `<leader>re` - Export review to clipboard
- `<leader>rf` - Export to file (prompts for filename)
- `<leader>rF` - Export annotations for current file only
- `<leader>rC` - Export and clear all annotations
- `<leader>rc` - Clear all annotations
- `<leader>rr` - Reload from store file
- `<leader>rg` - Go to comment (picker)
- `<leader>rG` - Go to comment in current file
- `<leader>rt` - Go to comment by type
- `<leader>rx` - Resolve comment at cursor
- `<leader>rX` - Resolve all comments
- `<leader>rV` - Validate annotations (detect stale)
- `]r` / `[r` - Next/previous review comment

Copy references for review notes:
- `<leader>yf` - Copy file reference (e.g. `@lua/plugins/copilot.lua`)
- `<leader>yl` - Copy line reference (e.g. `@lua/plugins/copilot.lua:42`)

## Themes

- `<leader>ok` - Theme switcher
- `:ColorschemeSelect` - Browse themes
- 17 colorschemes with 70+ variants
- Configure transparency in `~/.config/meowvim/config.lua`

### Theme Workflow

1. Press `<leader>ok` or `:ColorschemeSelect`
2. Browse with arrows or search
3. Preview in real-time (cancel with `q`)
4. Enter to apply and save

## Developer Tools

### Performance

- `:MeowvimProfile` - Plugin load times
- `:StartupTrends` - Startup analysis
- `:MeasureRender` - Buffer rendering
- `:ProfileStart` / `:ProfileStop` - Profile operations
- `<leader>oPs` - Profile startup time (`:StartupTime`)

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
