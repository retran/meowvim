-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/copilot.lua
-- @brief: GitHub Copilot AI code completion and assistance plugin configuration.

local Meow = require("config.custom")

return {
  "zbirenbaum/copilot.lua",
  enabled = Meow.enable_copilot,
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
