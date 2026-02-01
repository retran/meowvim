-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/copilot.lua
-- @brief: GitHub Copilot AI code completion and assistance plugin configuration.

return {
  "zbirenbaum/copilot.lua",
  enabled = function()
    -- Check if Copilot is enabled via toggle
    if vim.g.copilot_enabled ~= nil then
      return vim.g.copilot_enabled
    end
    
    -- Check config system
    local ok, config = pcall(require, "meowvim.config")
    if ok then
      return config.get("core.enable_copilot", false)
    end
    
    -- Disabled by default
    return false
  end,
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-CR>",
          next = "<M-n>",
          prev = "<M-p>",
          dismiss = "<M-e>",
        },
      },
      panel = {
        enabled = false,
        keymap = {
          open = false,
        },
      },
    })
  end,
}
