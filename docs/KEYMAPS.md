# Keymap reference

The leader is space. Press it and wait: which-key lists the groups, and each
further key narrows the list until you reach a command. `<leader>hk` searches
every mapping by name, which is faster when you know what the command is called
but not where it lives.

This page groups the mappings the same way which-key groups them. Modes are
`n` for normal, `v` and `x` for visual, `o` for operator-pending, `i` for
insert, and `t` for terminal.

## Files

Finding and creating files, and the file explorer. `<leader>ff` is the one to
learn first: it picks between Git files, recent files, and a full listing based
on where you are.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>fe` | Toggle File Explorer | n |
| `<leader>fF` | Browse Files | n |
| `<leader>ff` | Find File | n |
| `<leader>fg` | Find Git File | n |
| `<leader>fn` | Create File | n |
| `<leader>fp` | Switch Project | n |
| `<leader>fr` | Show Recent Files | n |
| `<leader>fS` | Save All Files | n |
| `<leader>fs` | Save File | n |

## Buffers

Listing, deleting, and pinning buffers. hbac closes unedited buffers once you
pass the threshold in `performance.buffer_threshold`, and pinning protects a
buffer from that.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>ba` | Delete All Buffers | n |
| `<leader>bb` | List Buffers | n |
| `<leader>bD` | Force Delete Buffer | n |
| `<leader>bd` | Delete Buffer | n |
| `<leader>bn` | Create Buffer | n |
| `<leader>bo` | Delete Other Buffers | n |
| `<leader>bP` | Pin All Buffers | n |
| `<leader>bp` | Toggle Pin | n |
| `<leader>br` | Rename Buffer | n |
| `<leader>bu` | Unpin All Buffers | n |

`<Tab>` and `<S-Tab>` cycle buffers in normal mode, and `]b` and `[b` do the
same.

## Search

Grep across the project, the open buffers, or the Git index. `<leader>sr` opens
Spectre for search and replace, and it takes the visual selection when you have
one.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>s/` | Search Project Text | n |
| `<leader>sb` | Search Open Buffers | n |
| `<leader>sg` | Search Git Repository | n |
| `<leader>sm` | Search Marks | n |
| `<leader>sr` | Search and Replace | n,x |
| `<leader>st` | List TODO Comments | n |

## Jump

flash.nvim labels the visible targets and jumps to the one you type.
`<leader><space>` is the plain jump; the rest scope it differently.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>.` | Scratch | n |
| `<leader>ja` | All Windows | n,o,x |
| `<leader>jm` | Remote Target | n,o,x |
| `<leader>jt` | Treesitter Node | n,o,x |

`f`, `F`, `t`, and `T` also run through flash, so `;` and `,` repeat them and
pressing the motion key again advances to the next match.

## Windows

Splits, focus, size, and tabs. `<C-h>`, `<C-j>`, `<C-k>`, and `<C-l>` move
between windows and tmux panes alike.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>w+` | Increase Height | n |
| `<leader>w-` | Decrease Height | n |
| `<leader>w<` | Decrease Width | n |
| `<leader>w=` | Equalize Windows | n |
| `<leader>w>` | Increase Width | n |
| `<leader>wc` | Close Window | n |
| `<leader>wH` | Move Window Far Left | n |
| `<leader>wh` | Focus Left Window | n |
| `<leader>wJ` | Move Window to Bottom | n |
| `<leader>wj` | Focus Lower Window | n |
| `<leader>wK` | Move Window to Top | n |
| `<leader>wk` | Focus Upper Window | n |
| `<leader>wL` | Move Window Far Right | n |
| `<leader>wl` | Focus Right Window | n |
| `<leader>wo` | Close Other Windows | n |
| `<leader>ws` | Split Window Horizontally | n |
| `<leader>wT` | Close Tab | n |
| `<leader>wt` | New Tab | n |
| `<leader>wv` | Split Window Vertically | n |

## Navigate

Code navigation through the language server. The `<leader>n` mappings open
glance for definitions and references, and the hierarchy mappings open
meow.yarn trees.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>nC` | Call Hierarchy (Callees) | n |
| `<leader>nc` | Call Hierarchy (Callers) | n |
| `<leader>nD` | Declaration | n |
| `<leader>nd` | Navigate to Definition | n |
| `<leader>nH` | Type Hierarchy (Super) | n |
| `<leader>nh` | Type Hierarchy (Subtypes) | n |
| `<leader>ni` | Implementation | n |
| `<leader>nr` | Reference | n |
| `<leader>nS` | Go To Workspace Symbols | n |
| `<leader>ns` | Go To Document Symbols | n |
| `<leader>nt` | Type Definition | n |
| `<leader>nWa` | Add Workspace Folder | n |
| `<leader>nWL` | List Workspace Folders | n |
| `<leader>nWR` | Remove Workspace Folder | n |

