-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/copilot-cmp.lua
-- @brief: Copilot integration with nvim-cmp completion engine.

return {
  "zbirenbaum/copilot-cmp",
  enabled = Meow.enable_copilot,
  dependencies = { "copilot.lua" },
  config = function()
    require("copilot_cmp").setup()
  end,
}
