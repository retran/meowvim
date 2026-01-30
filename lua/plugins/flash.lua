-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/flash.lua
-- @brief: Search-based motion with contextual highlighting.

return {
  "folke/flash.nvim",
  opts = {
    -- Configure flash to mimic default f/t/F/T behavior with enhancements
    jump = {
      autojump = false, -- Don't autojump if there's only one match
    },
    label = {
      uppercase = false, -- Use lowercase labels
      rainbow = {
        enabled = false, -- Don't use rainbow colors for labels
        shade = 5,
      },
    },
    modes = {
      search = {
        enabled = true,
        multi_window = true,
        highlight = { backdrop = true },
      },
      char = {
        enabled = true,
        -- Character search settings (f, F, t, T)
        keys = { "f", "F", "t", "T" }, -- Enable default keys
        char_actions = function(motion)
          return {
            [";"] = "next", -- Repeat motion forward
            [","] = "prev", -- Repeat motion backward
          }
        end,
        search = { wrap = false }, -- Don't wrap around
        highlight = { backdrop = false }, -- Don't dim background
        jump = { register = false }, -- Don't update jump list
        multi_line = false, -- Stay on current line (mimic default)
        jump_labels = false, -- Don't show labels for char mode (use ; and , for repeat)
      },
      treesitter = {
        labels = "abcdefghijklmnopqrstuvwxyz",
        jump = { pos = "range" },
        search = { incremental = false },
        label = { before = true, after = true, style = "inline" },
        highlight = {
          backdrop = false,
          matches = false,
        },
      },
    },
    -- Prompt configuration
    prompt = {
      enabled = true,
      prefix = { { "⚡", "FlashPromptIcon" } },
    },
  },
}
