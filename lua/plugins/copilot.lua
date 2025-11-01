-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/copilot.lua
-- @brief: GitHub Copilot AI code completion and assistance plugin configuration.

return {
  "zbirenbaum/copilot.lua",
  enabled = Meow.enable_copilot,
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = false,
      },
      panel = {
        enabled = false,
      },
    })
  end,
}
