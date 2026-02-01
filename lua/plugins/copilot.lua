-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/copilot.lua
-- @brief: GitHub Copilot AI code completion and assistance plugin configuration.

return {
  "zbirenbaum/copilot.lua",
  enabled = function()
    local ok, config = pcall(require, "meowvim.config")
    if ok then
      return config.get("core.enable_copilot", false)
    end
    return vim.env.MEOW_ENABLE_COPILOT == "true"
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
