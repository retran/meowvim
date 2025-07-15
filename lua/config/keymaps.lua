-- ~/.config/nvim/lua/keymaps.lua

local M = {}
local default_opts = { noremap = true, silent = true }

function M.map(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", default_opts, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- remove default mappings for commenting
vim.keymap.del("n", "gc")
vim.keymap.del("n", "gcc")

local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  local mappings = {
    -- Misc
    { "<C-h>",         "<C-w>h",                   desc = "Window -> Go Left" },
    { "<C-j>",         "<C-w>j",                   desc = "Window -> Go Down" },
    { "<C-k>",         "<C-w>k",                   desc = "Window -> Go Up" },
    { "<C-l>",         "<C-w>l",                   desc = "Window -> Go Right" },

    { "<Tab>",         ":BufferLineCycleNext<CR>", desc = "Buffer -> Next" },
    { "<S-Tab>",       ":BufferLineCyclePrev<CR>", desc = "Buffer -> Previous" },

    { "<leader><Esc>", ":nohlsearch<CR>",          desc = "Clear Highlight" },

    {
      "<leader><space>",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Find File",
    },

    { "<leader>k", vim.lsp.buf.hover,    desc = "Hover" },

    { "<leader>c", group = "+comment" },
    { "<leader>T", group = "+treesitter" },
    {
      "<leader>u",
      function()
        Snacks.picker.undo()
      end,
      desc = "Undo History",
    },

    -- Window
    { "<leader>w",  group = "+window" },
    { "<leader>wh", "<C-w>h",         desc = "Go Left" },
    { "<leader>wj", "<C-w>j",         desc = "Go Down" },
    { "<leader>wk", "<C-w>k",         desc = "Go Up" },
    { "<leader>wl", "<C-w>l",         desc = "Go Right" },
    { "<leader>ws", "<C-w>s",         desc = "Split Horizontal" },
    { "<leader>wv", "<C-w>v",         desc = "Split Vertical" },
    { "<leader>wx", "<C-w>c",         desc = "Close Current Window" },
    { "<leader>wo", "<C-w>o",         desc = "Close Other Windows" },
    { "<leader>w=", "<C-w>=",         desc = "Equalize" },
    { "<leader>w>", "<C-w>>",         desc = "Increase Width" },
    { "<leader>w<", "<C-w><",         desc = "Decrease Width" },
    { "<leader>w+", "<C-w>+",         desc = "Increase Height" },
    { "<leader>w-", "<C-w>-",         desc = "Decrease Height" },
    { "<leader>wH", "<C-w>H",         desc = "Move to Far Left" },
    { "<leader>wL", "<C-w>L",         desc = "Move to Far Right" },
    { "<leader>wK", "<C-w>K",         desc = "Move to Far Top" },
    { "<leader>wJ", "<C-w>J",         desc = "Move to Far Bottom" },

    -- File
    { "<leader>f",  group = "+file" },
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Find in Git",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Find Recent",
    },
    { "<leader>fs", ":w<CR>",               desc = "Save" },
    { "<leader>fS", ":wa<CR>",              desc = "Save All" },
    { "<leader>fn", ":enew<CR>",            desc = "New" },
    { "<leader>fR", ":source $MYVIMRC<CR>", desc = "Reload Config" },
    {
      "<leader>fe",
      function()
        Snacks.explorer()
      end,
      desc = "Toggle Explorer",
    },
    {
      "<leader>fp",
      function()
        require("snacks").picker.projects({
          dev = { "~/workspace/" },
        })
      end,
      desc = "Find Projects",
    },

    -- Buffer
    { "<leader>b",  group = "+buffer" },
    {
      "<leader>bb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    { "<leader>bp", ":BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>bP", ":BufferLinePick<CR>",      desc = "Pick" },
    { "<leader>br", ":BufRename<CR>",           desc = "Rename" },
    { "<leader>bl", ":BufMoveRight<CR>",        desc = "Move Right" },
    { "<leader>bh", ":BufMoveLeft<CR>",         desc = "Move Left" },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>bx",
      function()
        Snacks.bufdelete({ force = true })
      end,
      desc = "Force Delete Buffer",
    },
    {
      "<leader>bo",
      function()
        Snacks.bufdelete.other()
      end,
      desc = "Delete Other Buffers",
    },
    {
      "<leader>bO",
      function()
        Snacks.bufdelete.all()
      end,
      desc = "Delete All Buffers",
    },

    -- Debug
    { "<leader>D", group = "+debug" },
    {
      "<leader>Db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle Breakpoint",
    },
    {
      "<leader>Dc",
      function()
        require("dap").continue()
      end,
      desc = "Continue",
    },
    {
      "<leader>Di",
      function()
        require("dap").step_into()
      end,
      desc = "Step Into",
    },
    {
      "<leader>Do",
      function()
        require("dap").step_over()
      end,
      desc = "Step Over",
    },
    {
      "<leader>Du",
      function()
        require("dap").step_out()
      end,
      desc = "Step Out",
    },
    {
      "<leader>Dr",
      function()
        require("dap").repl.open()
      end,
      desc = "Open REPL",
    },
    {
      "<leader>Dl",
      function()
        require("dap").run_last()
      end,
      desc = "Run Last",
    },
    {
      "<leader>Dt",
      function()
        require("dap").terminate()
      end,
      desc = "Terminate",
    },
    {
      "<leader>DU",
      function()
        require("dapui").toggle()
      end,
      desc = "Toggle UI",
    },

    -- Search
    { "<leader>s", group = "+search" },
    {
      "<leader>sa",
      function()
        Snacks.picker.grep()
      end,
      desc = "Search All Files",
    },
    {
      "<leader>sb",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "Search Opened Files",
    },
    {
      "<leader>sg",
      function()
        Snacks.picker.git_grep()
      end,
      desc = "Search Git Files",
    },

    -- Introspect
    { "<leader>S", group = "+introspect" },
    {
      "<leader>Sh",
      function()
        Snacks.picker.help()
      end,
      desc = "Search Help",
    },
    {
      "<leader>Sc",
      function()
        Snacks.picker.commands()
      end,
      desc = "Search Commands",
    },
    {
      "<leader>Sk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Search Keymaps",
    },
    {
      "<leader>Sm",
      function()
        Snacks.picker.marks()
      end,
      desc = "Search Marks",
    },

    -- LSP
    { "<leader>n", group = "+goto" },
    {
      "<leader>nn",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Goto Definition",
    },
    {
      "<leader>nN",
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = "Goto Declaration",
    },
    {
      "<leader>nS",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "Find Document Symbols",
    },
    {
      "<leader>ns",
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = "Find Workspace Symbols",
    },
    {
      "<leader>ni",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "Goto Implementation",
    },
    {
      "<leader>nt",
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = "Goto Type Definition",
    },
    {
      "<leader>nr",
      function()
        Snacks.picker.lsp_references()
      end,
      desc = "Find References",
    },

    -- Git
    { "<leader>G",  group = "+git" },
    {
      "<leader>Gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Status",
    },
    {
      "<leader>Gb",
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Branches",
    },
    {
      "<leader>Gl",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Log",
    },
    {
      "<leader>GL",
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "Log (Current File)",
    },
    { "<leader>Gc", ":Git commit<CR>",         desc = "Commit" },
    { "<leader>Gp", ":Git pull<CR>",           desc = "Pull" },
    { "<leader>GP", ":Git push<CR>",           desc = "Push" },
    { "<leader>GB", ":Git blame<CR>",          desc = "Blame" },
    { "<leader>Gd", ":Gdiffsplit<CR>",         desc = "Diff" },
    { "<leader>GD", ":Gdiffsplit!<CR>",        desc = "Force Diff" },
    { "<leader>GA", ":Git add .<CR>",          desc = "Add All" },
    { "<leader>Ga", ":Git add %<CR>",          desc = "Add Current File" },
    { "<leader>Gu", ":Git reset HEAD~<CR>",    desc = "Reset HEAD" },
    { "<leader>Gq", ":Git mergetool<CR>",      desc = "Mergetool" },

    -- Diagnostics
    { "<leader>d",  group = "+diagnostics" },
    { "<leader>de", vim.diagnostic.open_float, desc = "Show Hover" },
    { "<leader>df", vim.diagnostic.open_float, desc = "Show Line" },
    {
      "<leader>dw",
      ":lua vim.diagnostic.setloclist({severity=vim.diagnostic.severity.WARN})<CR>",
      desc = "List Warnings",
    },
    { "<leader>dq",  ":lua vim.diagnostic.setloclist()<CR>", desc = "List All" },
    { "]d",          vim.diagnostic.goto_next,               desc = "Goto Next" },
    { "[d",          vim.diagnostic.goto_prev,               desc = "Goto Previous" },

    -- Refactor
    { "<leader>l",   group = "+refactor" },
    { "<leader>lS",  vim.lsp.buf.signature_help,             desc = "Signature Help" },
    { "<leader>la",  vim.lsp.buf.code_action,                desc = "Code Action" },
    { "<leader>lr",  vim.lsp.buf.rename,                     desc = "Rename Symbol" },
    { "<leader>lw",  group = "+workspace" },
    { "<leader>lwa", vim.lsp.buf.add_workspace_folder,       desc = "Workspace -> Add Folder" },
    { "<leader>lwr", vim.lsp.buf.remove_workspace_folder,    desc = "Workspace -> Remove Folder" },
    { "<leader>lwl", vim.lsp.buf.list_workspace_folders,     desc = "Workspace -> List Folders" },
    {
      "<leader>lf",
      function()
        vim.lsp.buf.code_action({ apply = true })
      end,
      desc = "Extract Function",
    },
    {
      "<leader>lv",
      function()
        vim.lsp.buf.code_action({ kind = "refactor.extract.variable" })
      end,
      desc = "Extract Variable",
    },
    {
      "<leader>le",
      ":Refactor extract <CR>",
      desc = "Extract Function",
      mode = "x",
      silent = false,
    },
    {
      "<leader>lf",
      ":Refactor extract_to_file <CR>",
      desc = "Extract → File",
      mode = "x",
      silent = false,
    },
    {
      "<leader>lv",
      ":Refactor extract_var <CR>",
      desc = "Extract Variable",
      mode = "x",
      silent = false,
    },
    {
      "<leader>lb",
      ":Refactor extract_block <CR>",
      desc = "Extract Block",
      mode = "x",
      silent = false,
    },
    {
      "<leader>lB",
      ":Refactor extract_block_to_file <CR>",
      desc = "Extract Block → File",
      mode = "x",
      silent = false,
    },
    {
      "<leader>li",
      ":Refactor inline_var<CR>",
      desc = "Inline Variable",
      mode = { "n", "x" },
    },
    {
      "<leader>lI",
      ":Refactor inline_func<CR>",
      desc = "Inline Function",
    },
    {
      "<leader>lR",
      function()
        require("refactoring").select_refactor({ prefer_ex_cmd = true })
      end,
      desc = "Select Refactor",
    },

    -- Replace
    { "<leader>r",  group = "+replace" },
    { "<leader>rw", ":%s/\\<<C-r><C-w>\\>/.../g<CR>", desc = "Word" },
    { "<leader>rr", '"hy:%s/<C-r>h/.../g<CR>',        desc = "From Register" },
    { "<leader>rt", ":RemoveTrailingWhitespace<CR>",  desc = "Trim Whitespace" },
    { "<leader>rs", ":%s//gc<CR>",                    desc = "Confirm" },

    -- Edit
    { "<leader>e",  group = "+edit" },
    { "<leader>ej", "J",                              desc = "Join Lines" },
    { "<leader>es", ":sort<CR>",                      desc = "Sort Selection" },
    { "<leader>ei", ">gv",                            desc = "Indent" },
    { "<leader>eu", "gUgv",                           desc = "Uppercase" },
    { "<leader>el", "guvg",                           desc = "Lowercase" },
    { "<leader>e~", "~",                              desc = "Toggle Case" },
    { "<leader>ed", '"_d',                            desc = "Delete (No Yank)" },
    { "<leader>ep", '"_p',                            desc = "Paste (No Override)" },

    -- Format
    { "<leader>F",  group = "+format" },
    {
      "<leader>Ff",
      function()
        vim.lsp.buf.format({ async = false })
      end,
      desc = "File",
    },
    { "<leader>FI", ":ConformInfo<CR>",            desc = "Info" },
    { "<leader>FS", ":set noexpandtab|retab!<CR>", desc = "Convert to Tabs" },
    { "<leader>Fi", "gg=G",                        desc = "Re-Indent All" },
    { "<leader>F2", ":set shiftwidth=2<CR>",       desc = "Set Indent -> 2" },
    { "<leader>F4", ":set shiftwidth=4<CR>",       desc = "Set Indent -> 4" },

    -- Options
    { "<leader>o",  group = "+options" },
    { "<leader>og", ":IBLToggle<CR>",              desc = "Toggle Indent Guides" },
    { "<leader>on", ":set number!<CR>",            desc = "Toggle Numbers" },
    { "<leader>or", ":set relativenumber!<CR>",    desc = "Toggle Relative Numbers" },
    { "<leader>ow", ":set wrap!<CR>",              desc = "Toggle Wrap" },
    { "<leader>os", ":set spell!<CR>",             desc = "Toggle Spell" },
    { "<leader>oc", ":set cursorline!<CR>",        desc = "Toggle Cursorline" },
    { "<leader>oC", ":set cursorcolumn!<CR>",      desc = "Toggle Cursorcolumn" },
    { "<leader>ot", ":FormatToggle<CR>",           desc = "Toggle format-on-save" },
    {
      "<leader>od",
      function()
        vim.g.snacks_dim = not vim.g.snacks_dim
        if (vim.g.snacks_dim) then
          Snacks.dim.enable()
        else
          Snacks.dim.disable()
        end
      end,
      desc = "Toggle Dim"
    },

    -- Test
    { "<leader>t", group = "+test" },
    {
      "<leader>tt",
      function()
        require("neotest").run.run()
      end,
      desc = "Run Nearest",
    },
    {
      "<leader>tT",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run File",
    },
    {
      "<leader>ts",
      function()
        require("neotest").run.run_suite()
      end,
      desc = "Run Suite",
    },
    {
      "<leader>tS",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle Summary",
    },
    {
      "<leader>to",
      function()
        require("neotest").output.open({ enter = true })
      end,
      desc = "Show Output",
    },
    {
      "<leader>td",
      function()
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "Debug Nearest",
    },
    {
      "<leader>tx",
      function()
        require("neotest").run.stop()
      end,
      desc = "Stop",
    },

    -- Git Signs
    { "<leader>h", group = "+gitsigns" },
    {
      "<leader>hj",
      function()
        require("gitsigns").nav_hunk("next")
      end,
      desc = "Next Hunk",
    },
    {
      "<leader>hk",
      function()
        require("gitsigns").nav_hunk("prev")
      end,
      desc = "Previous Hunk",
    },
    {
      "<leader>hs",
      function()
        require("gitsigns").stage_hunk()
      end,
      desc = "Stage Hunk",
    },
    {
      "<leader>hr",
      function()
        require("gitsigns").reset_hunk()
      end,
      desc = "Reset Hunk",
    },
    {
      "<leader>hS",
      function()
        require("gitsigns").stage_buffer()
      end,
      desc = "Stage Buffer",
    },
    {
      "<leader>hR",
      function()
        require("gitsigns").reset_buffer()
      end,
      desc = "Reset Buffer",
    },
    {
      "<leader>hp",
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = "Preview Hunk",
    },
    {
      "<leader>hb",
      function()
        require("gitsigns").blame_line({ full = true })
      end,
      desc = "Blame Line",
    },
    {
      "<leader>hd",
      function()
        require("gitsigns").diffthis()
      end,
      desc = "Diff This",
    },
    { "<leader>ht", group = "+toggle" },
    {
      "<leader>htb",
      function()
        require("gitsigns").toggle_current_line_blame()
      end,
      desc = "Toggle Blame",
    },
    {
      "<leader>htw",
      function()
        require("gitsigns").toggle_word_diff()
      end,
      desc = "Toggle Word Diff",
    },
    {
      "<leader>hts",
      function()
        require("gitsigns").toggle_signs()
      end,
      desc = "Toggle Signs",
    },

    -- Macro
    { "<leader>m",  group = "+macro" },
    { "<leader>mq", "qq",             desc = "Record 'q'" },
    { "<leader>ml", "@@",             desc = "Play Last" },
    { "<leader>mr", "@r",             desc = "Play 'r'" },
  }

  if vim.g.neovide then
    table.insert(mappings, {
      "<leader>o+",
      function()
        if vim.g.neovide then
          vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
        end
      end,
      desc = "Scale Up",
    })

    table.insert(mappings, {
      "<leader>o-",
      function()
        if vim.g.neovide then
          vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
        end
      end,
      desc = "Scale Down",
    })

    table.insert(mappings, {
      "<leader>of",
      function()
        vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
      end,
      desc = "Toggle Fullscreen",
    })
  end

  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Goto Next Diagnostic" })
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Goto Previous Diagnostic" })

  vim.keymap.set({ "n", "i", "v" }, "<C-`>", function()
    Snacks.terminal.toggle()
  end, { desc = "Toggle Terminal" })

  vim.keymap.set("t", "<C-`>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
    Snacks.terminal.toggle()
  end, { desc = "Toggle Terminal" })

  wk.add({
    { mode = "n", unpack(mappings) },
  })
end

return M
