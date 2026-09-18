-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/persistence.lua
-- @brief: Session management with auto-save and restore on startup.
--
-- persistence only understands `dir`, `need` and `branch`; the `options` and
-- `pre_save` keys that used to be set here were silently ignored (session
-- contents come from `vim.o.sessionoptions`, set in lua/config/options.lua).

return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  -- Registered in init (not config) so the auto-restore hook exists on every
  -- startup, even when the plugin would otherwise stay lazy (e.g. nvim started
  -- in an empty project dir, where no BufReadPre fires).
  init = function()
    local config_ok, config = pcall(require, "meowvim.config")
    if config_ok and config.get("sessions.auto_restore", true) == false then
      return
    end
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("PersistenceAutoRestore", { clear = true }),
      nested = true,
      callback = function()
        require("utils.session").auto_restore()
      end,
    })
  end,
  opts = function()
    local config_ok, config = pcall(require, "meowvim.config")
    return {
      -- persistence appends the git branch to the session name on its own;
      -- its default is `true`, which contradicted `sessions.per_branch = false`.
      branch = config_ok and config.get("sessions.per_branch", false) or false,
    }
  end,
  config = function(_, opts)
    require("persistence").setup(opts)

    local config_ok, config = pcall(require, "meowvim.config")
    local auto_save = not config_ok or config.get("sessions.auto_save", true) ~= false

    if auto_save then
      vim.api.nvim_create_autocmd("DirChanged", {
        group = vim.api.nvim_create_augroup("PersistenceAutoSave", { clear = true }),
        pattern = "*",
        callback = function()
          -- Small delay to ensure the directory change is complete
          vim.defer_fn(function()
            require("persistence").save()
          end, 100)
        end,
      })
    end
  end,
}