`]w` and `[w` move between references of the symbol under the cursor.

## Code

Actions on the code in the current buffer: diagnostics, formatting, code lens,
and Rust crates.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>cc` | Code Action | n,v |
| `<leader>cCD` | Open Crate Documentation | n |
| `<leader>cCH` | Open Crate Homepage | n |
| `<leader>cCr` | Reload Crates | n |
| `<leader>cCt` | Toggle Crates | n |
| `<leader>cCU` | Update All Crates | n |
| `<leader>cCu` | Update Crate | n |
| `<leader>cD` | Buffer Diagnostics | n |
| `<leader>cd` | Project Diagnostics | n |
| `<leader>cf` | Format Buffer | n |
| `<leader>ch` | Line Diagnostics | n |
| `<leader>cL` | Refresh CodeLens | n |
| `<leader>cl` | Run CodeLens | n |
| `<leader>co` | Organize Imports | n |
| `<leader>cq` | Quickfix List | n |
| `<leader>cR` | Rename File | n |

`<leader>cr` renames the symbol with a live preview, and `<leader>cs` takes a
code screenshot in visual mode when silicon is installed.

## Git

Hunks, diffs, conflicts, and pull requests. `<leader>gg` opens LazyGit, which
is where most day-to-day work happens; the rest is for the cases where staying
in the editor is faster.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>gB` | Browse Remote | n |
| `<leader>gb` | Blame Line | n |
| `<leader>gC` | Commit | n |
| `<leader>gDb` | Diff vs Branch | n |
| `<leader>gDd` | Diff Working Tree | n |
| `<leader>gDH` | View Git Log | n |
| `<leader>gDh` | Show File History | n |
| `<leader>gDs` | Diff Staged | n |
| `<leader>gf` | LazyGit Current File | n |
| `<leader>gg` | LazyGit | n |
| `<leader>gha` | Current PR Actions | n |
| `<leader>gHd` | Diff Buffer | n |
| `<leader>ghd` | Pull Request Diff | n |
| `<leader>ghi` | Issues | n |
| `<leader>ghp` | Pull Requests | n |
| `<leader>gHR` | Reset Buffer | n |
| `<leader>gHr` | Reset Hunk | n |
| `<leader>gHS` | Stage Buffer | n |
| `<leader>gHs` | Stage Hunk | n |
| `<leader>gHv` | Preview Hunk | n |
| `<leader>gn` | Neogit Status | n |
| `<leader>gP` | Push | n |
| `<leader>gp` | Pull | n |
| `<leader>gs` | Browse Git Status | n |
| `<leader>gw` | Branches | n |
| `<leader>gxb` | Choose Both | n |
| `<leader>gxl` | List Conflicts | n |
| `<leader>gxn` | Choose None | n |
| `<leader>gxo` | Choose Ours | n |
| `<leader>gxt` | Choose Theirs | n |
| `<leader>gY` | Open Git Link in Browser | n,v |
| `<leader>gy` | Copy Git Link | n,v |

`]h` and `[h` move between hunks, `]x` and `[x` between conflicts.

The `<leader>gh` mappings shell out to the GitHub CLI, so they need `gh` on
your PATH and an authenticated account. The pickers search live, and Enter on a
pull request opens approve, review, merge, checkout, and diff.

## Tests

