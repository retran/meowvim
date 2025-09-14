-- MIT License
--
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
-- @file: lua/utils/hooks.lua
-- @brief: Utility functions for managing Neovim hooks and events.
-- @author: Andrew Vasilyev
-- @license: MIT
--
local M = {}

local function update_title()
  local mode = vim.api.nvim_get_mode().mode
  local mode_indicator = ""
  if mode == "n" or mode == "no" or mode == "ni" or mode == "nt" then
    mode_indicator = "[N]"
  elseif mode == "i" or mode == "ic" or mode == "ix" then
    mode_indicator = "[I]"
  elseif mode == "v" then
    mode_indicator = "[V]"
  elseif mode == "V" then
    mode_indicator = "[L]"
  elseif mode == " " or mode == "\22" then
    mode_indicator = "[B]"
  elseif mode == "c" or mode == "cv" or mode == "ce" then
    mode_indicator = "[:]"
  elseif mode == "s" or mode == "S" or mode == "\22" then
    mode_indicator = "[S]"
  elseif mode == "t" then
    mode_indicator = "[T]"
  elseif mode == "r" or mode == "R" then
    mode_indicator = "[R]"
  end

  local modified = ""
  if vim.bo.modified then
    modified = " [+]"
  end

  local readonly = ""
  if vim.bo.readonly then
    readonly = " [RO]"
  end

  local user = vim.env.USER or "user"
  local host = vim.fn.hostname() or "host"
  local user_host = string.format(" -- %s@%s", user, host)

  local config_name = "meowvim"

  vim.o.titlestring = string.format(
    "%s | %s%s%s %s%s",
    config_name,
    vim.fn.fnamemodify(vim.fn.expand("%"), ":t"),
    modified,
    readonly,
    mode_indicator,
    user_host
  )
end

function M.setup()
  local neovide_keymap_group = vim.api.nvim_create_augroup("NeovideKeymapToggle", { clear = true })

  vim.api.nvim_create_autocmd({ "UIEnter", "UILeave" }, {
    group = neovide_keymap_group,
    pattern = "*",
    callback = function(args)
      require("config/keymaps").setup()
    end,
  })

  local augroup = vim.api.nvim_create_augroup("WindowTitleUpdater", { clear = true })
  vim.api.nvim_create_autocmd({ "ModeChanged", "BufEnter", "FileChangedRO", "TextChanged" }, {
    group = augroup,
    pattern = "*",
    callback = update_title,
  })
end

return M
