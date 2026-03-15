-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    local toggles_ok, toggles = pcall(require, "utils.toggles")
    if toggles_ok then
      toggles.ensure("copilot_enabled")
    end
    
    local enabled = vim.g.copilot_enabled or false
    
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,

        keymap = {
          accept = false,
          accept_word = "<C-g>",
          accept_line = false,
          next = "<C-n>",
          prev = "<C-p>",
          dismiss = "<Esc>",
        },
      },
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
      },
      filetypes = {
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
    })
    
    if not enabled then
      vim.cmd("Copilot disable")
    end
  end,
}
