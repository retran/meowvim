local M = {}

function M.setup()
  local snacks = require("snacks")

  snacks.dashboard.sections.session = function(item)
    return setmetatable({
      action = ":silent! AutoSession restore",
      section = false,
    }, { __index = item })
  end
end

return M
