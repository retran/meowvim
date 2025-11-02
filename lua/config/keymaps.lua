-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/config/keymaps.lua
-- @brief: Neovim key mapping configurations and shortcuts.

local M = {}

local snacks = require("snacks")
local toggles = require("utils.toggles")

local ICON_EXACT = {
  ["Add Word to Dictionary"] = "󰓆",
  ["Add Workspace Folder"] = "",
  ["Apply Code Action"] = "󰆳",
  ["Browse Files"] = "",
  ["Browse Git Branches"] = "",
  ["Browse Git Status"] = "󰊢",
  ["Browse Symbols"] = "󰌗",
  ["Choose Both"] = "󰡖",
  ["Choose None"] = "󰚝",
  ["Choose Ours"] = "󰅂",
  ["Choose Theirs"] = "󰅙",
  ["Close All Folds"] = "󰂔",
  ["Close Diff View"] = "󰅖",
  ["Close Other Windows"] = "󰅖",
  ["Close Window"] = "󰅖",
  ["Commit Changes"] = "󰜘",
  ["Compare Current Buffer"] = "",
  ["Copy Git Link"] = "",
  ["Create Buffer"] = "",
  ["Create File"] = "",
  ["Create Scratch"] = "󰎚",
  ["Debug Nearest Test"] = "",
  ["Decrease Height"] = "",
  ["Decrease Width"] = "",
  ["Delete All Buffers"] = "󰆴",
  ["Delete Buffer"] = "󰆴",
  ["Delete Other Buffers"] = "󰆴",
  ["Equalize Windows"] = "󰞷",
  ["Exit Insert Mode"] = "󱊷",
  ["Find File"] = "",
  ["Find Git File"] = "",
  ["Find Scratch"] = "󰍉",
  ["Focus Left Window"] = "",
  ["Focus Lower Window"] = "",
  ["Focus Right Window"] = "",
  ["Focus Upper Window"] = "",
  ["Force Delete Buffer"] = "󰗼",
  ["Force Quit All"] = "󰅚",
  ["Format Buffer"] = "󰉵",
  ["Go To Declaration"] = "󰜢",
  ["Go To Definitions"] = "󰜢",
  ["Go To Document Symbols"] = "󰌗",
  ["Go To Implementations"] = "󰅩",
  ["Go To Next Buffer"] = "",
  ["Go To Next Conflict"] = "",
  ["Go To Next Diagnostic"] = "",
  ["Go To Next Hunk"] = "",
  ["Go To Previous Buffer"] = "",
  ["Go To Previous Conflict"] = "",
  ["Go To Previous Diagnostic"] = "",
  ["Go To Previous Hunk"] = "",
  ["Go To References"] = "󰈈",
  ["Go To Type Definitions"] = "󰜢",
  ["Go To Workspace Symbols"] = "󰙅",
  ["Increase Height"] = "",
  ["Increase Width"] = "",
  ["Install Tools"] = "󰚰",
  ["Jump"] = "",
  ["Jump to Match"] = "",
  ["Jump to Match in All Windows"] = "",
  ["Jump to Remote Target"] = "󰈣",
  ["Jump to Treesitter Node"] = "󰉖",
  ["List Buffers"] = "󰕘",
  ["List Conflicts"] = "󰦻",
  ["List TODO Comments"] = "󰄴",
  ["List Workspace Folders"] = "󰕘",
  ["Move Window Far Left"] = "",
  ["Move Window Far Right"] = "",
  ["Move Window to Bottom"] = "",
  ["Move Window to Top"] = "",
  ["Open All Folds"] = "󰂓",
  ["Open Diff View"] = "󰈈",
  ["Open Git Link"] = "󰴂",
  ["Open Issue"] = "󰞋",
  ["Open Latest Scratch"] = "󰎚",
  ["Open Location List"] = "󰉹",
  ["Open Pull Request"] = "",
  ["Open Quickfix List"] = "󰁨",
  ["Scratch"] = "󰎚",
  ["Open Tool Manager"] = "",
  ["Peek Fold"] = "󰙵",
  ["Preview Hunk"] = "󰈈",
  ["Pull Changes"] = "󰳁",
  ["Push Changes"] = "󰳂",
  ["Quit All"] = "󰅚",
  ["Refresh CodeLens"] = "",
  ["Refresh Conflicts"] = "",
  ["Remove Word from Dictionary"] = "󰹙",
  ["Remove Workspace Folder"] = "",
  ["Rename Buffer"] = "󰑕",
  ["Rename Symbol"] = "󰑕",
  ["Reset Buffer"] = "󰜺",
  ["Reset Hunk"] = "󰜺",
  ["Restart Last Task"] = "",
  ["Restore Last Session"] = "󰁯",
  ["Restore Session"] = "󰁯",
  ["Run CodeLens"] = "󰈈",
  ["Run File Tests"] = "󰙨",
  ["Run Nearest Test"] = "󰙨",
  ["Run Task Template"] = "",
  ["Run Test Suite"] = "󰙨",
  ["Save All Files"] = "󰆓",
  ["Save File"] = "󰆓",
  ["Scale Down"] = "",
  ["Scale Up"] = "",
  ["Search Commands"] = "󰘳",
  ["Search Git Repository"] = "",
  ["Search Help"] = "󰋖",
  ["Search Issues"] = "󰞋",
  ["Search Keymaps"] = "󰌌",
  ["Search Marks"] = "󰧀",
  ["Search Open Buffers"] = "",
  ["Search Project Text"] = "",
  ["Search Pull Requests"] = "",
  ["Search and Replace Project"] = "󰛔",
  ["Show Buffer Diagnostics"] = "󰒡",
  ["Show Call Hierarchy (Callees)"] = "󰭻",
  ["Show Call Hierarchy (Callers)"] = "󰭻",
  ["Show File History"] = "󰋘",
  ["Show Line Blame"] = "󰆘",
  ["Show Line Diagnostics"] = "󰒡",
  ["Show Project Diagnostics"] = "󰒡",
  ["Show Recent Files"] = "󰋜",
  ["Show Redo History"] = "󰑖",
  ["Show Repository History"] = "󰋘",
  ["Show Test Output"] = "󰙨",
  ["Show Type Hierarchy (Subtypes)"] = "󰓼",
  ["Show Type Hierarchy (Supertypes)"] = "󰓼",
  ["Show Undo History"] = "󰦓",
  ["Show Yank History"] = "",
  ["Split Window Horizontally"] = "󰤼",
  ["Split Window Vertically"] = "󰤻",
  ["Stage Buffer"] = "󰄬",
  ["Stage Hunk"] = "󰄬",
  ["Stop Session Saving"] = "",
  ["Stop Tests"] = "",
  ["Switch Project"] = "󰙅",
  ["Toggle Blame"] = "󰆘",
  ["Toggle Cursorcolumn"] = "󰄮",
  ["Toggle Cursorline"] = "󰄯",
  ["Toggle Dim Background"] = "󰓃",
  ["Toggle File Explorer"] = "󰙅",
  ["Toggle Format on Save"] = "󰉵",
  ["Toggle Fullscreen"] = "󰍹",
  ["Toggle Auto Save"] = "󰆓",
  ["Toggle Indent Guides"] = "󰉢",
  ["Toggle Numbers"] = "󰎠",
  ["Toggle Signs"] = "󰨙",
  ["Toggle Spell"] = "󰓆",
  ["Toggle Task List"] = "󰑐",
  ["Toggle Terminal"] = "",
  ["Toggle Test Summary"] = "󰙨",
  ["Toggle Threads"] = "󰓢",
  ["Toggle Word Diff"] = "󰹭",
  ["Toggle Wrap"] = "󰖶",
  ["View File Git Log"] = "󰋘",
  ["View Git Log"] = "󰋘",
  ["View Git Status"] = "󰊢",
}

