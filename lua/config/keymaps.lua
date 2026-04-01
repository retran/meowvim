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
  ["All Windows"] = "",
  ["Remote Target"] = "󰈣",
  ["Treesitter Node"] = "󰉖",
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
  ["Remove from Dictionary"] = "󰹙",
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
  ["Type Hierarchy (Super)"] = "󰓼",
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
  ["Toggle Terminal"] = "",
  ["Toggle Test Summary"] = "󰙨",
  ["Toggle Threads"] = "󰓢",
  ["Toggle Word Diff"] = "󰹭",
  ["Toggle Wrap"] = "󰖶",
  ["Toggle Signcolumn"] = "󰐕",
  ["Toggle List"] = "󰐡",
  ["Toggle Search Highlight"] = "",
  ["Toggle Mouse"] = "󰍽",
  ["Toggle Foldenable"] = "󰴋",
  ["Toggle Diagnostics"] = "󰒡",
  ["Toggle Inlay Hints"] = "󰏪",
  ["Toggle Conceal"] = "󰈈",
  ["View File Git Log"] = "󰋘",
  ["View Git Log"] = "󰋘",
  ["View Git Status"] = "󰊢",
  ["Copy File Reference"] = "󰆒",
  ["Copy Line Reference"] = "󰆒",
  -- Review
  ["Add Issue"] = "󰅙",
  ["Add Suggestion"] = "󰌹",
  ["Add Note"] = "󰏫",
  ["Add Praise"] = "󰙵",
  ["Add Question"] = "󰋖",
  ["Add Insight"] = "",
  ["Add Comment"] = "󰆈",
  ["Delete Comment"] = "󰆴",
  ["View Comment"] = "󰋼",
  ["Export Review"] = "󰈈",
  ["Clear Review"] = "󰜺",
  ["Review Summary"] = "󰒡",
  ["Load Review"] = "󰁯",
  ["Goto Real File"] = "󰜢",
  ["Next Review Comment"] = "",
  ["Previous Review Comment"] = "",
  ["Cycle Next Type"] = "",
  ["Cycle Prev Type"] = "",
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
        flash.jump({
          search = { max_length = 2 },
          multi_window = multi_window or false,
        })
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

local function qr_action(fn_name)
  return function()
    local qr = safe_require("quickfix-review")
    if qr then
      qr[fn_name]()
    end
  end
end

local function qr_add(comment_type)
  return function()
    local qr = safe_require("quickfix-review")
    if not qr then
      return
    end
    local mode = vim.fn.mode()
    if mode == "v" or mode == "V" or mode == "\22" then
      qr.add_comment_visual(comment_type)
    else
      qr.add_comment(comment_type)
    end
  end
end

local function qr_delete()
  local qr = safe_require("quickfix-review")
  if not qr then
    return
  end
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    qr.delete_comment_visual()
  else
    qr.delete_comment()
  end
end

-- Copy a file path or file:line reference to the system clipboard in the
-- format used by OpenCode / Claude (e.g. "@lua/plugins/copilot.lua:42").
-- Paths are relative to cwd so they stay short and portable.
local function copy_file_ref()
  local path = vim.fn.expand("%:.")
  if path == "" then
    vim.notify("No file in buffer", vim.log.levels.WARN)
    return
  end
  local ref = "@" .. path
  vim.fn.setreg("+", ref)
  vim.notify("Copied: " .. ref, vim.log.levels.INFO)
end

