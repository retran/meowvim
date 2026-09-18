-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/flash.lua
-- @brief: Search-based motion with contextual highlighting.

return {
  "folke/flash.nvim",
  -- No keys table: f/F/t/T are hooked by modes.char below so that ; and ,
  -- repeat correctly (search-mode overrides broke repeat). VeryLazy is early
  -- enough for that and keeps flash off the startup path.
  event = "VeryLazy",
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
      -- Everything not listed here (keys, multi_line, label.exclude, the
      -- dynamic `config` hook and char_actions) is left at flash's defaults —
      -- the previous copy of them was byte-identical, except that the inlined
      -- char_actions dropped flash's clever-f bindings (pressing the motion key
      -- again to advance, its uppercase to go back).
      char = {
        -- f/t jump straight to the match instead of entering the
        -- label-selection loop. That loop was what left match highlights
        -- lingering across buffers (surviving <space><space> and typing),
        -- because it kept a separate flash state alive. ;/, still repeat.
        jump_labels = false,
        search = {
          wrap = false,
          multi_window = false,
          -- 2-char jump behaviour while preserving ; and , repeat
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