neotest runs the suite for the current file, the nearest test, or everything.
The adapters cover Go, Python, Jest, and Vitest, and `<leader>td` runs the
nearest test under the debugger.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>td` | Debug Nearest Test | n |
| `<leader>tf` | Run File Tests | n |
| `<leader>tn` | Run Nearest Test | n |
| `<leader>to` | Show Test Output | n |
| `<leader>tS` | Toggle Test Summary | n |
| `<leader>ts` | Run Test Suite | n |
| `<leader>tx` | Stop Tests | n |

## Debug

nvim-dap, which loads the first time you press one of these. Adapters are
configured for Go, Python, C# through netcoredbg, and Godot.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>dB` | Clear All Breakpoints | n |
| `<leader>dbc` | Set Conditional Breakpoint | n |
| `<leader>dbe` | Set Exception Breakpoints | n |
| `<leader>dbl` | Set Log Point | n |
| `<leader>dbt` | Toggle Breakpoint | n |
| `<leader>dc` | Continue or Run | n |
| `<leader>di` | Step Into | n |
| `<leader>do` | Step Out | n |
| `<leader>dR` | Open Debug REPL | n |
| `<leader>dr` | Run to Cursor | n |
| `<leader>ds` | Step Over | n |
| `<leader>dt` | Terminate Debugger | n |
| `<leader>du` | Toggle Debug UI | n |
| `<leader>dvf` | View Debug Frames | n |
| `<leader>dvh` | Inspect Hover Value | n,v |
| `<leader>dvp` | Preview Variable Value | n,v |
| `<leader>dvs` | View Debug Scopes | n |

## Tasks

overseer runs the build and test tasks it detects for the project: npm scripts,
`go test`, and `dotnet build`.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>xl` | Restart Last Task | n |
| `<leader>xo` | Toggle Task List | n |
| `<leader>xr` | Run Task Template | n |

## Review

meow.review.nvim keeps inline annotations in `.cache/meow-review/` and exports
them as markdown, which is how the review reaches a chat or a pull request.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>ra` | Add Comment | n,v |
| `<leader>rC` | Export and Clear | n |
| `<leader>rc` | Clear All | n |
| `<leader>rd` | Delete Comment | n,v |
| `<leader>rE` | Edit Comment | n |
| `<leader>re` | Export Review | n |
| `<leader>rF` | Export Current File | n |
| `<leader>rf` | Export Review to File | n |
| `<leader>rG` | Go to Comment in File | n |
| `<leader>rg` | Go to Comment | n |
| `<leader>rr` | Reload Review | n |
| `<leader>rt` | Go to Comment by Type | n |
| `<leader>rV` | Validate Annotations | n |
| `<leader>rv` | View Comment | n |
| `<leader>rX` | Resolve All | n |
| `<leader>rx` | Resolve Comment | n |

`]r` and `[r` move between annotations.

## Yank and history

The yank ring, the undo history, and the file references that paste into a chat
as `@path:line`.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>uu` | Show Undo History | n |
| `<leader>yf` | Copy File Reference | n |
| `<leader>yh` | Show Yank History | n |
| `<leader>yl` | Copy Line Reference | n,v |

## Notes

Scratch buffers, keyed by working directory, that survive a restart.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>Nf` | Find Scratch | n |
| `<leader>Nn` | Create Scratch | n |
| `<leader>Ns` | Open Scratch | n |

## Options