local function copy_line_ref()
  local path = vim.fn.expand("%:.")
  if path == "" then
    vim.notify("No file in buffer", vim.log.levels.WARN)
    return
  end
  local mode = vim.fn.mode()
  local ref
  if mode == "v" or mode == "V" or mode == "\22" then
    local s = vim.fn.line("v")
    local e = vim.fn.line(".")
    if s > e then
      s, e = e, s
    end
    ref = s == e and ("@" .. path .. ":" .. s) or ("@" .. path .. ":" .. s .. "-" .. e)
  else
    ref = "@" .. path .. ":" .. vim.fn.line(".")
  end
  vim.fn.setreg("+", ref)
  vim.notify("Copied: " .. ref, vim.log.levels.INFO)
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

            local stat = vim.uv.fs_stat(filepath)
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
      -- Tab operations
      { "<leader>wt", "<cmd>tabnew<CR>", desc = "New Tab" },
      { "<leader>wT", "<cmd>tabclose<CR>", desc = "Close Tab" },

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
        desc = "Search and Replace",
        mode = { "n", "x" },
      },
      { "<leader>st", "<cmd>TodoTrouble<CR>", desc = "List TODO Comments" },

      -- Flash Jump
      { "<leader><space>", flash_action("jump", false), desc = "Jump", mode = { "n", "x", "o" } },
      { "<leader>j", group = "Jump To", icon = "󰜈" },
      { "<leader>jt", flash_action("treesitter"), desc = "Treesitter Node", mode = { "n", "x", "o" } },
      { "<leader>ja", flash_action("jump", true), desc = "All Windows", mode = { "n", "x", "o" } },
      { "<leader>jm", flash_action("remote"), desc = "Remote Target", mode = { "n", "x", "o" } },

      -- Navigation
      { "<leader>n", group = "Navigate", icon = "󰹸" },
      { "<leader>nd", glance_action("definitions"), desc = "Navigate to Definition" },
      {
        "<leader>nD",
        function()
          snacks.picker.lsp_declarations()
        end,
        desc = "Declaration",
      },
      { "<leader>nr", glance_action("references"), desc = "Reference" },
      { "<leader>ni", glance_action("implementations"), desc = "Implementation" },
      { "<leader>nt", glance_action("type_definitions"), desc = "Type Definition" },
      {
        "<leader>ns",
        function()
          snacks.picker.lsp_symbols()
        end,
        desc = "Document Symbol",
      },
      {
        "<leader>nw",
        function()
          snacks.picker.lsp_workspace_symbols()
        end,
        desc = "Workspace Symbol",
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
        desc = "Type Hierarchy (Super)",
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

      -- Code
      { "<leader>c", group = "Code", icon = "󰅩" },
      { "<leader>cc", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename Symbol" },
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format Buffer",
      },
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
      -- Diagnostics
      { "<leader>cd", trouble_action("diagnostics"), desc = "Project Diagnostics" },
      { "<leader>cD", trouble_action("diagnostics", { filter = { buf = 0 } }), desc = "Buffer Diagnostics" },
      { "<leader>ch", vim.diagnostic.open_float, desc = "Line Diagnostics" },
      { "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic", mode = "n" },
      { "[d", vim.diagnostic.goto_prev, desc = "Previous Diagnostic", mode = "n" },
      { "]q", "<cmd>cnext<CR>", desc = "Next Quickfix Item", mode = "n" },
      { "[q", "<cmd>cprev<CR>", desc = "Previous Quickfix Item", mode = "n" },
      { "]l", "<cmd>lnext<CR>", desc = "Next Location List Item", mode = "n" },
      { "[l", "<cmd>lprev<CR>", desc = "Previous Location Item", mode = "n" },
      { "]b", "<cmd>bnext<CR>", desc = "Next Buffer", mode = "n" },
      { "[b", "<cmd>bprevious<CR>", desc = "Previous Buffer", mode = "n" },
      { "]t", "<cmd>tabnext<CR>", desc = "Next Tab", mode = "n" },
      { "[t", "<cmd>tabprevious<CR>", desc = "Previous Tab", mode = "n" },
      -- CodeLens & Symbols
      { "<leader>cq", trouble_action("quickfix"), desc = "Quickfix List" },
      { "<leader>cs", trouble_action("symbols", { focus = false }), desc = "Browse Symbols" },
      { "<leader>cl", vim.lsp.codelens.run, desc = "Run CodeLens" },
      {
        "<leader>cL",
        vim.lsp.codelens.refresh,
        desc = "Refresh CodeLens",
      },
      -- Rust Crates
      { "<leader>cR", group = "Rust Crates", icon = "" },
      {
        "<leader>cRt",
        function()
          require("crates").toggle()
        end,
        desc = "Toggle Crates",
      },
      {
        "<leader>cRr",
        function()
          require("crates").reload()
        end,
        desc = "Reload Crates",
      },
      {
        "<leader>cRu",
        function()
          require("crates").update_crate()
        end,
        desc = "Update Crate",
      },
      {
        "<leader>cRU",
        function()
          require("crates").update_all_crates()
        end,
        desc = "Update All Crates",
      },
      {
        "<leader>cRH",
        function()
          require("crates").open_homepage()
        end,
        desc = "Open Crate Homepage",
      },
      {
        "<leader>cRD",
        function()
          require("crates").open_documentation()
        end,
        desc = "Open Crate Documentation",
      },

      -- Git
      { "<leader>g", group = "Git", icon = "󰊢" },
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit Current File" },
      { "<leader>gl", "<cmd>LazyGit log<cr>", desc = "Git Log" },
      {
        "<leader>gb",
        function()
          snacks.git.blame_line()
        end,
        desc = "Git Blame Line",
      },
      {
        "<leader>gB",
        function()
          snacks.gitbrowse()
        end,
        desc = "Git Browse",
      },
      { "<leader>gC", "<cmd>Neogit commit<CR>", desc = "Commit" },
      { "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Pull" },
      { "<leader>gP", "<cmd>Neogit push<CR>", desc = "Push" },
      {
        "<leader>gw",
        function()
          snacks.picker.git_branches()
        end,
        desc = "Browse Branches",
      },
      -- Hunks
      { "<leader>gs", gitsigns_action("stage_hunk"), desc = "Stage Hunk" },
      { "<leader>gr", gitsigns_action("reset_hunk"), desc = "Reset Hunk" },
      { "<leader>gS", gitsigns_action("stage_buffer"), desc = "Stage Buffer" },
      { "<leader>gR", gitsigns_action("reset_buffer"), desc = "Reset Buffer" },
      { "<leader>gv", gitsigns_action("preview_hunk"), desc = "Preview Hunk" },
      { "<leader>gd", gitsigns_action("diffthis"), desc = "Diff Buffer" },
      -- Bracket motions
      {
        "]h",
        function()
          require("gitsigns").nav_hunk("next")
        end,
        desc = "Next Hunk",
      },
      {
        "[h",
        function()
          require("gitsigns").nav_hunk("prev")
        end,
        desc = "Previous Hunk",
      },
      -- CodeDiff
      { "<leader>gD", group = "Diff View", icon = "󰩫" },
      { "<leader>gDo", ":CodeDiff<CR>", desc = "Open Diff Explorer" },
      { "<leader>gDf", ":CodeDiff file HEAD<CR>", desc = "Diff File vs HEAD" },
      { "<leader>gDh", ":CodeDiff history<CR>", desc = "Show File History" },
      -- Git links
      {
        "<leader>gy",
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
        "<leader>gY",
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
        desc = "Open Git Link in Browser",
        mode = { "n", "v" },
      },
      -- Bracket motions
      {
        "]x",
        ":GitConflictNextConflict<CR>",
        desc = "Next Conflict",
      },
      {
        "[x",
        ":GitConflictPrevConflict<CR>",
        desc = "Previous Conflict",
      },
      -- Conflicts
      { "<leader>go", ":GitConflictChooseOurs<CR>", desc = "Choose Ours" },
      { "<leader>gt", ":GitConflictChooseTheirs<CR>", desc = "Choose Theirs" },
      { "<leader>gx", group = "Conflicts", icon = "󰦻" },
      { "<leader>gxb", ":GitConflictChooseBoth<CR>", desc = "Choose Both" },
      { "<leader>gxn", ":GitConflictChooseNone<CR>", desc = "Choose None" },
      { "<leader>gxl", ":GitConflictListQf<CR>", desc = "List Conflicts" },
      -- GitHub
      { "<leader>gh", group = "GitHub", icon = "" },
      { "<leader>ghp", "<cmd>GHOpenPR<CR>", desc = "Open Pull Request" },
      { "<leader>ghi", "<cmd>GHOpenIssue<CR>", desc = "Open Issue" },
      { "<leader>ghP", "<cmd>GHSearchPRs<CR>", desc = "Search Pull Requests" },
      { "<leader>ghI", "<cmd>GHSearchIssues<CR>", desc = "Search Issues" },
      { "<leader>ght", "<cmd>GHToggleThreads<CR>", desc = "Toggle Threads" },

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

      -- Review
      { "<leader>r", group = "Review", icon = "" },
      { "<leader>ra", qr_action("add_comment_cycle"), desc = "Add Comment" },
      { "<leader>ri", qr_add("ISSUE"), desc = "Add Issue", mode = { "n", "v" } },
      { "<leader>rs", qr_add("SUGGESTION"), desc = "Add Suggestion", mode = { "n", "v" } },
      { "<leader>rn", qr_add("NOTE"), desc = "Add Note", mode = { "n", "v" } },
      { "<leader>rp", qr_add("PRAISE"), desc = "Add Praise", mode = { "n", "v" } },
      { "<leader>rq", qr_add("QUESTION"), desc = "Add Question", mode = { "n", "v" } },
      { "<leader>rk", qr_add("INSIGHT"), desc = "Add Insight", mode = { "n", "v" } },
      { "<leader>rd", qr_delete, desc = "Delete Comment", mode = { "n", "v" } },
      { "<leader>rv", qr_action("view_comment"), desc = "View Comment" },
      { "<leader>re", qr_action("export_review"), desc = "Export Review" },
      { "<leader>rc", qr_action("clear_review"), desc = "Clear Review" },
      { "<leader>rS", qr_action("summary"), desc = "Review Summary" },
      { "<leader>rw", qr_action("save_review"), desc = "Save Review" },
      { "<leader>rl", qr_action("load_review"), desc = "Load Review" },
      { "<leader>ro", "<cmd>copen<CR>", desc = "Open Review List" },
      { "<leader>rg", qr_action("goto_real_file"), desc = "Goto Real File" },
      { "<leader>rj", qr_action("cycle_next_comment_type"), desc = "Cycle Next Type" },
      { "<leader>rh", qr_action("cycle_previous_comment_type"), desc = "Cycle Prev Type" },
      { "]r", "<cmd>cnext<CR>", desc = "Next Review Comment", mode = "n" },
      { "[r", "<cmd>cprev<CR>", desc = "Previous Review Comment", mode = "n" },

      -- Run & Tasks
      { "<leader>R", group = "Run", icon = "" },
      {
        "<leader>Rr",
        function()
          local ok, overseer = pcall(require, "overseer")
          if ok then
            overseer.run_template()
          end
        end,
        desc = "Run Task Template",
      },
      {
        "<leader>Rl",
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
        "<leader>Ro",
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
      { "<leader>oP", group = "Profiling", icon = "󰔟" },
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
        "<leader>on",
        function()
          local current_is_relative = vim.wo.relativenumber
          local current_is_normal = vim.wo.number

          if not current_is_normal and not current_is_relative then
            vim.wo.number = true
            vim.g.number_mode = "number"
          elseif current_is_normal and not current_is_relative then
            vim.wo.relativenumber = true
            vim.g.number_mode = "relative"
          else
            vim.wo.number = false
            vim.wo.relativenumber = false
            vim.g.number_mode = "off"
          end
          toggles.update("number_mode")
          vim.notify("Numbers: " .. vim.g.number_mode:upper(), vim.log.levels.INFO)
        end,
        desc = "Toggle Numbers",
      },
      {
        "<leader>ow",
        function()
          vim.wo.wrap = not vim.wo.wrap
          vim.g.wrap = vim.wo.wrap
          toggles.update("wrap")
          local state = vim.wo.wrap and "ON" or "OFF"
          local level = vim.wo.wrap and vim.log.levels.INFO or vim.log.levels.WARN
          vim.notify("Wrap: " .. state, level)
        end,
        desc = "Toggle Wrap",
      },
      {
        "<leader>os",
        function()
          vim.wo.spell = not vim.wo.spell
          vim.g.spell = vim.wo.spell
          toggles.update("spell")
          local state = vim.wo.spell and "ON" or "OFF"
          local level = vim.wo.spell and vim.log.levels.INFO or vim.log.levels.WARN
          vim.notify("Spell: " .. state, level)
        end,
        desc = "Toggle Spell",
      },
      {
        "<leader>oc",
        function()
          vim.wo.cursorline = not vim.wo.cursorline
          vim.g.cursorline = vim.wo.cursorline
          toggles.update("cursorline")
          local state = vim.wo.cursorline and "ON" or "OFF"
          local level = vim.wo.cursorline and vim.log.levels.INFO or vim.log.levels.WARN
          vim.notify("Cursorline: " .. state, level)
        end,
        desc = "Toggle Cursorline",
      },
      { "<leader>oa", ":AutoSaveToggle<CR>", desc = "Toggle Auto Save" },
      { "<leader>of", ":FormatToggle<CR>", desc = "Toggle Format on Save" },
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
      {
        "<leader>oe",
        function()
          if vim.wo.signcolumn == "yes" or vim.wo.signcolumn == "auto" then
            vim.wo.signcolumn = "no"
            vim.g.signcolumn = "no"
            vim.notify("Sign column: OFF", vim.log.levels.WARN)
          else
            vim.wo.signcolumn = "yes"
            vim.g.signcolumn = "yes"
            vim.notify("Sign column: ON", vim.log.levels.INFO)
          end
          toggles.update("signcolumn")
        end,
        desc = "Toggle Signcolumn",
      },
      {
        "<leader>ol",
        function()
          vim.wo.list = not vim.wo.list
          vim.g.list = vim.wo.list
          toggles.update("list")
          local state = vim.wo.list and "ON" or "OFF"
          local level = vim.wo.list and vim.log.levels.INFO or vim.log.levels.WARN
          vim.notify("Whitespace characters: " .. state, level)
        end,
        desc = "Toggle Whitespace",
      },
      {
        "<leader>oh",
        function()
          vim.o.hlsearch = not vim.o.hlsearch
          vim.g.hlsearch = vim.o.hlsearch
          toggles.update("hlsearch")
          local state = vim.o.hlsearch and "ON" or "OFF"
          local level = vim.o.hlsearch and vim.log.levels.INFO or vim.log.levels.WARN
          vim.notify("Search highlight: " .. state, level)
        end,
        desc = "Toggle Search Highlight",
      },
      {
        "<leader>ox",
        function()
          vim.g.diagnostics_enabled = not vim.g.diagnostics_enabled
          toggles.update("diagnostics_enabled")
          if vim.g.diagnostics_enabled then
            vim.diagnostic.enable()
            vim.notify("Diagnostics: ON", vim.log.levels.INFO)
          else
            vim.diagnostic.disable()
            vim.notify("Diagnostics: OFF", vim.log.levels.WARN)
          end
        end,
        desc = "Toggle Diagnostics",
      },
      {
        "<leader>oi",
        function()
          vim.g.inlay_hints_enabled = not vim.g.inlay_hints_enabled
          toggles.update("inlay_hints_enabled")
          if vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(vim.g.inlay_hints_enabled)
            local state = vim.g.inlay_hints_enabled and "ON" or "OFF"
            local level = vim.g.inlay_hints_enabled and vim.log.levels.INFO or vim.log.levels.WARN
            vim.notify("Inlay hints: " .. state, level)
          else
            vim.notify("Inlay hints not supported in this Neovim version", vim.log.levels.WARN)
          end
        end,
        desc = "Toggle Inlay Hints",
      },
      {
        "<leader>ot",
        function()
          vim.g.lint_enabled = not vim.g.lint_enabled
          toggles.update("lint_enabled")
          local state = vim.g.lint_enabled and "ON" or "OFF"
          local level = vim.g.lint_enabled and vim.log.levels.INFO or vim.log.levels.WARN
          vim.notify("Linting: " .. state, level)
        end,
        desc = "Toggle Linting",
      },
      {
        "<leader>oC",
        function()
          vim.g.copilot_enabled = not vim.g.copilot_enabled
          toggles.update("copilot_enabled")
          if vim.g.copilot_enabled then
            vim.cmd("Copilot enable")
            vim.notify("Copilot: ON", vim.log.levels.INFO)
          else
            vim.cmd("Copilot disable")
            vim.notify("Copilot: OFF", vim.log.levels.WARN)
          end
        end,
        desc = "Toggle Copilot",
      },
      {
        "<leader>op",
        function()
          -- Sync current toggles to config
          toggles.sync_to_config()

          -- Persist config to file
          local config = require("meowvim.config")
          if config.persist() then
            vim.notify("Settings persisted to " .. config.get_config_path(), vim.log.levels.INFO)
          else
            vim.notify("Failed to persist settings", vim.log.levels.ERROR)
          end
        end,
        desc = "Persist Settings",
      },

      -- Theme Settings (simplified)
      {
        "<leader>ok",
        function()
          local theme_manager = require("meowvim.theme_manager")
          theme_manager.show_menu()
        end,
        desc = "Theme Settings",
      },
      {
        "<leader>oK",
        function()
          local theme_manager = require("meowvim.theme_manager")
          theme_manager.quick_toggle()
        end,
        desc = "Quick Toggle Day/Night",
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

      -- Marks
      { "<leader>m", group = "Marks", icon = "󰃀" },
      {
        "<leader>mm",
        function()
          snacks.picker.marks()
        end,
        desc = "Search Marks",
      },

      -- Yank / Copy references (OpenCode / Claude compatible)
      { "<leader>y", group = "Yank", icon = "󰆒" },
      {
        "<leader>yf",
        copy_file_ref,
        desc = "Copy File Reference",
      },
      {
        "<leader>yl",
        copy_line_ref,
        desc = "Copy Line Reference",
        mode = { "n", "v" },
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
      { "<leader>h", group = "Help", icon = "󰋖" },
      {
        "<leader>hh",
        function()
          snacks.picker.help()
        end,
        desc = "Search Help",
      },
      {
        "<leader>hc",
        function()
          snacks.picker.commands()
        end,
        desc = "Search Commands",
      },
      {
        "<leader>hk",
        function()
          snacks.picker.keymaps()
        end,
        desc = "Search Keymaps",
      },
      {
        "<leader>hm",
        function()
          snacks.picker.man()
        end,
        desc = "Search Man Pages",
      },

      -- Tools (Mason)
      { "<leader>T", group = "Tools", icon = "" },
      { "<leader>Tm", "<cmd>Mason<CR>", desc = "Open Tool Manager" },
      { "<leader>Ti", "<cmd>MasonToolsInstall<CR>", desc = "Install Tools" },

      -- Quit
      { "<leader>q", group = "Quit", icon = "󰅚" },
      { "<leader>qq", ":qa<CR>", desc = "Quit All" },
      { "<leader>qQ", ":qa!<CR>", desc = "Force Quit All" },

      -- External Terminal
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
        desc = "Remove from Dictionary",
      },
    }

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

  -- Normal-mode Tab: cycle buffers.
  -- copilot.lua wraps this with NES accept+goto on InsertEnter load,
  -- passing through to bnext when no NES is active.
  vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next Buffer", silent = true })
  vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous Buffer", silent = true })

  -- Fold operations (vim-like, direct mappings)
  vim.keymap.set("n", "zp", function()
    local ok, ufo = pcall(require, "ufo")
    if ok then
      ufo.peekFoldedLinesUnderCursor()
    end
  end, { desc = "Peek Fold" })
end

return M
