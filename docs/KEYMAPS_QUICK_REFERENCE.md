# Keymap card

The mappings worth memorizing, on one page. The leader is space. Everything
else is in the [full reference](KEYMAPS.md), and `<leader>hk` searches all of it
from inside Neovim.

## The ten you will use every day

| Key | Action |
| --- | --- |
| `<leader>ff` | Find a file |
| `<leader>s/` | Grep the project |
| `<leader>bb` | Switch buffer |
| `<leader><space>` | Jump to any visible spot |
| `<leader>gg` | LazyGit |
| `<leader>cc` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format the buffer |
| `<leader>nd` | Go to definition |
| `F2` | Terminal |

## Files and buffers

| Key | Action |
| --- | --- |
| `<leader>ff` / `<leader>fF` | Smart find / browse all files |
| `<leader>fr` / `<leader>fg` | Recent files / Git files |
| `<leader>fe` | File explorer |
| `<leader>fp` | Switch project |
| `<leader>fs` / `<leader>fS` | Write the buffer / all buffers |
| `<leader>bb` / `<leader>bd` | List buffers / delete this one |
| `<Tab>` / `<S-Tab>` | Next / previous buffer |

## Moving around

| Key | Action |
| --- | --- |
| `<leader><space>` | Flash jump |
| `<leader>jt` | Jump to a treesitter node |
| `f` `F` `t` `T` | Character motions, with `;` and `,` to repeat |
| `]h` / `[h` | Next / previous Git hunk |
| `]d` / `[d` | Next / previous diagnostic |
| `]w` / `[w` | Next / previous reference of this symbol |

## Code

| Key | Action |
| --- | --- |
| `<leader>nd` / `<leader>nr` | Definition / references, in a peek window |
| `<leader>ns` / `<leader>nS` | Document / workspace symbols |
| `<leader>cc` | Code action |
| `<leader>cr` | Rename symbol, with a live preview |
| `<leader>cf` | Format |
| `<leader>cd` / `<leader>cD` | Project / buffer diagnostics |
| `<leader>ch` | Diagnostic for this line |

## Completion

| Key | Action |
| --- | --- |
| `<C-j>` / `<C-k>` | Next / previous item |
| `<C-l>` | Accept: Copilot first, then the selected item |
| `<C-Space>` | Open the menu |
| `<CR>` | Newline; it never accepts |
| `jj` | Leave insert mode |

## Git

| Key | Action |
| --- | --- |
| `<leader>gg` | LazyGit |
| `<leader>gn` | Neogit |
| `<leader>gs` | Status picker |
| `<leader>gDd` / `<leader>gDs` | Diff the working tree / the index |
| `<leader>gHs` / `<leader>gHr` | Stage / reset the hunk |
| `<leader>gb` | Blame this line |
| `<leader>gy` / `<leader>gY` | Copy / open a permalink |
| `<leader>ghp` / `<leader>ghi` | Pull requests / issues |

## Windows

| Key | Action |
| --- | --- |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | Move between windows and tmux panes |
| `<leader>ws` / `<leader>wv` | Split below / right |
| `<leader>wc` / `<leader>wo` | Close this / all others |
| `<leader>wt` / `<leader>wT` | New / close tab |

## Tests and debugging

| Key | Action |
| --- | --- |
| `<leader>tn` / `<leader>tf` | Run the nearest test / this file |
| `<leader>ts` / `<leader>tS` | Run everything / toggle the summary |
| `<leader>dc` | Start or continue debugging |
| `<leader>dbt` | Toggle a breakpoint |
| `<leader>ds` / `<leader>di` / `<leader>do` | Step over / into / out |
| `<leader>du` | Toggle the debug UI |

## Toggles

| Key | Action |
| --- | --- |
| `<leader>ow` / `<leader>os` | Wrap / spell |
| `<leader>on` | Cycle the line numbers |
| `<leader>ox` / `<leader>oi` | Diagnostics / inlay hints |
| `<leader>of` / `<leader>oa` | Format on save / auto-save |
| `<leader>oC` | Copilot |
| `<leader>ok` / `<leader>oK` | Theme menu / day and night |
| `<leader>op` | Write the current toggles to the config |

## Sessions and help

| Key | Action |
| --- | --- |
| `<leader>qs` / `<leader>ql` | Restore this session / the last one |
| `<leader>qq` | Quit |
| `<leader>hk` | Search every mapping |
| `<leader>hh` / `<leader>hc` | Help / commands |

## Two habits worth forming

Press `<leader>` and read the menu instead of guessing: which-key shows every
group with its icon, and the path to a command is usually shorter than you
expect.

Use `<leader>op` after a session where you changed toggles. It writes them to
`~/.config/meowvim/config.lua`, so the next start begins the way you left off.
