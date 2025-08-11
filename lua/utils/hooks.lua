local M = {}

function M.setup()
  local neovide_keymap_group = vim.api.nvim_create_augroup("NeovideKeymapToggle", { clear = true })

  vim.api.nvim_create_autocmd({ "UIEnter", "UILeave" }, {
    group = neovide_keymap_group,
    pattern = "*",
    callback = function(args)
      require("config/keymaps").setup()
    end,
  })
end

return M
