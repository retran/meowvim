-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/spectre.lua
-- @brief: Project-wide search and replace UI.

return {
  "nvim-pack/nvim-spectre",
  cmd = "Spectre",
  module = "spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    highlight = {
      ui = "SpectreUI",
      search = "SpectreSearch",
      replace = "SpectreReplace",
    },
    mapping = {
      ["send_to_qf"] = { map = "<leader>Q", cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>", desc = "Send to quickfix" },
    },
  },
}
