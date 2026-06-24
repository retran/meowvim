-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/ultimate-autopair.lua
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
    modes = { insert = true, command = true, terminal = false },
    mappings = {
      ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
      ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
      ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
      [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
      ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
      ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
      ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
      ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
      ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
    },
  },
  config = function(_, opts)
    require("mini.pairs").setup(opts)
  end,
}
