-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/copilot.lua
-- @brief: GitHub Copilot – inline suggestions.
--
-- Inline ghost text via copilot.suggestion API.
-- Copilot LSP binary (copilot-language-server) installed via mise.
--
-- Keymaps:
--   <C-l>  (insert)  – accept inline suggestion (nvim-cmp.lua handles fallback to cmp)
--   <Esc>  (insert)  – dismiss inline suggestion (nvim-cmp.lua checks suggestion.is_visible())
--   <leader>oC       – toggle Copilot on/off globally (keymaps.lua)

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = true,
      keymap = {
        accept = false,
        accept_word = false,
        accept_line = false,
        next = false,
        prev = false,
        dismiss = false,
        toggle_auto_trigger = false,
      },
    },
    server = {
      type = "binary",
      custom_server_filepath = "copilot-language-server",
    },
  },
}
