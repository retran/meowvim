-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/editorconfig.lua
-- @brief: EditorConfig support for consistent coding styles across editors

return {
  "editorconfig/editorconfig-vim",
  event = { "BufReadPre", "BufNewFile" },
  init = function()
    -- Let EditorConfig set these values
    vim.g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" }
    
    -- Don't let EditorConfig override these Neovim-specific settings
    vim.g.EditorConfig_disable_rules = { "trim_trailing_whitespace" }
  end,
}
