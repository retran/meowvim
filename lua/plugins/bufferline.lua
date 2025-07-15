return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  config = function()
    local bufferline = require("bufferline")
    bufferline.setup({
      options = {
        style_preset = bufferline.style_preset.no_italic,
        indicator = {
          style = "none",
        },
        buffer_close_icon = "",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        separator_style = { "|", "|" },

        color_icons = false,
        show_buffer_close_icons = false,
        show_close_icon = false,

        sort_by = "directory",
        max_name_length = 12,
        max_prefix_length = 10,
        tab_size = 12,

        custom_filter = function(buf_number)
          local filetype = vim.bo[buf_number].filetype
          if filetype == "NvimTree" then
            return false
          end

          local bufname = vim.fn.bufname(buf_number)
          if bufname:match("^fugitive://") then
            return false
          end

          return true
        end,
      },
    })
  end,
}
