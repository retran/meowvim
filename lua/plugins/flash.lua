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
        -- jump_labels = false: f/t do a direct jump instead of entering the
        -- label-selection loop. That loop was what left the match highlights
        -- lingering across buffers (and surviving <space><space>/typing),
        -- because it kept a separate flash state alive. ;/, still repeat.
        jump_labels = false,
        keys = { "f", "F", "t", "T", ";", "," },
        config = function(opts)
          -- autohide in operator-pending; never force jump labels on
          opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")
          opts.jump_labels = opts.jump_labels
            and vim.v.count == 0
            and vim.fn.reg_executing() == ""
            and vim.fn.reg_recording() == ""
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
          -- clear 'hlsearch' after the jump: register = true writes the char
          -- to the search register, which otherwise lights up every match in
          -- all buffers until :nohl. nohlsearch keeps the register for n/N.
          nohlsearch = true,
          autojump = false,
        },
        multi_line = true,
        label = { exclude = "hjkliardc" },
        -- Hide match highlights immediately after the jump; ;/, still repeat.
        autohide = true,
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
