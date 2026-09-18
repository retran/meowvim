-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/mini-pairs.lua
-- @brief: Auto-pairing brackets and quotes via mini.pairs.
--
-- Replaced ultimate-autopair (broken with Neovim 0.12.3) with mini.pairs.
-- Tabout and fastwarp features from ultimate-autopair are not available in
-- mini.pairs — use <C-f> to jump past closing bracket if needed.

return {
  "echasnovski/mini.pairs",
  version = false,
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    -- Only `command = true` differs from the defaults; the explicit `mappings`
    -- table that used to live here reproduced mini.pairs' own defaults (its
    -- `[^\\].` patterns are equivalent to the shipped `^[^\\]` on the
    -- always-two-character neighbourhood mini.pairs matches against).
    modes = { insert = true, command = true, terminal = false },
  },
  config = function(_, opts)
    require("mini.pairs").setup(opts)
  end,
}
