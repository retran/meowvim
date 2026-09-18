# meowvim TODO

Last reviewed: 2026-09-18, against Neovim 0.12.5.

Everything the earlier research list flagged as broken on Neovim 0.12 is fixed
and has been removed from this file. What follows is what is still open, with
what would close each one.

## Open

### keymaps.lua requires snacks at module level

`lua/config/keymaps.lua:9` does `local snacks = require("snacks")` while the
file is being loaded. If snacks fails to load, `M.setup()` raises and every
mapping is lost at once, including the ones that have nothing to do with
snacks. The other optional plugins in that file go through `safe_require`.

Closing it means resolving snacks per callback, or wrapping the require and
skipping the mappings that need it.

### config/init.lua wraps its own public functions

`lua/meowvim/config/init.lua:25-35` declares `get_config_dir`,
`get_config_path`, and `get_projects_path` as private functions that only call
`M.get_config_dir`, `M.get_config_path`, and `M.get_projects_path`. The module
calls the private names in 18 places.

Closing it means deleting the three wrappers and calling the public functions.

### Neovim's default gr mappings duplicate the leader mappings

Neovim 0.11 and 0.12 bind `grn`, `grr`, `gri`, `gra`, `grt`, and `grx` to
rename, references, implementation, code action, type definition, and code
lens. All six are live, and all six have a leader equivalent: `<leader>cr`,
`<leader>nr`, `<leader>ni`, `<leader>cc`, `<leader>nt`, `<leader>cl`.

Two routes to the same action is not a bug, but the pair is undocumented and
the leader versions open a peek window where the built-ins jump. Closing it
means either documenting both or unmapping the built-ins.

### The rustaceanvim didSave workaround needs re-testing

`lua/plugins/rustaceanvim.lua` disables `textDocumentSync.save` to avoid a
panic in rust-analyzer 1.96.0. The local toolchain is on 1.98, so the
workaround is probably stale, and it is not free: with didSave suppressed
rust-analyzer never runs `checkOnSave`, so cargo diagnostics stop appearing on
write.

Closing it means removing the workaround and editing a Rust file to see
whether the panic returns.

## Considered and not taken

**aerial.nvim** for a persistent symbol outline. `<leader>ns` already lists
document symbols in the picker, and the snacks picker keeps its tree open,
which covers most of what an outline pane gives.

**diffview.nvim** was removed in 4850b89 in favour of `snacks.picker.git_diff`,
which shows the same hunks fullscreen without a second plugin.
