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

local function open_scratch()
  local list = snacks.scratch.list()
  if #list > 0 then
    local latest = list[1]
    snacks.scratch({ name = latest.name, ft = latest.ft })
  else
    snacks.scratch()
  end
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
      -- Files
      { "<leader>f", group = "+files" },
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
        desc = "Recent Files",
      },
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

              vim.cmd.edit(filepath)
            else
              vim.cmd.edit(filepath)
            end
          end)
        end,
        desc = "New File",
      },
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
        desc = "Project Picker",
      },
      { "<leader>fs", ":w<CR>", desc = "Save File" },
      { "<leader>fS", ":wa<CR>", desc = "Save All Files" },

      -- Flash Jump
      { "<leader><space>", flash_action("jump", false), desc = "Jump", mode = { "n", "x", "o" } },

      -- Workspace
      { "<leader>oW", group = "+workspace" },
      { "<leader>oWa", vim.lsp.buf.add_workspace_folder, desc = "Add Workspace Folder" },
      { "<leader>oWR", vim.lsp.buf.remove_workspace_folder, desc = "Remove Workspace Folder" },
      { "<leader>oWL", vim.lsp.buf.list_workspace_folders, desc = "List Workspace Folders" },


      { "<leader>oS", group = "+session" },
      {
        "<leader>oSr",
        function()
          local ok, persistence = pcall(require, "persistence")
          if ok then
            persistence.load()
          end
        end,
        desc = "Restore Session",
      },
      {
        "<leader>oSl",
        function()
          local ok, persistence = pcall(require, "persistence")
          if ok then
            persistence.load({ last = true })
          end
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>oSx",
        function()
          local ok, persistence = pcall(require, "persistence")
          if ok then
            persistence.stop()
          end
        end,
        desc = "Stop Session Saving",
      },

      -- Buffers
      { "<leader>b", group = "+buffers" },
      {
        "<leader>bb",
        function()
          snacks.picker.buffers()
        end,
        desc = "List Buffers",
      },
      { "<leader>bn", ":new<CR>", desc = "New Buffer" },
      { "<leader>bp", ":bprevious<CR>", desc = "Previous Buffer" },
      { "<leader>bf", ":bnext<CR>", desc = "Next Buffer" },
      { "<leader>br", ":BufRename<CR>", desc = "Rename Buffer" },
      {
        "<leader>bd",
        function()
          snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>bD",
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
        "<leader>ba",
        function()
          snacks.bufdelete.all()
        end,
        desc = "Delete All Buffers",
      },

      -- Windows
      { "<leader>w", group = "+windows" },
      { "<leader>wh", "<C-w>h", desc = "Focus Left Window" },
      { "<leader>wj", "<C-w>j", desc = "Focus Lower Window" },
      { "<leader>wk", "<C-w>k", desc = "Focus Upper Window" },
      { "<leader>wl", "<C-w>l", desc = "Focus Right Window" },
      { "<leader>ws", "<C-w>s", desc = "Split Horizontal" },
      { "<leader>wv", "<C-w>v", desc = "Split Vertical" },
      { "<leader>wc", "<C-w>c", desc = "Close Window" },
      { "<leader>wo", "<C-w>o", desc = "Close Other Windows" },
      { "<leader>w=", "<C-w>=", desc = "Equalize Windows" },
      { "<leader>w>", "<C-w>>", desc = "Increase Width" },
      { "<leader>w<", "<C-w><", desc = "Decrease Width" },
      { "<leader>w+", "<C-w>+", desc = "Increase Height" },
      { "<leader>w-", "<C-w>-", desc = "Decrease Height" },
      { "<leader>wH", "<C-w>H", desc = "Move Far Left" },
      { "<leader>wL", "<C-w>L", desc = "Move Far Right" },
      { "<leader>wK", "<C-w>K", desc = "Move Far Top" },
      { "<leader>wJ", "<C-w>J", desc = "Move Far Bottom" },

      -- Search & Navigaton
      { "<leader>s", group = "+search" },
      {
        "<leader>s/",
        function()
          snacks.picker.grep()
        end,
        desc = "Search Project",
      },
      {
        "<leader>sb",
        function()
          snacks.picker.grep_buffers()
        end,
        desc = "Search Open Buffers",
      },
      {
        "<leader>sg",
        function()
          snacks.picker.git_grep()
        end,
        desc = "Search in Git",
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
      { "<leader>st", "<cmd>TodoTrouble<CR>", desc = "TODO Comments" },

      -- Flash Jump
      { "<leader>j", group = "+jump" },
      { "<leader>jj", flash_action("jump", false), desc = "Flash Jump", mode = { "n", "x", "o" } },
      { "<leader>jt", flash_action("treesitter"), desc = "Flash Treesitter", mode = { "n", "x", "o" } },
      { "<leader>ja", flash_action("jump", true), desc = "Flash Jump (All Windows)", mode = { "n", "x", "o" } },
      { "<leader>jm", flash_action("remote"), desc = "Flash Remote", mode = { "n", "x", "o" } },

      -- Navigation
      { "<leader>n", group = "+navigate" },
      { "<leader>nd", glance_action("definitions"), desc = "Glance Definitions" },
      {
        "<leader>nD",
        function()
          snacks.picker.lsp_declarations()
        end,
        desc = "Pick Declaration",
      },
      { "<leader>nr", glance_action("references"), desc = "Glance References" },
      { "<leader>ni", glance_action("implementations"), desc = "Glance Implementations" },
      { "<leader>nt", glance_action("type_definitions"), desc = "Glance Type Definitions" },
      {
        "<leader>ns",
        function()
          snacks.picker.lsp_symbols()
        end,
        desc = "Document Symbols",
      },
      {
        "<leader>nw",
        function()
          snacks.picker.lsp_workspace_symbols()
        end,
        desc = "Workspace Symbols",
      },
      {
        "<leader>nh",
        function()
          require("meow.yarn").open_tree("type_hierarchy", "subtypes")
        end,
        desc = "Type Hierarchy (Subtypes)",
      },
      {
        "<leader>nH",
        function()
          require("meow.yarn").open_tree("type_hierarchy", "supertypes")
        end,
        desc = "Type Hierarchy (Supertypes)",
      },
      {
        "<leader>nc",
        function()
          require("meow.yarn").open_tree("call_hierarchy", "callers")
        end,
        desc = "Call Hierarchy (Callers)",
      },
      {
        "<leader>nC",
        function()
          require("meow.yarn").open_tree("call_hierarchy", "callees")
        end,
        desc = "Call Hierarchy (Callees)",
      },

      -- Code Intelligence
      { "<leader>c", group = "+code" },
      { "<leader>cd", group = "+diagnostics" },
      { "<leader>cda", trouble_action("diagnostics"), desc = "Diagnostics (Project)" },
      { "<leader>cdb", trouble_action("diagnostics", { filter = { buf = 0 } }), desc = "Diagnostics (Buffer)" },
      { "<leader>cdq", trouble_action("quickfix"), desc = "Quickfix (Trouble)" },
      { "<leader>cdl", trouble_action("loclist"), desc = "Loclist (Trouble)" },
      { "<leader>cds", trouble_action("symbols", { focus = false }), desc = "Symbols (Trouble)" },
      { "<leader>cdh", vim.diagnostic.open_float, desc = "Line Diagnostics" },
      { "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic", mode = "n" },
      { "[d", vim.diagnostic.goto_prev, desc = "Previous Diagnostic", mode = "n" },
      { "<leader>cc", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename Symbol" },
      { "<leader>cl", vim.lsp.codelens.run, desc = "Run Code Lens" },
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format Buffer",
      },
      {
        "<leader>cL",
        vim.lsp.codelens.refresh,
        desc = "Refresh Code Lenses",
      },

      -- Git & VCS
      { "<leader>g", group = "+git" },
      { "<leader>gs", group = "+status" },
      {
        "<leader>gss",
        function()
          local ok, neogit = pcall(require, "neogit")
          if ok then
            neogit.open({ kind = "replace" })
          end
        end,
        desc = "Neogit Status",
      },
      {
        "<leader>gsp",
        function()
          snacks.picker.git_status()
        end,
        desc = "Git Status Picker",
      },
      { "<leader>gc", group = "+changes" },
      { "<leader>gcc", "<cmd>Neogit commit<CR>", desc = "Neogit Commit" },
      { "<leader>gcp", "<cmd>Neogit pull<CR>", desc = "Neogit Pull" },
      { "<leader>gcP", "<cmd>Neogit push<CR>", desc = "Neogit Push" },
      {
        "<leader>gcb",
        function()
          snacks.picker.git_branches()
        end,
        desc = "Git Branches",
      },
      {
        "<leader>gcl",
        function()
          snacks.picker.git_log()
        end,
        desc = "Git Log",
      },
      {
        "<leader>gcL",
        function()
          snacks.picker.git_log_file()
        end,
        desc = "Git Log (File)",
      },
      { "<leader>gd", group = "+diff" },
      { "<leader>gdo", ":DiffviewOpen<CR>", desc = "Diffview Open" },
      { "<leader>gdc", ":DiffviewClose<CR>", desc = "Diffview Close" },
      { "<leader>gdf", ":DiffviewFileHistory %<CR>", desc = "File History" },
      { "<leader>gdF", ":DiffviewFileHistory<CR>", desc = "Repository History" },
      { "<leader>gh", group = "+hunks" },
      {
        "<leader>ghn",
        function()
          require("gitsigns").nav_hunk("next")
        end,
        desc = "Next Hunk",
      },
      {
        "<leader>ghp",
        function()
          require("gitsigns").nav_hunk("prev")
        end,
        desc = "Previous Hunk",
      },
      { "<leader>ghs", gitsigns_action("stage_hunk"), desc = "Stage Hunk" },
      { "<leader>ghr", gitsigns_action("reset_hunk"), desc = "Reset Hunk" },
      { "<leader>ghS", gitsigns_action("stage_buffer"), desc = "Stage Buffer" },
      { "<leader>ghR", gitsigns_action("reset_buffer"), desc = "Reset Buffer" },
      { "<leader>ghv", gitsigns_action("preview_hunk"), desc = "Preview Hunk" },
      {
        "<leader>ghb",
        function()
          require("gitsigns").blame_line({ full = true })
        end,
        desc = "Blame Line",
      },
      { "<leader>ghd", gitsigns_action("diffthis"), desc = "Diff This" },
      { "<leader>ght", group = "+toggle" },
      { "<leader>ghtb", gitsigns_action("toggle_current_line_blame"), desc = "Toggle Blame" },
      { "<leader>ghtw", gitsigns_action("toggle_word_diff"), desc = "Toggle Word Diff" },
      { "<leader>ghts", gitsigns_action("toggle_signs"), desc = "Toggle Signs" },
      { "<leader>gy", group = "+yank" },
      {
        "<leader>gyy",
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
          vim.notify("Git link copied", vim.log.levels.INFO)
        end,
        desc = "Copy Git Link",
        mode = { "n", "v" },
      },
      {
        "<leader>gyo",
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
        desc = "Open Git Link",
        mode = { "n", "v" },
      },
      { "<leader>gx", group = "+conflicts" },
      { "<leader>gxn", ":GitConflictNextConflict<CR>", desc = "Next Conflict" },
      { "<leader>gxp", ":GitConflictPrevConflict<CR>", desc = "Previous Conflict" },
      { "<leader>gxo", ":GitConflictChooseOurs<CR>", desc = "Choose Ours" },
      { "<leader>gxt", ":GitConflictChooseTheirs<CR>", desc = "Choose Theirs" },
      { "<leader>gxb", ":GitConflictChooseBoth<CR>", desc = "Choose Both" },
      { "<leader>gx0", ":GitConflictChooseNone<CR>", desc = "Choose None" },
      { "<leader>gxl", ":GitConflictListQf<CR>", desc = "List Conflicts" },
      { "<leader>gxr", ":GitConflictRefresh<CR>", desc = "Refresh Conflicts" },
      { "<leader>go", group = "+github" },
      { "<leader>gop", "<cmd>GHOpenPR<CR>", desc = "Open PR" },
      { "<leader>goi", "<cmd>GHOpenIssue<CR>", desc = "Open Issue" },
      { "<leader>goP", "<cmd>GHSearchPRs<CR>", desc = "Search PRs" },
      { "<leader>goI", "<cmd>GHSearchIssues<CR>", desc = "Search Issues" },
      { "<leader>got", "<cmd>GHToggleThreads<CR>", desc = "Toggle Threads" },

      -- Tests
      { "<leader>t", group = "+tests" },
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest",
      },
      {
        "<leader>tf",
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
        desc = "Stop Tests",
      },

      -- Run & Tasks
      { "<leader>r", group = "+run" },
      {
        "<leader>rr",
        function()
          local ok, overseer = pcall(require, "overseer")
          if ok then
            overseer.run_template()
          end
        end,
        desc = "Run Task Template",
      },
      {
        "<leader>rl",
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
        desc = "Restart Last Task",
      },
      {
        "<leader>ro",
        function()
          local ok, overseer = pcall(require, "overseer")
          if ok then
            overseer.toggle({ enter = false })
          end
        end,
        desc = "Toggle Task List",
      },

      -- Treesitter
      { "<leader>S", group = "+swap" },

      -- Debug (groups only; actual DAP bindings live in plugin config)
      { "<leader>d", group = "+debug" },
      { "<leader>db", group = "+breakpoints" },
      { "<leader>dv", group = "+inspect" },

      -- Options & UI
      { "<leader>o", group = "+options" },
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
        desc = "Toggle Indent Guides",
      },
      {
        "<leader>oz",
        function()
          local ok, ufo = pcall(require, "ufo")
          if ok then
            ufo.closeAllFolds()
          end
        end,
        desc = "Close All Folds",
      },
      {
        "<leader>oZ",
         function()
          local ok, ufo = pcall(require, "ufo")
          if ok then
            ufo.openAllFolds()
          end
        end,
        desc = "Open All Folds",
      },
      {
        "<leader>op",
        function()
          local ok, ufo = pcall(require, "ufo")
          if ok then
            ufo.peekFoldedLinesUnderCursor()
          end
        end,
        desc = "Peek Fold",
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
        desc = "Toggle Numbers",
      },
      { "<leader>ow", ":set wrap!<CR>", desc = "Toggle Wrap" },
      { "<leader>os", ":set spell!<CR>", desc = "Toggle Spell" },
      { "<leader>oc", ":set cursorline!<CR>", desc = "Toggle Cursorline" },
      { "<leader>oC", ":set cursorcolumn!<CR>", desc = "Toggle Cursorcolumn" },
      { "<leader>of", ":FormatToggle<CR>", desc = "Toggle Format on Save" },
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
        desc = "Toggle Dim",
      },

      -- Undo & Clipboard
      { "<leader>u", group = "+undo" },
      {
        "<leader>uu",
        function()
          snacks.picker.undo()
        end,
        desc = "Undo History",
      },
      {
        "<leader>ur",
        function()
          snacks.picker.redo()
        end,
        desc = "Redo History",
      },

      -- Yank history lives with registers
      {
        "<leader>uy",
        function()
          local ok, yanky_snacks = pcall(require, "yanky.sources.snacks")
          if ok then
            yanky_snacks.pick()
          else
            vim.notify("Snacks picker is unavailable", vim.log.levels.WARN)
          end
        end,
        desc = "Yank History",
      },

      -- Notes & Scratch
      { "<leader>N", group = "+notes" },
      { "<leader>.", function () open_scratch() end, desc = "Scratch" },
      { "<leader>No", function () open_scratch() end, desc = "Open Scratch" },
      { "<leader>Nf", function() snacks.scratch.select() end, desc = "Find Scratch" },
      {
        "<leader>Nn",
        function()
          vim.ui.input({ prompt = "Scratch name: " }, function(name)
            if name and name ~= "" then
              snacks.scratch({ name = name })
            end
          end)
        end,
        desc = "New Scratch",
      },

      -- Help & Discovery
      { "<leader>oh", group = "+help" },
      {
        "<leader>ohh",
        function()
          snacks.picker.help()
        end,
        desc = "Search Help",
      },
      {
        "<leader>ohc",
        function()
          snacks.picker.commands()
        end,
        desc = "Search Commands",
      },
      {
        "<leader>ohk",
        function()
          snacks.picker.keymaps()
        end,
        desc = "Search Keymaps",
      },
      {
        "<leader>ohm",
        function()
          snacks.picker.marks()
        end,
        desc = "Search Marks",
      },

      -- Mason 
      { "<leader>om", group = "+mason" },
      { "<leader>omm", "<cmd>Mason<CR>", desc = "Mason UI" },
      { "<leader>omi", "<cmd>MasonToolsInstall<CR>", desc = "Install Tools" },

      -- Quit
      { "<leader>q", group = "+quit" },
      { "<leader>qq", ":qa<CR>", desc = "Quit All" },
      { "<leader>qQ", ":qa!<CR>", desc = "Force Quit All" },

      -- Exernal Terminal
      {
        "<F2>",
        function()
          snacks.terminal.toggle()
        end,
        desc = "Toggle Terminal",
        mode = { "n", "t" },
      },

      -- Spelling helpers
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
    }

    if vim.g.neovide then
      table.insert(mappings, {
        "<leader>o+",
        function()
          vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
        end,
        desc = "Scale Up",
      })

      table.insert(mappings, {
        "<leader>o-",
        function()
          vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
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
  end

  vim.keymap.set("i", "jj", "<Esc>", { desc = "Escape" })
  vim.keymap.set("i", "оо", "<Esc>", { desc = "Escape" })

  vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Buffer -> Next", silent = true })
  vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Buffer -> Previous", silent = true })

  vim.keymap.set("n", "L", ":bnext<CR>", { desc = "Buffer -> Next", silent = true })
  vim.keymap.set("n", "H", ":bprevious<CR>", { desc = "Buffer -> Previous", silent = true })
end

return M
