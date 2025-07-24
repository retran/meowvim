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
      lualine_b = {

      },
      lualine_c = {
        "branch",
        "diff",
        "gitsigns",
        { "filename", path = 1 },
      },
      lualine_x = {
        "diagnostics",
        {
          'copilot',
          symbols = {
            status = {
              icons = {
                enabled = "",
                sleep = "",
                disabled = "",
                warning = "",
                unknown = ""
              },
              hl = {
                enabled = "#50FA7B",
                sleep = "#AEB7D0",
                disabled = "#6272A4",
                warning = "#FFB86C",
                unknown = "#FF5555"
              }
            },
            spinners = "dots",
            spinner_color = "#6272A4"
          },
          show_colors = true,
          show_loading = true
        },
        "filetype",
        "encoding",
        {
          "fileformat",
          symbols = {
            unix = "LF",
            dos = "CRLF",
            mac = "CR",
          },
        },
      },
      lualine_y = {

      },
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
