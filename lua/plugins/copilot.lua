-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/copilot.lua
-- @brief: GitHub Copilot – inline suggestions + NES (Next Edit Suggestions).
--
-- Inline ghost text via copilot.suggestion API.
-- NES via copilotlsp-nvim/copilot-lsp (optional dependency).
-- Copilot LSP binary (copilot-language-server) installed by Mason.
--
-- Keymaps:
--   <C-l>  (insert)  – accept inline suggestion (nvim-cmp.lua handles fallback to cmp)
--   <Esc>  (insert)  – dismiss inline suggestion (nvim-cmp.lua checks suggestion.is_visible())
--   <M-l>  (normal)  – NES: accept suggestion and go to end of edit
--   <M-j>  (normal)  – NES: accept suggestion, stay at cursor
--   <M-h>  (normal)  – NES: dismiss suggestion
--   <leader>oC       – toggle Copilot on/off globally (keymaps.lua)

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  dependencies = {
    {
      "copilotlsp-nvim/copilot-lsp",
      init = function()
        vim.g.copilot_nes_debounce = 500
      end,
    },
  },
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = true,
      keymap = {
        accept = false,        -- handled in nvim-cmp.lua (<C-l> smart accept)
        accept_word = false,
        accept_line = false,
        next = false,
        prev = false,
        dismiss = false,          -- handled in nvim-cmp.lua (<Esc> checks suggestion.is_visible())
        toggle_auto_trigger = false,
      },
    },
    nes = {
      enabled = true,
      keymap = {
        accept_and_goto = "<M-l>",
        accept          = "<M-j>",
        dismiss         = "<M-h>",
      },
    },
    server = {
      type = "binary",
      -- Mason installs the binary; init.lua prepends mason/bin to PATH.
      custom_server_filepath = "copilot-language-server",
    },
  },
}
