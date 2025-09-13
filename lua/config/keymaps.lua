-- ~/.config/nvim/lua/keymaps.lua

local M = {}
local default_opts = { noremap = true, silent = true }

function M.map(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", default_opts, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

local snacks = require("snacks")

function M.setup()
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    local mappings = {
      -- Scratch
      { "<leader>.", group = "+scratch" },
      {
        "<leader>..",
        function()
          local list = snacks.scratch.list()
          if #list > 0 then
            local latest = list[1]
            snacks.scratch({ name = latest.name, ft = latest.ft })
          else
            snacks.scratch()
          end
        end,
        desc = "Open Last/Default",
      },
      {
        "<leader>.f",
        function()
          snacks.scratch.select()
        end,
        desc = "Find",
      },
      {
        "<leader>.n",
        function()
          vim.ui.input({ prompt = "Scratch name: " }, function(name)
            if name and name ~= "" then
              require("snacks").scratch({ name = name })
            end
          end)
        end,
        desc = "New",
      },

      -- Undo
      {
        "<leader>u",
        function()
          snacks.picker.undo()
        end,
        desc = "Undo History",
      },
      {
        "<leader>U",
        function()
          snacks.picker.redo()
        end,
        desc = "Redo History",
      },

      -- Quit
      { "<leader>q", group = "+quit" },
      { "<leader>qq", ":qa<CR>", desc = "Quit All" },
      { "<leader>qQ", ":qa!<CR>", desc = "Force Quit All" },

      -- Window
      { "<leader>w", group = "+window" },
      { "<leader>wh", "<C-w>h", desc = "Move to Left Window" },
      { "<leader>wj", "<C-w>j", desc = "Move to Bottom Window" },
      { "<leader>wk", "<C-w>k", desc = "Move to Top Window" },
      { "<leader>wl", "<C-w>l", desc = "Move to Right Window" },
      { "<leader>wd", "<C-w>c", desc = "Close Current Window" },
      { "<leader>wo", "<C-w>o", desc = "Close Other Windows" },
      { "<leader>ws", "<C-w>s", desc = "Split Horizontal" },
      { "<leader>wv", "<C-w>v", desc = "Split Vertical" },
      { "<leader>w=", "<C-w>=", desc = "Equalize" },
      { "<leader>w>", "<C-w>>", desc = "Increase Width" },
      { "<leader>w<", "<C-w><", desc = "Decrease Width" },
      { "<leader>w+", "<C-w>+", desc = "Increase Height" },
      { "<leader>w-", "<C-w>-", desc = "Decrease Height" },
      { "<leader>wH", "<C-w>H", desc = "Move to Far Left" },
      { "<leader>wL", "<C-w>L", desc = "Move to Far Right" },
      { "<leader>wK", "<C-w>K", desc = "Move to Far Top" },
      { "<leader>wJ", "<C-w>J", desc = "Move to Far Bottom" },

      -- File
      { "<leader>f", group = "+file" },
      {
        "<leader>fn",
        function()
          vim.ui.input({ prompt = "File name: ", completion = "file" }, function(filepath)
            if not filepath or filepath == "" then
              return
            end

            local stat = vim.loop.fs_stat(filepath)
            if not stat then
              local dir = vim.fn.fnamemodify(filepath, ":h")

              if dir ~= "." and dir ~= "" then
                vim.loop.fs_mkdir(dir, 493)
              end

              vim.cmd.edit(filepath) -- TODO if file opened in another buffer, switch to it
            end
          end)
        end,
        desc = "New",
      },
      {
        "<leader>ff",
        function()
          snacks.picker.smart()
        end,
        desc = "Smart Find File",
      },
      {
        "<leader>fF",
        function()
          snacks.picker.files()
        end,
        desc = "Find File",
      },
      {
        "<leader>fg",
        function()
          snacks.picker.git_files()
        end,
        desc = "Find in Git",
      },
      {
        "<leader>fr",
        function()
          snacks.picker.recent()
        end,
        desc = "Find Recent",
      },
      { "<leader>fs", ":w<CR>", desc = "Save" },
      { "<leader>fS", ":wa<CR>", desc = "Save All" },
      {
        "<leader>fe",
        function()
          snacks.explorer()
        end,
        desc = "Toggle Explorer",
      },
      {
        "<leader>fp",
        function()
          snacks.picker.projects()
        end,
        desc = "Find Projects",
      },

      -- Buffer
      { "<leader>b", group = "+buffer" },
      {
        "<leader>bb",
        function()
          snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      { "<leader>bn", ":new<CR>", desc = "New" },
      { "<leader>bp", ":BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", ":BufferLinePick<CR>", desc = "Pick" },
      { "<leader>br", ":BufRename<CR>", desc = "Rename" },
      { "<leader>bl", ":BufMoveRight<CR>", desc = "Move Right" },
      { "<leader>bh", ":BufMoveLeft<CR>", desc = "Move Left" },
      { "<Tab>", ":BufferLineCycleNext<CR>", desc = "Buffer -> Next" },
      { "<S-Tab>", ":BufferLineCyclePrev<CR>", desc = "Buffer -> Previous" },
      { "L", ":BufferLineCycleNext<CR>", desc = "Buffer -> Next" },
      { "H", ":BufferLineCyclePrev<CR>", desc = "Buffer -> Previous" },
      {
        "<leader>bd",
        function()
          snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>bx",
        function()
          snacks.bufdelete({ force = true })
        end,
        desc = "Force Delete Buffer",
      },
      {
        "<leader>bo",
        function()
          snacks.bufdelete.other()
        end,
        desc = "Delete Other Buffers",
      },
      {
        "<leader>bO",
        function()
          snacks.bufdelete.all()
        end,
        desc = "Delete All Buffers",
      },

      -- Navigation
      { "<leader>s", group = "+search" },
      {
        "<leader>sa",
        function()
          snacks.picker.grep()
        end,
        desc = "Go to File",
      },
      {
        "<leader>sb",
        function()
          snacks.picker.grep_buffers()
        end,
        desc = "Go to File (opened)",
      },
      {
        "<leader>sg",
        function()
          snacks.picker.git_grep()
        end,
        desc = "Go to File (in Git)",
      },
      {
        "<leader>sd",
        function()
          snacks.picker.lsp_definitions()
        end,
        desc = "Go to Definition",
      },
      {
        "<leader>sD",
        function()
          snacks.picker.lsp_declarations()
        end,
        desc = "Pick Declaration",
      },
      {
        "<leader>sr",
        function()
          snacks.picker.lsp_references()
        end,
        desc = "Go to Reference",
      },
      {
        "<leader>si",
        function()
          snacks.picker.lsp_implementations()
        end,
        desc = "Go to Implementation",
      },
      {
        "<leader>st",
        function()
          snacks.picker.lsp_type_definitions()
        end,
        desc = "Go to Type Definition",
      },
      {
        "<leader>ss",
        function()
          snacks.picker.lsp_workspace_symbols()
        end,
        desc = "Go to Symbol",
      },
      {
        "<leader>sS",
        function()
          snacks.picker.lsp_symbols()
        end,
        desc = "Go to Document Symbol",
      },

      -- Introspect
      { "<leader>S", group = "+introspect" },
      {
        "<leader>Sh",
        function()
          snacks.picker.help()
        end,
        desc = "Search Help",
      },
      {
        "<leader>Sc",
        function()
          snacks.picker.commands()
        end,
        desc = "Search Commands",
      },
      {
        "<leader>Sk",
        function()
          snacks.picker.keymaps()
        end,
        desc = "Search Keymaps",
      },
      {
        "<leader>Sm",
        function()
          snacks.picker.marks()
        end,
        desc = "Search Marks",
      },

      -- Git
      { "<leader>G", group = "+git" },
      {
        "<leader>Gs",
        function()
          snacks.picker.git_status()
        end,
        desc = "Status",
      },
      {
        "<leader>Gb",
        function()
          snacks.picker.git_branches()
        end,
        desc = "Branches",
      },
      {
        "<leader>Gl",
        function()
          snacks.picker.git_log()
        end,
        desc = "Log",
      },
      {
        "<leader>GL",
        function()
          snacks.picker.git_log_file()
        end,
        desc = "Log (Current File)",
      },
      { "<leader>Gc", ":Git commit<CR>", desc = "Commit" },
      { "<leader>Gp", ":Git pull<CR>", desc = "Pull" },
      { "<leader>GP", ":Git push<CR>", desc = "Push" },
      { "<leader>GB", ":Git blame<CR>", desc = "Blame" }, -- TODO use plugin
      { "<leader>Gd", ":Gdiffsplit<CR>", desc = "Diff" },
      { "<leader>GD", ":Gdiffsplit!<CR>", desc = "Force Diff" },
      { "<leader>GA", ":Git add .<CR>", desc = "Add All" },
      { "<leader>Ga", ":Git add %<CR>", desc = "Add Current File" },
      { "<leader>Gm", ":Git mergetool<CR>", desc = "Mergetool" },

      -- Diagnostics
      { "<leader>d", group = "+diagnostics" },
      { "<leader>dp", vim.diagnostic.open_float, desc = "Show Hover" },
      {
        "<leader>dw",
        ":lua vim.diagnostic.setloclist({severity=vim.diagnostic.severity.WARN})<CR>", -- TODO use plugin
        desc = "List Warnings",
      },
      { "<leader>da", ":lua vim.diagnostic.setloclist()<CR>", desc = "List All" },
      { "]d", vim.diagnostic.goto_next, desc = "Goto Next", mode = "n" },
      { "[d", vim.diagnostic.goto_prev, desc = "Goto Previous", mode = "n" },

      -- Workspace
      { "<leader>W", group = "+workspace" },
      { "<leader>Wa", vim.lsp.buf.add_workspace_folder, desc = "Workspace -> Add Folder" },
      { "<leader>Wr", vim.lsp.buf.remove_workspace_folder, desc = "Workspace -> Remove Folder" },
      { "<leader>Wl", vim.lsp.buf.list_workspace_folders, desc = "Workspace -> List Folders" },

      -- Signature Help
      { "<C-k>", vim.lsp.buf.signature_help, desc = "Signature Help", mode = "i" },
      { "<C-k>", vim.lsp.buf.signature_help, desc = "Signature Help", mode = "n" },

      -- Refactor
      { "<leader>x", group = "+refactor" },
      { "<leader>xx", vim.lsp.buf.code_action, desc = "Context Action", mode = { "v", "n" } },
      { "<leader>xr", vim.lsp.buf.rename, desc = "Rename" }, -- TODO revise (F2?)

      -- Format
      {
        "<leader>F",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format",
      },

      -- Options
      { "<leader>o", group = "+toggle" },
      { "<leader>og", ":IBLToggle<CR>", desc = "Indent Guides" },
      {
        "<leader>on",
        function()
          local current_is_relative = vim.wo.relativenumber
          local current_is_normal = vim.wo.number

          if not current_is_normal and not current_is_relative then
            vim.wo.number = true
          elseif current_is_normal and not current_is_relative then
            vim.wo.relativenumber = true
          else
            vim.wo.number = false
            vim.wo.relativenumber = false
          end
        end,
        desc = "Numbers",
      },
      { "<leader>ow", ":set wrap!<CR>", desc = "Wrap" },
      { "<leader>os", ":set spell!<CR>", desc = "Spell" },
      { "<leader>oc", ":set cursorline!<CR>", desc = "Cursorline" },
      { "<leader>oC", ":set cursorcolumn!<CR>", desc = "Cursorcolumn" },
      { "<leader>ot", ":FormatToggle<CR>", desc = "format-on-save" },
      {
        "<leader>od",
        function()
          vim.g.snacks_dim = not vim.g.snacks_dim
          if vim.g.snacks_dim then
            snacks.dim.enable()
          else
            snacks.dim.disable()
          end
        end,
        desc = "Dim",
      },
      {
        "<leader>oi",
        function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })
        end,
        desc = "Inlay Hints",
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

      -- Terminal
      {
        "<F2>",
        function()
          snacks.terminal.toggle()
        end,
        desc = "Toggle Terminal",
        mode = { "n", "i", "v" },
      },
      {
        "<F2>",
        function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
          snacks.terminal.toggle()
        end,
        desc = "Toggle Terminal",
        mode = "t",
      },

      -- Run
      { "<leader>r", group = "+run" },
      { "<leader>rU", group = "+ui" },
      { "<leader>rB", group = "+breakpoints" },
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

    for _, mapping in ipairs(mappings) do
      local mode = mapping.mode or "n"
      mapping.mode = nil
      wk.add({
        { mode = mode, mapping },
      })
    end

    vim.keymap.set("i", "jj", "<Esc>", { desc = "Escape" })
    vim.keymap.set("i", "оо", "<Esc>", { desc = "Escape" })
  end
end

return M
