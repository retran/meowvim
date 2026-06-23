-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/flash.lua
-- @brief: Search-based motion with contextual highlighting.

return {
  "folke/flash.nvim",
  -- No keys table: f/F/t/T are handled via modes.char below so that
  -- ; and , repeat correctly (search-mode overrides broke repeat).
  opts = {
    labels = "asdfghjklqwertyuiopzxcvbnm1234567890",
    search = {
      multi_window = true,
      mode = "exact",
    },
    jump = {
      autojump = false,
    },
    label = {
      uppercase = true,
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
      -- Use char mode for f/F/t/T so that ; and , repeat work correctly.
      -- max_length = 2 gives the 2-char jump behaviour while preserving repeat.
      char = {
        enabled = true,
        jump_labels = true,
        keys = { "f", "F", "t", "T", ";", "," },
        config = function(opts)
          opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")
          opts.jump_labels = true
        end,
        char_actions = function(_motion)
          return { [";"] = "next", [","] = "prev" }
        end,
        search = {
          wrap = false,
          multi_window = false,
          max_length = 2,
        },
        highlight = { backdrop = true },
        jump = {
          register = true,
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
    prompt = {
      enabled = true,
      prefix = { { "⚡", "FlashPromptIcon" } },
    },
  },
}
