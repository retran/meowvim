-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/auto-save.lua
-- @brief: Automatic file saving when leaving insert mode or text changes.

return {
  "okuuva/auto-save.nvim",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    enabled = true,
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost" },
      defer_save = { "InsertLeave", "TextChanged" },
      cancel_deferred_save = { "InsertEnter" },
    },
    debounce_delay = 1500,
    write_all_buffers = true,
    lockmarks = true,
    condition = function(buf)
      if vim.g.disable_autosave then
        return false
      end

      local buf_disabled = false
      local ok, value = pcall(vim.api.nvim_buf_get_var, buf, "disable_autosave")
      if ok then
        buf_disabled = value
      end
      if buf_disabled then
        return false
      end

      local excluded_filetypes = {
        "gitcommit",
        "toggleterm",
        "lazy",
        "snacks_picker_list",
      }

      if vim.fn.getbufvar(buf, "&buftype") ~= "" then
        return false
      end

      if vim.tbl_contains(excluded_filetypes, vim.bo[buf].filetype) then
        return false
      end

      return true
    end,
  },
  init = function()
    local toggles = require("utils.toggles")
    toggles.ensure("disable_autosave")

    vim.api.nvim_create_user_command("AutoSaveDisable", function(args)
      if args.bang then
        vim.b.disable_autosave = true
        vim.notify("Auto-save: OFF (Buffer)", vim.log.levels.WARN)
      else
        vim.g.disable_autosave = true
        toggles.update("disable_autosave")
        vim.notify("Auto-save: OFF (Global)", vim.log.levels.WARN)
      end
    end, {
      desc = "Disable Auto Save (Global or !Buffer)",
      bang = true,
    })

    vim.api.nvim_create_user_command("AutoSaveEnable", function(args)
      if args.bang then
        vim.b.disable_autosave = false
        vim.notify("Auto-save: ON (Buffer)", vim.log.levels.INFO)
      else
        vim.g.disable_autosave = false
        toggles.update("disable_autosave")
        vim.notify("Auto-save: ON (Global)", vim.log.levels.INFO)
      end
    end, {
      desc = "Enable Auto Save (Global or !Buffer)",
      bang = true,
    })

    vim.api.nvim_create_user_command("AutoSaveToggle", function(args)
      if args.bang then
        vim.b.disable_autosave = not vim.b.disable_autosave
        if vim.b.disable_autosave then
          vim.notify("Auto-save: OFF (Buffer)", vim.log.levels.WARN)
        else
          vim.notify("Auto-save: ON (Buffer)", vim.log.levels.INFO)
        end
      else
        vim.g.disable_autosave = not vim.g.disable_autosave
        toggles.update("disable_autosave")
        if vim.g.disable_autosave then
          vim.notify("Auto-save: OFF (Global)", vim.log.levels.WARN)
        else
          vim.notify("Auto-save: ON (Global)", vim.log.levels.INFO)
        end
      end
    end, {
      desc = "Toggle Auto Save (Global or !Buffer)",
      bang = true,
    })
  end,
}
