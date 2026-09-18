-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/mini-icons.lua
-- @brief: Icon provider. Mocks nvim-web-devicons so all plugins using it
--         transparently get mini.icons instead.

return {
  "echasnovski/mini.icons",
  version = false,
  lazy = false,
  config = function()
    local config_ok, config = pcall(require, "meowvim.config")
    local glyphs = not config_ok or config.get("ui.icons", true)

    require("mini.icons").setup({
      style = glyphs and "glyph" or "ascii",
    })
    -- Provide nvim-web-devicons-compatible API so lualine, neogit, etc.
    -- work without changes.
    MiniIcons.mock_nvim_web_devicons()
  end,
}
