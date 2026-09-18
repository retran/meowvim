-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/rainbow-delimiters.lua
-- @brief: Rainbow bracket/delimiter colouring via treesitter.

return {
  "HiPhish/rainbow-delimiters.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    -- Only the Lua query is customised: `rainbow-blocks` also colours do/end
    -- and if/then blocks, not just delimiters. Strategy, highlight groups and
    -- priority are left at the plugin's defaults (the previous copies of them
    -- here were identical to what rainbow-delimiters ships).
    require("rainbow-delimiters.setup").setup({
      query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
      },
    })
  end,
}
