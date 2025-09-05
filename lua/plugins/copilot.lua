-- lua/plugins/copilot.lua

return {
  "zbirenbaum/copilot.lua",
  enabled = vim.env.MEOW_ENABLE_COPILOT == "true" or false,
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = false,
      },
      panel = {
        enabled = false,
      },
    })
  end,
}