local ICON_PATTERNS = {
  { pattern = "toggle", icon = "󰨙" },
  { pattern = "search", icon = "" },
  { pattern = "find", icon = "" },
  { pattern = "browse", icon = "" },
  { pattern = "list", icon = "󰕘" },
  { pattern = "show", icon = "󰋼" },
  { pattern = "open", icon = "" },
  { pattern = "close", icon = "󰅖" },
  { pattern = "create", icon = "" },
  { pattern = "new", icon = "" },
  { pattern = "save", icon = "󰆓" },
  { pattern = "restore", icon = "󰁯" },
  { pattern = "run", icon = "" },
  { pattern = "stop", icon = "" },
  { pattern = "debug", icon = "" },
  { pattern = "jump", icon = "󰜈" },
  { pattern = "go to", icon = "󰜢" },
  { pattern = "format", icon = "󰉵" },
  { pattern = "rename", icon = "󰑕" },
  { pattern = "reset", icon = "󰜺" },
  { pattern = "stage", icon = "󰄬" },
  { pattern = "pull", icon = "󰳁" },
  { pattern = "push", icon = "󰳂" },
  { pattern = "commit", icon = "󰜘" },
  { pattern = "diff", icon = "" },
}

local DEFAULT_ICON = "󰛡"

local function icon_for(desc)
  if not desc then
    return nil
  end
  local exact = ICON_EXACT[desc]
  if exact then
    return exact
  end
  local lowered = desc:lower()
  for _, rule in ipairs(ICON_PATTERNS) do
    if lowered:find(rule.pattern, 1, true) then
      return rule.icon
    end
  end
  return DEFAULT_ICON
