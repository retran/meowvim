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
