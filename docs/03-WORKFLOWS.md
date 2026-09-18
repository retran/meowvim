# Daily workflows

Ten sequences you repeat often enough that the keystrokes should be automatic.
Each one starts from a goal and names the alternative when two paths both
work.

If a mapping here is unfamiliar, `<leader>hk` searches all of them by name.

## Open the editor where you left it

Start Neovim in a project directory with no file arguments. If a session exists
for that directory, meowvim restores it and runs the project's `on_open`
command; otherwise the dashboard opens with the recent projects.

Sessions save when the working directory changes. To carry one per Git branch,
set `sessions.per_branch = true`: the branch becomes part of the session name,
so switching branches gives you the buffers you had on that branch.

`<leader>qs` restores the session for this directory by hand, and `<leader>ql`
restores the last one you used anywhere.

## Find a file

`<leader>ff` picks the strategy for you: Git files inside a repository, recent
files when they match, a full listing otherwise. Use `<leader>fF` when you want
the plain listing and `<leader>fg` when you want only tracked files.

`<leader>fe` opens the explorer on the right, which is the better choice when
you want to see what a directory holds.

To search file contents, `<leader>s/` greps the project and `<leader>sb` greps
only the open buffers.

## Read code you did not write

`<leader>nd` opens the definition in a peek window, so you keep the call site
on screen. `<leader>nr` does the same for references. Both come from glance, and
`q` closes the window.

For the shape of a file, `<leader>ns` lists its symbols, and `<leader>nS`
searches symbols across the workspace.

`<leader>nc` and `<leader>nC` open the call hierarchy for callers and callees,
and `<leader>nh` and `<leader>nH` open the type hierarchy. These render as trees
you can expand, which is what makes them worth using over a flat reference list.

In a buffer with no language server, or one whose server does not answer that
request, these degrade instead of opening an empty window. `<leader>ns` falls
back to treesitter symbols, `<leader>nS` falls back to a project grep, and the
rest name the LSP request nobody answered. Folding does the same: nvim-ufo takes its ranges from the server, then
treesitter, then indentation.

## Change code

`<leader>cc` runs a code action. `<leader>cr` renames the symbol under the
cursor and previews the change in every file as you type, so you can back out
before committing to a name.

Formatting happens on write. `<leader>cf` formats now, and `<leader>of` turns
format-on-save off for the session when you are editing someone else's style.

Buffers up to 800 lines format during the write. Larger ones format just
afterwards so the write does not block, and files over 5000 lines are left
alone.

## Review your changes before committing

`<leader>gs` lists the changed files, and `<leader>gDd` shows the working tree
as a list of hunks with the diff beside it. `<leader>gDs` shows what is already
staged, which is the check worth running before you write the commit message.

Stage from the editor with `<leader>gHs` for the hunk under the cursor or
`<leader>gHS` for the file, and undo with `<leader>gHr` and `<leader>gHR`.
`]h` and `[h` walk the hunks.

For anything more involved, `<leader>gg` opens LazyGit, which is faster for
interactive rebases and partial staging.

## Resolve a merge conflict

git-conflict marks the conflicting regions when you open the file. `]x` and
`[x` move between them, and then you pick: `<leader>gxo` keeps ours,
`<leader>gxt` keeps theirs, `<leader>gxb` keeps both, and `<leader>gxn` keeps
neither.

`<leader>gxl` puts every conflict in the project into the quickfix list, which
tells you how much is left.

## Review a pull request

`<leader>ghp` lists the open pull requests and searches as you type. Enter opens
the actions for the selected one: approve, request changes, start a review,
merge, check out the branch, or open the diff.

`<leader>ghd` opens the diff for the pull request on the current branch, with
the review comments inline, and `a` in the preview adds a comment to the line
under the cursor.

All of this shells out to the GitHub CLI, so `gh auth login` has to have run
once.

## Run one test, then all of them

`<leader>tn` runs the test nearest the cursor, which is the fast loop.
`<leader>tf` runs the file and `<leader>ts` the whole suite.

`<leader>tS` opens the summary panel on the right, where you can run individual
tests from the tree. `<leader>to` shows the output of the last run, and
`<leader>tx` stops a run that is taking too long.

When the output is not enough, `<leader>td` runs the nearest test under
nvim-dap with the adapter for that language.

## Debug

Set a breakpoint with `<leader>dbt`, then `<leader>dc` starts the session or
continues a paused one. `<leader>ds`, `<leader>di`, and `<leader>do` step over,
into, and out.

`<leader>du` toggles the debug UI, and it opens on its own when a session
starts. For a single value, `<leader>dvh` hovers the expression under the cursor
and works on a visual selection too.

Conditional breakpoints are `<leader>dbc`, and `<leader>dbl` sets a log point,
which prints a message and keeps running.

## Annotate a review

meow.review.nvim keeps comments in `.cache/meow-review/` inside the project, so
they survive a restart and do not touch the code.

`<leader>ra` adds a comment; the modal cycles the type with `Tab` and confirms
with `<C-s>`. `]r` and `[r` move between them, `<leader>rx` resolves the one
under the cursor, and `<leader>rg` opens a picker over all of them.

When the review is done, `<leader>re` copies it to the clipboard as markdown and
`<leader>rf` writes it to a file. `<leader>rC` exports and clears in one step,
which is the usual end of a pass.

To point at code from a chat, `<leader>yf` copies `@path` and `<leader>yl`
copies `@path:line` for the cursor or the selection.

## Switch the theme

`<leader>ok` opens the theme menu: a day theme, a night theme, the mode, and the
ready-made pairs. Pick a pair and both slots change together.

In `auto` mode meowvim follows the system appearance and switches when the
system does. `<leader>oK` switches by hand and puts the mode into `manual`.
`:ColorschemeSelect` picks a single theme regardless of day and night.

Your choice is written to `~/.config/meowvim/config.lua`, so it survives a
restart.

## Keep an eye on startup

`<leader>oPs` profiles the startup with vim-startuptime, and `<leader>oPt`
shows how the last 100 starts compare, which is the one that tells you whether
something regressed.

`<leader>oPl` lists the plugins by load time. `<leader>oPp` and `<leader>oPe`
start and stop Neovim's own profiler when you need to know where a slow command
spends its time.

Next: [troubleshooting](04-TROUBLESHOOTING.md).
