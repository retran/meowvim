-- lua/plugins/copilot-cmp.lua

return {
  "zbirenbaum/copilot-cmp",
  dependencies = { "copilot.lua" },
  config = function()
    require("copilot_cmp").setup()
  end,
}
