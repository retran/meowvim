return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
    disable_filetype = { "vim" },
    map_cr = true,
  },
  config = function(_, opts)
    local autopairs = require("nvim-autopairs")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")

    autopairs.setup(opts)
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
