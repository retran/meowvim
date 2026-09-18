# meowvim TODO

Last reviewed: 2026-09-18, against Neovim 0.12.5.

Nothing is open. The earlier research list, written on 2026-06-18, held 30
items; they are either done or recorded below as decisions.

## Decided against

**aerial.nvim** for a persistent symbol outline. `<leader>ns` already lists
document symbols in the picker and keeps its tree open, which covers most of
what an outline pane gives.

**diffview.nvim** was removed in 4850b89 in favour of `snacks.picker.git_diff`,
which shows the same hunks fullscreen without a second plugin.

**Unmapping Neovim's built-in `gr` mappings.** `grn`, `grr`, `gri`, `gra`,
`grt`, and `grx` duplicate `<leader>cr`, `<leader>nr`, `<leader>ni`,
`<leader>cc`, `<leader>nt`, and `<leader>cl`. Both sets stay: the built-ins are
muscle memory for anyone arriving from stock Neovim, and the leader versions
open a peek window where the built-ins jump. `gr` is declared as a which-key
group so the pair is visible.

## Carrying a known cost

**The rustaceanvim didSave workaround.** rust-analyzer 1.96.0 panicked on
`textDocument/didSave` while its VFS was still initializing. Suppressing didSave
avoids the crash and also stops `checkOnSave`, so cargo diagnostics never appear
on write. The workaround now applies only when the server reports 1.96, and
anything else keeps didSave.

This has not been tested against a live 1.96, because the toolchain here is two
releases newer. If the panic returns on a version the guard does not match,
widen the match in `lua/plugins/rustaceanvim.lua`.