The runtime toggles. `<leader>op` writes the current state of all of them into
`~/.config/meowvim/config.lua`, so the next start begins where you left off.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>oa` | Toggle Auto Save | n |
| `<leader>oC` | Toggle Copilot | n |
| `<leader>oc` | Toggle Cursorline | n |
| `<leader>od` | Toggle Dim Background | n |
| `<leader>oe` | Toggle Signcolumn | n |
| `<leader>of` | Toggle Format on Save | n |
| `<leader>og` | Toggle Indent Guides | n |
| `<leader>oh` | Toggle Search Highlight | n |
| `<leader>oi` | Toggle Inlay Hints | n |
| `<leader>oK` | Quick Toggle Day/Night | n |
| `<leader>ok` | Theme Settings | n |
| `<leader>ol` | Toggle Whitespace | n |
| `<leader>on` | Toggle Numbers | n |
| `<leader>op` | Persist Settings | n |
| `<leader>oPe` | Stop Profiling | n |
| `<leader>oPl` | Plugin Load Times | n |
| `<leader>oPp` | Start Profiling | n |
| `<leader>oPr` | Measure Render Time | n |
| `<leader>oPs` | Profile Startup Time | n |
| `<leader>oPt` | Startup Time Trends | n |
| `<leader>os` | Toggle Spell | n |
| `<leader>ot` | Toggle Linting | n |
| `<leader>ow` | Toggle Wrap | n |
| `<leader>ox` | Toggle Diagnostics | n |

## Quit and sessions

Sessions are saved per directory, and per branch when you set
`sessions.per_branch`.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>qd` | Stop Session Saving | n |
| `<leader>ql` | Restore Last Session | n |
| `<leader>qQ` | Force Quit All | n |
| `<leader>qq` | Quit All | n |
| `<leader>qS` | Select Session | n |
| `<leader>qs` | Restore Session | n |

## Help

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>hc` | Search Commands | n |
| `<leader>hh` | Search Help | n |
| `<leader>hk` | Search Keymaps | n |
| `<leader>hm` | Search Man Pages | n |
| `<leader>hN` | Noice Message History | n |
| `<leader>hn` | Notification History | n |

## Swap

Swaps the parameter under the cursor with its neighbour, using the treesitter
parameter textobject.

| Key | Action | Modes |
| --- | --- | --- |
| `<leader>S<` | Swap With Previous Parameter | n |
| `<leader>S>` | Swap With Next Parameter | n |

## Completion

blink.cmp, in insert mode. `<C-l>` accepts the Copilot suggestion when one is
showing and the selected completion otherwise, which is why it is the only
accept key you need.

| Key | Action |
| --- | --- |
| `<C-j>` / `<C-k>` | Select the next or previous item |
| `<C-l>` | Accept the Copilot suggestion, else the selected item |
| `<C-Space>` | Open the menu, then the documentation |
| `<C-u>` / `<C-d>` | Scroll the documentation |
| `<Tab>` / `<S-Tab>` | Move between snippet placeholders |
| `<CR>` | Newline; it never accepts |
| `<Esc>` | Dismiss the Copilot suggestion, else close the menu and leave insert |

`jj` also leaves insert mode, and so does the Russian `oo`, for a keyboard
layout you did not mean to be in.

## Text objects

Treesitter textobjects, in visual and operator-pending mode.

| Key | Selects |
| --- | --- |
| `af` / `if` | A function, with or without its signature and braces |
| `ac` / `ic` | A class |
| `aa` / `ia` | A parameter |
| `al` / `il` | A loop |

Movement between them uses `]m` and `[m` for functions and `]]` and `[[` for
classes, with the uppercase forms landing on the end instead of the start.

`gs` surrounds: `gsa` adds, `gsd` deletes, `gsr` replaces, `gsf` and `gsF` find,
and `gsh` highlights. `gc` and `gC` comment.

## Folds

nvim-ufo provides the folds, taking its ranges from the language server, then
treesitter, then indentation.

| Key | Action |
| --- | --- |
| `zR` / `zM` | Open or close every fold |
| `zp` | Peek at the folded lines under the cursor |

## Terminal

| Key | Action | Modes |
| --- | --- | --- |
| `<F2>` | Toggle the terminal | n, t |
| `<C-/>` | Toggle the terminal | n, t |
| `<C-_>` | Toggle the terminal, for terminals that send this instead | n, t |

## Diagnostics and lists

| Key | Action |
| --- | --- |
| `]d` / `[d` | Next or previous diagnostic, with the float |
| `]q` / `[q` | Next or previous quickfix item |
| `]l` / `[l` | Next or previous location list item |
| `]t` / `[t` | Next or previous tab |

## Spelling

| Key | Action |
| --- | --- |
| `zg` | Add the word under the cursor to the dictionary |
| `zw` | Mark the word under the cursor as misspelled |

Spell checking turns on for gitcommit, markdown, text, rst, and tex buffers, and
`<leader>os` toggles it anywhere else.
