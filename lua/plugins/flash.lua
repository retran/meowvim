-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/flash.lua
-- @brief: Search-based motion with contextual highlighting.

return {
  "folke/flash.nvim",
  keys = {
    {
      "f",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump({
          search = { mode = "search", max_length = 2, forward = true, wrap = false },
        })
      end,
      desc = "Flash forward 2-char",
    },
    {
      "F",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump({
          search = { mode = "search", max_length = 2, forward = false, wrap = false },
        })
      end,
      desc = "Flash backward 2-char",
    },
    {
      "t",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump({
          search = { mode = "search", max_length = 2, forward = true, wrap = false },
          jump = { pos = "end" },
        })
      end,
      desc = "Flash till forward 2-char",
    },
    {
      "T",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump({
          search = { mode = "search", max_length = 2, forward = false, wrap = false },
          jump = { pos = "end" },
        })
      end,
      desc = "Flash till backward 2-char",
    },
  },
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
        enabled = false, -- Disabled since we use custom 2-char f/t/F/T mappings
        jump_labels = true,
        keys = { "f", "F", "t", "T", ";", "," },
        config = function(opts)
          opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")
          opts.jump_labels = true
        end,
        char_actions = function(motion)
          return {
            [";"] = "next",
            [","] = "prev",
          }
        end,
        search = {
          wrap = true,
          multi_window = false,
        },
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
    prompt = {
      enabled = true,
      prefix = { { "⚡", "FlashPromptIcon" } },
    },
  },
}
