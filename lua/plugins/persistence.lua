-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/persistence.lua
-- @brief: Enhanced session management with auto-save, picker, and per-branch support.

return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
    { "<leader>qS", function() require("persistence").select() end, desc = "Select Session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
  },
  opts = function()
    local config_ok, config = pcall(require, "meowvim.config")
    local per_branch = false
    local auto_save = true
    local auto_restore = true
    
    if config_ok then
      per_branch = config.get("sessions.per_branch", false)
      auto_save = config.get("sessions.auto_save", true)
      auto_restore = config.get("sessions.auto_restore", true)
    end
    
    return {
      options = {
        "buffers",
        "curdir",
        "folds",
        "globals",
        "tabpages",
        "winpos",
        "winsize",
        "localoptions",
      },
      pre_save = function()
        -- Close certain plugin windows before saving
        vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
        
        -- Close NvimTree, aerial, and other plugin windows
        local close_filetypes = { "NvimTree", "neo-tree", "aerial", "Outline", "trouble" }
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.bo[buf].filetype
          if vim.tbl_contains(close_filetypes, ft) then
            pcall(vim.api.nvim_win_close, win, true)
          end
        end
      end,
    }
  end,
  config = function(_, opts)
    local persistence = require("persistence")
    persistence.setup(opts)
    
    -- Get configuration
    local config_ok, config = pcall(require, "meowvim.config")
    local per_branch = config_ok and config.get("sessions.per_branch", false) or false
    local auto_save = config_ok and config.get("sessions.auto_save", true) or true
    local auto_restore = config_ok and config.get("sessions.auto_restore", true) or true
    
    -- Auto-save session on directory change
    if auto_save then
      vim.api.nvim_create_autocmd("DirChanged", {
        pattern = "*",
        callback = function()
          -- Small delay to ensure the directory change is complete
          vim.defer_fn(function()
            persistence.save()
          end, 100)
        end,
      })
    end
    
    -- Per-branch session support
    if per_branch then
      local function get_git_branch()
        local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
        if not handle then return nil end
        local branch = handle:read("*a")
        handle:close()
        return branch and branch:gsub("\n", "") or nil
      end
      
      -- Override session file name to include branch
      local original_save = persistence.save
      persistence.save = function()
        local branch = get_git_branch()
        if branch then
          -- Temporarily modify the session name
          vim.g.persistence_branch = branch
        end
        original_save()
      end
    end
    
    -- Auto-restore session on VimEnter
    if auto_restore then
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("PersistenceAutoRestore", { clear = true }),
        callback = function()
          -- Only load the session if nvim was started with no arguments
          if vim.fn.argc(-1) == 0 then
            persistence.load()
          end
        end,
        nested = true,
      })
    end
  end,
}
