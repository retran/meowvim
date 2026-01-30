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
      uppercase = true, -- Allow uppercase to get more labels
      after = { 0, 0 }, -- Show labels after the match
      before = { 0, 0 }, -- Show labels before the match
      style = "overlay", -- Overlay labels on the match
      reuse = "none", -- Don't reuse labels, show all at once
      min_pattern_length = 0, -- Show labels immediately
      rainbow = {
        enabled = false, -- Don't use rainbow colors for labels
        shade = 5,
      },
    },
    -- Use all keyboard characters for maximum single-keypress positions
    -- Home row first, then rest, then numbers: 26 + 26 + 10 = 62 positions
    labels = "asdfghjklqwertyuiopzxcvbnm1234567890",
    search = {
      multi_window = false, -- Search only in current window for f/t
      mode = "exact", -- Exact character match
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
        -- Override config function to always enable jump_labels
        config = function(opts)
          -- Always enable jump labels for f/t
          opts.jump_labels = true
        end,
        autohide = false,
        jump_labels = true, -- Always show jump labels
        multi_line = true, -- Allow jumping to other visible lines
        label = { exclude = "hjkliardc" },
        char_actions = function(motion)
          return {
            [";"] = "next", -- Repeat motion forward
            [","] = "prev", -- Repeat motion backward
          }
        end,
        search = { wrap = false }, -- Don't wrap around
        highlight = { backdrop = true }, -- Dim non-searchable areas
        jump = { 
          register = false, -- Don't update jump list
          autojump = false,
        },
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
