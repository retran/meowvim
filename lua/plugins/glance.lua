-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/glance.lua
-- @brief: VSCode-like LSP peek windows.

return {
  "dnlhc/glance.nvim",
  cmd = "Glance",
  opts = {
    -- Always use the detached layout. glance has no top-level `preview`
    -- option (see GlanceOpts in glance/config.lua) — the previous
    -- `preview = { type = ..., win = ... }` block was silently ignored.
    detached = true,
  },
  config = function(_, opts)
    require("glance").setup(opts)
  end,
}
