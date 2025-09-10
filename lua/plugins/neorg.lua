-- lua/plugins/neorg.lua

return {
  "nvim-neorg/neorg",
  dependencies = {
    "vhyrro/luarocks.nvim",
    "nvim-lua/plenary.nvim",
  },
  ft = "norg",
  config = function()
    require("neorg").setup({
      load = {
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.concealer"] = {},
        ["core.defaults"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
            },
            default_workspace = "notes",
            index = "index.norg",
          },
        },
        ["core.journal"] = {
          config = {
            strategy = "nested",
            workspace = "notes",
          },
        },
        ["core.integrations.nvim-cmp"] = {},
        ["core.integrations.treesitter"] = {},
      },
    })
  end,
}
