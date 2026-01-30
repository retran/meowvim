-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/flash.lua
-- @brief: Search-based motion with contextual highlighting.

return {
  "folke/flash.nvim",
  opts = {
    -- Use all available characters for labels (with uppercase, this gives 52 + 10 = 62 positions)
    labels = "asdfghjklqwertyuiopzxcvbnm1234567890",
    search = {
      multi_window = true,
      mode = "exact",
    },
    jump = {
      autojump = false,
    },
    label = {
      uppercase = true, -- This will add A-Z automatically, doubling available labels
      after = true,
      before = false,
      style = "overlay",
      reuse = "lowercase",
      distance = true,
      min_pattern_length = 0,
    },
    highlight = {
      backdrop = true,
      matches = true,
    },
    modes = {
      search = {
        enabled = true,
      },
      char = {
        enabled = true,
        jump_labels = true, -- Enable labels for f/t/F/T
        keys = { "f", "F", "t", "T", ";", "," },
        char_actions = function(motion)
          return {
            [";"] = "next",
            [","] = "prev",
          }
        end,
        search = { wrap = false },
        highlight = { backdrop = true },
        jump = { 
          register = false,
          autojump = false,
        },
        multi_line = true,
        label = { exclude = "hjkliardc" },
        autohide = false,
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
