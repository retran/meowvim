-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/copilot.lua
-- @brief: GitHub Copilot AI code completion and assistance plugin configuration.

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    -- Check if enabled via toggle (default: false)
    local enabled = vim.g.copilot_enabled or false
    
    require("copilot").setup({
      suggestion = {
        enabled = enabled,
        auto_trigger = enabled,
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
    
    -- Disable if toggle is off
    if not enabled then
      vim.cmd("Copilot disable")
    end
  end,
}
