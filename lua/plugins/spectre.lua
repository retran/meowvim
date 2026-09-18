-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/spectre.lua
-- @brief: Project-wide search and replace UI.

return {
  "nvim-pack/nvim-spectre",
  cmd = "Spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- No `highlight` overrides: `search`/`replace` only restated spectre's own
    -- defaults, and `ui = "SpectreUI"` pointed at a highlight group that does
    -- not exist in the plugin (the real one is `SpectreBody`), leaving the
    -- panel body unhighlighted.
    mapping = {
      -- Remapped from spectre's default <leader>q, which collides with the
      -- Quit group in lua/config/keymaps.lua.
      ["send_to_qf"] = {
        map = "<leader>Q",
        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
        desc = "Send to Quickfix List",
      },
    },
  },
}
