-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/config/keymaps.lua
-- @brief: Neovim key mapping configurations and shortcuts.

local M = {}

local snacks = require("snacks")

local function safe_require(module)
  local ok, result = pcall(require, module)
  return ok and result or nil
end

local function flash_action(action_name, multi_window)
  return function()
    local flash = safe_require("flash")
    if flash then
      if action_name == "jump" then
        flash.jump({ multi_window = multi_window or false })
      elseif action_name == "treesitter" then
        flash.treesitter()
      elseif action_name == "remote" then
        flash.remote()
      end
    end
  end
end

local function glance_action(action_type)
  return function()
    local glance = safe_require("glance")
    if glance then
      glance.open(action_type)
    end
  end
end

local function trouble_action(mode, filter)
  return function()
    local trouble = safe_require("trouble")
    if trouble then
      trouble.toggle(mode, filter)
    end
  end
end

local function gitsigns_action(action_name)
  return function()
    require("gitsigns")[action_name]()
  end
end

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
      { "]s", "]s", desc = "Next Spelling Issue" },
      { "[s", "[s", desc = "Previous Spelling Issue" },
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

      -- Motion (Flash)
      { "s", flash_action("jump", false), desc = "Flash Jump", mode = { "n", "x", "o" } },
      { "S", flash_action("treesitter"), desc = "Flash Treesitter", mode = { "n", "x", "o" } },
      { "<leader><space>", flash_action("jump", true), desc = "Flash Jump (All Windows)", mode = { "n", "x", "o" } },
      { "gr", flash_action("remote"), desc = "Flash Remote", mode = { "n", "x", "o" } },

      { "gs", group = "+surround", mode = { "n", "x" } },
      { "gsa", desc = "Surround Add", mode = { "n", "x" } },
      { "gsd", desc = "Surround Delete", mode = "n" },
      { "gsr", desc = "Surround Replace", mode = { "n", "x" } },
      { "gsf", desc = "Surround Find Right", mode = "n" },
      { "gsF", desc = "Surround Find Left", mode = "n" },
      { "gsh", desc = "Surround Highlight", mode = "n" },
      { "gsn", desc = "Surround Update N Lines", mode = "n" },
      { "gsL", desc = "Surround Suffix Last", mode = "n" },
      { "gsN", desc = "Surround Suffix Next", mode = "n" },

      { "gc", group = "+comment", mode = { "n", "x" } },
      { "gcc", desc = "Comment -> Line", mode = "n" },
      { "gcb", desc = "Comment -> Block", mode = "n" },

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
                vim.fn.mkdir(dir, "p")
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

      -- Session
      { "<leader>m", group = "+session" },
      {
        "<leader>ms",
        function()
          local ok, persistence = pcall(require, "persistence")
          if ok then
            persistence.load()
          end
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ml",
        function()
          local ok, persistence = pcall(require, "persistence")
          if ok then
            persistence.load({ last = true })
          end
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>mx",
        function()
          local ok, persistence = pcall(require, "persistence")
          if ok then
            persistence.stop()
          end
        end,
        desc = "Session Save Off",
      },
      {
        "zg",
        function()
          vim.cmd("silent normal! zg")
          vim.notify("Word added to spellfile", vim.log.levels.INFO)
        end,
        desc = "Spelling Add",
      },
      {
        "zw",
        function()
          vim.cmd("silent normal! zw")
          vim.notify("Word marked incorrect", vim.log.levels.INFO)
        end,
        desc = "Spelling Remove",
      },

      -- Paste / Yank history
      { "<leader>p", group = "+paste" },
      { "<leader>p?", desc = "Yank History" },

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
      { "<leader>bp", ":LualineBuffersTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", ":LualineBuffersPick<CR>", desc = "Pick Buffer" },
      { "<leader>br", ":BufRename<CR>", desc = "Rename" },
      { "<leader>bl", ":bnext<CR>", desc = "Next Buffer" },
      { "<leader>bh", ":bprevious<CR>", desc = "Previous Buffer" },
      { "<Tab>", ":bnext<CR>", desc = "Buffer -> Next" },
      { "<S-Tab>", ":bprevious<CR>", desc = "Buffer -> Previous" },
      { "L", ":bnext<CR>", desc = "Buffer -> Next" },
      { "H", ":bprevious<CR>", desc = "Buffer -> Previous" },
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
        "<leader>sr",
        function()
          local ok, spectre = pcall(require, "spectre")
          if not ok then
            return
          end
          local mode = vim.fn.mode()
          if mode == "v" or mode == "V" then
            spectre.open_visual()
          else
            spectre.open()
          end
        end,
        desc = "Search/Replace (Spectre)",
        mode = { "n", "x" },
      },
      { "<leader>sd", glance_action("definitions"), desc = "Glance Definitions" },
      {
        "<leader>sD",
        function()
          snacks.picker.lsp_declarations()
        end,
        desc = "Pick Declaration",
      },
      { "<leader>sR", glance_action("references"), desc = "Glance References" },
      { "<leader>si", glance_action("implementations"), desc = "Glance Implementations" },
      { "<leader>sT", glance_action("type_definitions"), desc = "Glance Type Definitions" },
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
      {
        "<leader>st",
        "<cmd>TodoTrouble<CR>",
        desc = "TODO Comments",
      },
      {
        "<leader>sH",
        function()
          require("meow.yarn").open_tree("type_hierarchy", "supertypes")
        end,
        desc = "Type Hierarchy (Super)",
      },
      {
        "<leader>sh",
        function()
          require("meow.yarn").open_tree("type_hierarchy", "subtypes")
        end,
        desc = "Type Hierarchy (Sub)",
      },
      {
        "<leader>sc",
        function()
          require("meow.yarn").open_tree("call_hierarchy", "callers")
        end,
        desc = "Call Hierarchy (Callers)",
      },
      {
        "<leader>sC",
        function()
          require("meow.yarn").open_tree("call_hierarchy", "callees")
        end,
        desc = "Call Hierarchy (Callees)",
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

      -- Tooling
      { "<leader>M", group = "+mason" },
      { "<leader>Mm", "<cmd>Mason<CR>", desc = "Open Mason" },
      { "<leader>MT", "<cmd>MasonToolsInstall<CR>", desc = "Install Missing Tools" },

      -- Git
      { "<leader>G", group = "+git" },
      {
        "<leader>Gs",
        function()
          local ok, neogit = pcall(require, "neogit")
          if ok then
            neogit.open({ kind = "replace" })
          end
        end,
        desc = "Neogit Status",
      },
      {
        "<leader>Gc",
        function()
          vim.cmd("Neogit commit")
        end,
        desc = "Neogit Commit",
      },
      {
        "<leader>Gp",
        function()
          vim.cmd("Neogit pull")
        end,
        desc = "Neogit Pull",
      },
      {
        "<leader>GP",
        function()
          vim.cmd("Neogit push")
        end,
        desc = "Neogit Push",
      },
      {
        "<leader>G.",
        function()
          snacks.picker.git_status()
        end,
        desc = "Status (Picker)",
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
      {
        "<leader>Gy",
        function()
          local ok, gitlinker = pcall(require, "gitlinker")
          if not ok then
            return
          end
          local actions = require("gitlinker.actions")
          local mode = vim.fn.mode()
          if mode == "v" or mode == "V" then
            gitlinker.get_buf_range_url("v", { action_callback = actions.copy_to_clipboard })
          else
            gitlinker.get_buf_range_url("n", { action_callback = actions.copy_to_clipboard })
          end
          vim.notify("Link copied to clipboard", vim.log.levels.INFO)
        end,
        desc = "Git Link -> Copy",
        mode = { "n", "v" },
      },
      {
        "<leader>GY",
        function()
          local ok, gitlinker = pcall(require, "gitlinker")
          if not ok then
            return
          end
          local actions = require("gitlinker.actions")
          local mode = vim.fn.mode()
          if mode == "v" or mode == "V" then
            gitlinker.get_buf_range_url("v", { action_callback = actions.open_in_browser })
          else
            gitlinker.get_buf_range_url("n", { action_callback = actions.open_in_browser })
          end
        end,
        desc = "Git Link -> Browser",
        mode = { "n", "v" },
      },
      { "<leader>Gd", ":DiffviewOpen<CR>", desc = "Diffview Open" },
      { "<leader>GD", ":DiffviewClose<CR>", desc = "Diffview Close" },
      { "<leader>Gf", ":DiffviewFileHistory %<CR>", desc = "File History" },
      { "<leader>GF", ":DiffviewFileHistory<CR>", desc = "Repository History" },
      { "<leader>GX", group = "+conflict" },
      { "<leader>GXn", ":GitConflictNextConflict<CR>", desc = "Conflict Next" },
      { "<leader>GXp", ":GitConflictPrevConflict<CR>", desc = "Conflict Prev" },
      { "<leader>GXo", ":GitConflictChooseOurs<CR>", desc = "Conflict Choose Ours" },
      { "<leader>GXt", ":GitConflictChooseTheirs<CR>", desc = "Conflict Choose Theirs" },
      { "<leader>GXb", ":GitConflictChooseBoth<CR>", desc = "Conflict Choose Both" },
      { "<leader>GX0", ":GitConflictChooseNone<CR>", desc = "Conflict Choose None" },
      { "<leader>GXl", ":GitConflictListQf<CR>", desc = "Conflict List QF" },
      { "<leader>GXr", ":GitConflictRefresh<CR>", desc = "Conflict Refresh" },
      { "<leader>GI", "<cmd>GHSearchIssues<CR>", desc = "GitHub Search Issues" },
      { "<leader>Gq", "<cmd>GHSearchPRs<CR>", desc = "GitHub Search PRs" },
      { "<leader>Gv", "<cmd>GHToggleThreads<CR>", desc = "GitHub Toggle Threads" },
      { "<leader>Gm", "<cmd>GHOpenPR<CR>", desc = "GitHub Open PR" },
      { "<leader>Gi", "<cmd>GHOpenIssue<CR>", desc = "GitHub Open Issue" },

      -- Diagnostics
      { "<leader>d", group = "+diagnostics" },
      { "<leader>dd", trouble_action("diagnostics"), desc = "Diagnostics (Trouble)" },
      { "<leader>db", trouble_action("diagnostics", { filter = { buf = 0 } }), desc = "Buffer Diagnostics" },
      { "<leader>dq", trouble_action("quickfix"), desc = "Quickfix (Trouble)" },
      { "<leader>dl", trouble_action("loclist"), desc = "Loclist (Trouble)" },
      { "<leader>ds", trouble_action("symbols", { focus = false }), desc = "Document Symbols (Trouble)" },
      { "<leader>dp", vim.diagnostic.open_float, desc = "Show Hover" },
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
      {
        "<leader>xl",
        vim.lsp.codelens.run,
        desc = "Run Code Lens",
      },

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
      {
        "<leader>og",
        function()
          local ok, indentscope = pcall(require, "mini.indentscope")
          if not ok then
            return
          end

          vim.g.miniindentscope_disable = not vim.g.miniindentscope_disable
          indentscope.refresh()

          local level = vim.g.miniindentscope_disable and vim.log.levels.WARN or vim.log.levels.INFO
          local state = vim.g.miniindentscope_disable and "OFF" or "ON"
          vim.notify("Indent scope: " .. state, level)
        end,
        desc = "Indent Guides",
      },
      {
        "<leader>oz",
        function()
          local ok, ufo = pcall(require, "ufo")
          if ok then
            ufo.closeAllFolds()
          end
        end,
        desc = "Folds Close All",
      },
      {
        "<leader>oZ",
        function()
          local ok, ufo = pcall(require, "ufo")
          if ok then
            ufo.openAllFolds()
          end
        end,
        desc = "Folds Open All",
      },
      {
        "<leader>op",
        function()
          local ok, ufo = pcall(require, "ufo")
          if ok then
            ufo.peekFoldedLinesUnderCursor()
          end
        end,
        desc = "Fold Peek",
      },
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
        "<leader>oL",
        vim.lsp.codelens.refresh,
        desc = "Refresh Code Lenses",
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
      { "<leader>hs", gitsigns_action("stage_hunk"), desc = "Stage Hunk" },
      { "<leader>hr", gitsigns_action("reset_hunk"), desc = "Reset Hunk" },
      { "<leader>hS", gitsigns_action("stage_buffer"), desc = "Stage Buffer" },
      { "<leader>hR", gitsigns_action("reset_buffer"), desc = "Reset Buffer" },
      { "<leader>hp", gitsigns_action("preview_hunk"), desc = "Preview Hunk" },
      {
        "<leader>hb",
        function()
          require("gitsigns").blame_line({ full = true })
        end,
        desc = "Blame Line",
      },
      { "<leader>hd", gitsigns_action("diffthis"), desc = "Diff This" },
      { "<leader>ht", group = "+toggle" },
      { "<leader>htb", gitsigns_action("toggle_current_line_blame"), desc = "Toggle Blame" },
      { "<leader>htw", gitsigns_action("toggle_word_diff"), desc = "Toggle Word Diff" },
      { "<leader>hts", gitsigns_action("toggle_signs"), desc = "Toggle Signs" },

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
      {
        "<leader>rr",
        function()
          local ok, overseer = pcall(require, "overseer")
          if ok then
            overseer.run_template()
          end
        end,
        desc = "Task -> Run Template",
      },
      {
        "<leader>rR",
        function()
          local ok, overseer = pcall(require, "overseer")
          if not ok then
            return
          end
          local tasks = overseer.list_tasks({ recent_first = true })
          local task = tasks[1]
          if task then
            overseer.run_action(task, "restart")
          else
            vim.notify("No recent tasks", vim.log.levels.WARN)
          end
        end,
        desc = "Task -> Restart Last",
      },
      {
        "<leader>ro",
        function()
          local ok, overseer = pcall(require, "overseer")
          if ok then
            overseer.toggle({ enter = false })
          end
        end,
        desc = "Task -> Toggle List",
      },
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
