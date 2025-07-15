local M = {}

function M.setup()
  local session = require("utils.session")

  local session_group = vim.api.nvim_create_augroup("AutoSaveSessionOnExit", { clear = true })
  vim.api.nvim_create_autocmd("VimLeave", {
    group = session_group,
    pattern = "*",
    desc = "Save session on leaving Neovim",
    callback = function()
      session.save(false)
    end,
  })
end

return M
