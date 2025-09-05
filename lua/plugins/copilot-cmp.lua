-- lua/plugins/copilot-cmp.lua

return {
  "zbirenbaum/copilot-cmp",
  enabled = vim.env.MEOW_ENABLE_COPILOT == "true" or false,
  dependencies = { "copilot.lua" },
  config = function()
    require("copilot_cmp").setup()
  end,
}