end

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

local function is_single_leader(lhs)
  if type(lhs) ~= "string" then
    return false
  end

  if not lhs:find("^<leader>") then
    return false
  end

  local rest = lhs:gsub("^<leader>", "", 1)
  if rest == "" then
    return false
  end

  if rest:match("^<[^>]+>$") then
    return true
  end

  return rest:len() == 1
end

function M.setup()
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    local mappings = {
      -- Files
      { "<leader>f", group = "Files", icon = "󰈞" },
      {
        "<leader>ff",
        function()
          snacks.picker.smart()
        end,
        desc = "Find File",
      },
      {
        "<leader>fF",
        function()
          snacks.picker.files()
        end,
        desc = "Browse Files",
      },
      {
        "<leader>fg",
        function()
          snacks.picker.git_files()
        end,
        desc = "Find Git File",
      },
      {
        "<leader>fr",
        function()
          snacks.picker.recent()
        end,
        desc = "Show Recent Files",
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
        desc = "Create File",
      },
      {
        "<leader>fe",
        function()
          snacks.explorer()
        end,
        desc = "Toggle File Explorer",
      },
      {
        "<leader>fp",
        function()
          snacks.picker.projects()
        end,
        desc = "Switch Project",
      },
      { "<leader>fs", ":w<CR>", desc = "Save File" },
      { "<leader>fS", ":wa<CR>", desc = "Save All Files" },

      -- Buffers
      { "<leader>b", group = "Buffers", icon = "󰮍" },
      {
        "<leader>bb",
        function()
          snacks.picker.buffers()
        end,
        desc = "List Buffers",
      },
      { "<leader>bn", ":new<CR>", desc = "Create Buffer" },
      { "<leader>bp", ":bprevious<CR>", desc = "Go To Previous Buffer" },
      { "<leader>bf", ":bnext<CR>", desc = "Go To Next Buffer" },
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
      { "<leader>w", group = "Windows", icon = "" },
      { "<leader>wh", "<C-w>h", desc = "Focus Left Window" },
      { "<leader>wj", "<C-w>j", desc = "Focus Lower Window" },
      { "<leader>wk", "<C-w>k", desc = "Focus Upper Window" },
      { "<leader>wl", "<C-w>l", desc = "Focus Right Window" },
      { "<leader>ws", "<C-w>s", desc = "Split Window Horizontally" },
      { "<leader>wv", "<C-w>v", desc = "Split Window Vertically" },
      { "<leader>wc", "<C-w>c", desc = "Close Window" },
      { "<leader>wo", "<C-w>o", desc = "Close Other Windows" },
      { "<leader>w=", "<C-w>=", desc = "Equalize Windows" },
      { "<leader>w>", "<C-w>>", desc = "Increase Width" },
      { "<leader>w<", "<C-w><", desc = "Decrease Width" },
      { "<leader>w+", "<C-w>+", desc = "Increase Height" },
      { "<leader>w-", "<C-w>-", desc = "Decrease Height" },
      { "<leader>wH", "<C-w>H", desc = "Move Window Far Left" },
      { "<leader>wL", "<C-w>L", desc = "Move Window Far Right" },
      { "<leader>wK", "<C-w>K", desc = "Move Window to Top" },
      { "<leader>wJ", "<C-w>J", desc = "Move Window to Bottom" },

      -- Search & Navigaton
      { "<leader>s", group = "Search", icon = "" },
      {
        "<leader>s/",
        function()
          snacks.picker.grep()
        end,
        desc = "Search Project Text",
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
        desc = "Search Git Repository",
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
        desc = "Search and Replace Project",
        mode = { "n", "x" },
      },
      { "<leader>st", "<cmd>TodoTrouble<CR>", desc = "List TODO Comments" },

      -- Flash Jump
      { "<leader><space>", flash_action("jump", false), desc = "Jump", mode = { "n", "x", "o" } },
      { "<leader>j", group = "Jump To", icon = "󰜈" },
      { "<leader>jj", flash_action("jump", false), desc = "Jump to Match", mode = { "n", "x", "o" } },
      { "<leader>jt", flash_action("treesitter"), desc = "Jump to Treesitter Node", mode = { "n", "x", "o" } },
      { "<leader>ja", flash_action("jump", true), desc = "Jump to Match in All Windows", mode = { "n", "x", "o" } },
      { "<leader>jm", flash_action("remote"), desc = "Jump to Remote Target", mode = { "n", "x", "o" } },

      -- Navigation
      { "<leader>n", group = "Go To", icon = "󰹸" },
      { "<leader>nd", glance_action("definitions"), desc = "Go To Definition" },
      {
        "<leader>nD",
        function()
          snacks.picker.lsp_declarations()
        end,
        desc = "Go To Declaration",
      },
      { "<leader>nr", glance_action("references"), desc = "Go To Reference" },
      { "<leader>ni", glance_action("implementations"), desc = "Go To Implementation" },
      { "<leader>nt", glance_action("type_definitions"), desc = "Go To Type Definition" },
      {
        "<leader>ns",
        function()
          snacks.picker.lsp_symbols()
        end,
        desc = "Go To Document Symbol",
      },
      {
        "<leader>nw",
        function()
          snacks.picker.lsp_workspace_symbols()
        end,
        desc = "Go To Workspace Symbol",
      },
      {
        "<leader>nh",
        function()
          require("meow.yarn").open_tree("type_hierarchy", "subtypes")
        end,
        desc = "Show Type Hierarchy (Subtypes)",
      },
      {
        "<leader>nH",
        function()
          require("meow.yarn").open_tree("type_hierarchy", "supertypes")
        end,
        desc = "Show Type Hierarchy (Supertypes)",
      },
      {
        "<leader>nc",
        function()
          require("meow.yarn").open_tree("call_hierarchy", "callers")
        end,
        desc = "Show Call Hierarchy (Callers)",
      },
      {
        "<leader>nC",
        function()
          require("meow.yarn").open_tree("call_hierarchy", "callees")
        end,
        desc = "Show Call Hierarchy (Callees)",
      },

      -- Code Intelligence
      { "<leader>c", group = "Code", icon = "󰅩" },
      { "<leader>cd", group = "Diagnostics", icon = "󰒡" },
      { "<leader>cda", trouble_action("diagnostics"), desc = "Show Project Diagnostics" },
      { "<leader>cdb", trouble_action("diagnostics", { filter = { buf = 0 } }), desc = "Show Buffer Diagnostics" },
      { "<leader>cdq", trouble_action("quickfix"), desc = "Open Quickfix List" },
      { "<leader>cdl", trouble_action("loclist"), desc = "Open Location List" },
      { "<leader>cds", trouble_action("symbols", { focus = false }), desc = "Browse Symbols" },
      { "<leader>cdh", vim.diagnostic.open_float, desc = "Show Line Diagnostics" },
      { "]d", vim.diagnostic.goto_next, desc = "Go To Next Diagnostic", mode = "n" },
      { "[d", vim.diagnostic.goto_prev, desc = "Go To Previous Diagnostic", mode = "n" },
      { "<leader>cc", vim.lsp.buf.code_action, desc = "Apply Code Action", mode = { "n", "v" } },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename Symbol" },
      { "<leader>cl", vim.lsp.codelens.run, desc = "Run CodeLens" },
      {
        "<leader>co",
        function()
          local ft = vim.bo.filetype
          if ft ~= "typescript" and ft ~= "typescriptreact" and ft ~= "javascript" and ft ~= "javascriptreact" then
            vim.notify("Organize Imports is available in TypeScript and JavaScript buffers", vim.log.levels.WARN)
            return
          end
          local ok = pcall(vim.cmd.LspOrganize)
          if not ok then
            vim.notify("LspOrganize command is unavailable (tsserver not attached)", vim.log.levels.WARN)
          end
        end,
        desc = "Organize Imports",
      },
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
        desc = "Refresh CodeLens",
      },

      -- Git & VCS
      { "<leader>g", group = "Git", icon = "󰊢" },
      { "<leader>gs", group = "Status", icon = "󰓫" },
      {
        "<leader>gss",
        function()
          local ok, neogit = pcall(require, "neogit")
          if ok then
            neogit.open({ kind = "replace" })
          end
        end,
        desc = "View Git Status",
      },
      {
        "<leader>gsp",
        function()
          snacks.picker.git_status()
        end,
        desc = "Browse Git Status",
      },
      { "<leader>gc", group = "Changes", icon = "󰦕" },
      { "<leader>gcc", "<cmd>Neogit commit<CR>", desc = "Commit Changes" },
      { "<leader>gcp", "<cmd>Neogit pull<CR>", desc = "Pull Changes" },
      { "<leader>gcP", "<cmd>Neogit push<CR>", desc = "Push Changes" },
      {
        "<leader>gcb",
        function()
          snacks.picker.git_branches()
        end,
        desc = "Browse Git Branches",
      },
      {
        "<leader>gcl",
        function()
          snacks.picker.git_log()
        end,
        desc = "View Git Log",
      },
      {
        "<leader>gcL",
        function()
          snacks.picker.git_log_file()
        end,
        desc = "View File Git Log",
      },
      { "<leader>gd", group = "Diff", icon = "󰩫" },
      { "<leader>gdo", ":DiffviewOpen<CR>", desc = "Open Diff View" },
      { "<leader>gdc", ":DiffviewClose<CR>", desc = "Close Diff View" },
      { "<leader>gdf", ":DiffviewFileHistory %<CR>", desc = "Show File History" },
      { "<leader>gdF", ":DiffviewFileHistory<CR>", desc = "Show Repository History" },
      { "<leader>gh", group = "Hunks", icon = "󰘬" },
      {
        "<leader>ghn",
        function()
          require("gitsigns").nav_hunk("next")
        end,
        desc = "Go To Next Hunk",
      },
      {
        "<leader>ghp",
        function()
          require("gitsigns").nav_hunk("prev")
        end,
        desc = "Go To Previous Hunk",
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
        desc = "Show Line Blame",
      },
      { "<leader>ghd", gitsigns_action("diffthis"), desc = "Compare Current Buffer" },
      { "<leader>ght", group = "Toggle", icon = "󰨙" },
      { "<leader>ghtb", gitsigns_action("toggle_current_line_blame"), desc = "Toggle Blame" },
      { "<leader>ghtw", gitsigns_action("toggle_word_diff"), desc = "Toggle Word Diff" },
      { "<leader>ghts", gitsigns_action("toggle_signs"), desc = "Toggle Signs" },
      { "<leader>gy", group = "Yank", icon = "" },
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
      { "<leader>gx", group = "Conflicts", icon = "󰦻" },
      { "<leader>gxn", ":GitConflictNextConflict<CR>", desc = "Go To Next Conflict" },
      { "<leader>gxp", ":GitConflictPrevConflict<CR>", desc = "Go To Previous Conflict" },
      { "<leader>gxo", ":GitConflictChooseOurs<CR>", desc = "Choose Ours" },
      { "<leader>gxt", ":GitConflictChooseTheirs<CR>", desc = "Choose Theirs" },
      { "<leader>gxb", ":GitConflictChooseBoth<CR>", desc = "Choose Both" },
      { "<leader>gx0", ":GitConflictChooseNone<CR>", desc = "Choose None" },
      { "<leader>gxl", ":GitConflictListQf<CR>", desc = "List Conflicts" },
      { "<leader>gxr", ":GitConflictRefresh<CR>", desc = "Refresh Conflicts" },
      { "<leader>go", group = "GitHub", icon = "" },
      { "<leader>gop", "<cmd>GHOpenPR<CR>", desc = "Open Pull Request" },
      { "<leader>goi", "<cmd>GHOpenIssue<CR>", desc = "Open Issue" },
      { "<leader>goP", "<cmd>GHSearchPRs<CR>", desc = "Search Pull Requests" },
      { "<leader>goI", "<cmd>GHSearchIssues<CR>", desc = "Search Issues" },
      { "<leader>got", "<cmd>GHToggleThreads<CR>", desc = "Toggle Threads" },

      -- Tests
      { "<leader>t", group = "Tests", icon = "󰙨" },
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest Test",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run File Tests",
      },
      {
        "<leader>ts",
        function()
          require("neotest").run.run_suite()
        end,
        desc = "Run Test Suite",
      },
      {
        "<leader>tS",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Test Summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true })
        end,
        desc = "Show Test Output",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug Nearest Test",
      },
      {
        "<leader>tx",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop Tests",
      },

      -- Run & Tasks
      { "<leader>r", group = "Run", icon = "" },
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
      { "<leader>S", group = "Swap", icon = "" },

      -- Debug (groups only; actual DAP bindings live in plugin config)
      { "<leader>d", group = "Debug", icon = "" },
      { "<leader>db", group = "Breakpoints", icon = "" },
      { "<leader>dv", group = "Inspect", icon = "󰈈" },

      -- Options & UI
      { "<leader>o", group = "Options", icon = "" },
      { "<leader>oW", group = "Workspace", icon = "󰙅" },
      { "<leader>oWa", vim.lsp.buf.add_workspace_folder, desc = "Add Workspace Folder" },
      { "<leader>oWR", vim.lsp.buf.remove_workspace_folder, desc = "Remove Workspace Folder" },
      { "<leader>oWL", vim.lsp.buf.list_workspace_folders, desc = "List Workspace Folders" },
      { "<leader>oS", group = "Sessions", icon = "󰦀" },
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
      {
        "<leader>og",
        function()
          local ok, indentscope = pcall(require, "mini.indentscope")
          if not ok then
            return
          end

          vim.g.miniindentscope_disable = not vim.g.miniindentscope_disable
          toggles.update("miniindentscope_disable")
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
      { "<leader>oa", ":AutoSaveToggle<CR>", desc = "Toggle Auto Save" },
      { "<leader>oF", ":FormatToggle<CR>", desc = "Toggle Format on Save" },
      {
        "<leader>od",
        function()
          vim.g.snacks_dim = not vim.g.snacks_dim
          toggles.update("snacks_dim")
          if vim.g.snacks_dim then
            snacks.dim.enable()
          else
            snacks.dim.disable()
          end
        end,
        desc = "Toggle Dim Background",
      },

      -- Undo & Clipboard
      { "<leader>u", group = "Undo", icon = "" },
      {
        "<leader>uu",
        function()
          snacks.picker.undo()
        end,
        desc = "Show Undo History",
      },
      {
        "<leader>ur",
        function()
          snacks.picker.redo()
        end,
        desc = "Show Redo History",
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
        desc = "Show Yank History",
      },

      -- Notes & Scratch
      { "<leader>N", group = "Notes", icon = "󰍔" },
      {
        "<leader>.",
        function()
          open_scratch()
        end,
        desc = "Scratch",
      },
      {
        "<leader>No",
        function()
          open_scratch()
        end,
        desc = "Open Latest Scratch",
      },
      {
        "<leader>Nf",
        function()
          snacks.scratch.select()
        end,
        desc = "Find Scratch",
      },
      {
        "<leader>Nn",
        function()
          vim.ui.input({ prompt = "Scratch name: " }, function(name)
            if name and name ~= "" then
              snacks.scratch({ name = name })
            end
          end)
        end,
        desc = "Create Scratch",
      },

      -- Help & Discovery
      { "<leader>oh", group = "Help", icon = "󰋖" },
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
      { "<leader>om", group = "Tools", icon = "" },
      { "<leader>omm", "<cmd>Mason<CR>", desc = "Open Tool Manager" },
      { "<leader>omi", "<cmd>MasonToolsInstall<CR>", desc = "Install Tools" },

      -- Quit
      { "<leader>q", group = "Quit", icon = "󰅚" },
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
        desc = "Add Word to Dictionary",
      },
      {
        "zw",
        function()
          vim.cmd("silent normal! zw")
          vim.notify("Word marked incorrect", vim.log.levels.INFO)
        end,
        desc = "Remove Word from Dictionary",
      },
    }

    if vim.g.neovide then
      toggles.ensure("neovide_scale_factor")
      toggles.ensure("neovide_fullscreen")

      table.insert(mappings, {
        "<leader>o+",
        function()
          vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
          toggles.update("neovide_scale_factor")
        end,
        desc = "Scale Up",
      })

      table.insert(mappings, {
        "<leader>o-",
        function()
          vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
          toggles.update("neovide_scale_factor")
        end,
        desc = "Scale Down",
      })

      table.insert(mappings, {
        "<leader>of",
        function()
          vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
          toggles.update("neovide_fullscreen")
        end,
        desc = "Toggle Fullscreen",
      })
    end

    local top_level_actions, other_mappings = {}, {}
    for _, mapping in ipairs(mappings) do
      local lhs = mapping[1]
      if mapping.desc and not mapping.group and lhs and is_single_leader(lhs) then
        table.insert(top_level_actions, mapping)
      else
        table.insert(other_mappings, mapping)
      end
    end

    local ordered_mappings = {}
    for _, mapping in ipairs(top_level_actions) do
      table.insert(ordered_mappings, mapping)
    end
    for _, mapping in ipairs(other_mappings) do
      table.insert(ordered_mappings, mapping)
    end

    for _, mapping in ipairs(ordered_mappings) do
      if mapping.desc and not mapping.icon then
        mapping.icon = icon_for(mapping.desc)
      end
      local mode = mapping.mode or "n"
      mapping.mode = nil
      wk.add({
        { mode = mode, mapping },
      })
    end
  end

  vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit Insert Mode" })
  vim.keymap.set("i", "оо", "<Esc>", { desc = "Exit Insert Mode" })

  vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Go To Next Buffer", silent = true })
  vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Go To Previous Buffer", silent = true })

  vim.keymap.set("n", "L", ":bnext<CR>", { desc = "Go To Next Buffer", silent = true })
  vim.keymap.set("n", "H", ":bprevious<CR>", { desc = "Go To Previous Buffer", silent = true })
end

return M
