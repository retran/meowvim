-- lua/plugins/copilot-lualine.lua

return {
  "AndreM222/copilot-lualine",
  enabled = vim.env.MEOW_ENABLE_COPILOT == "true" or false,
}
