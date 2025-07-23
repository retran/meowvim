-- lua/plugins/lualine.lua

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "lewis6991/gitsigns.nvim",
    "AndreM222/copilot-lualine",
  },
  opts = {
    options = {
      theme = "tokyonight",

      icons_enabled = true,

      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
      ignore_focus = {},
      refresh = {
        statusline = 50,
        winbar = 50,
      },

      always_divide_middle = true,
      globalstatus = true,

      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    sections = {
      lualine_a = { "mode" },
      lualine_b = {},
      lualine_c = {
        "branch",
        { "filename", path = 1 },
      },
      lualine_x = {
        "diff",
        "diagnostics",
        "gitsigns",
        "encoding",
        {
          "fileformat",
          symbols = {
            unix = "LF",
            dos = "CRLF",
            mac = "CR",
          },
        },
        "filetype",
      },
      lualine_y = { "copilot" },
      lualine_z = {
        "progress",
        "location",
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "progress", "location" },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = { "lazy", "nvim-tree" },
  },
}
