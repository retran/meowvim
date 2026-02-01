-- Luacheck configuration for meowvim

std = "luajit"
cache = true

globals = {
  "vim",
}

read_globals = {
  "jit",
}

ignore = {
  "212", -- Unused argument
  "213", -- Unused loop variable
  "631", -- Line is too long
}

exclude_files = {
  ".git/",
  "lazy-lock.json",
}

-- Maximum line length (default is 120)
max_line_length = 120

-- Maximum cyclomatic complexity
max_cyclomatic_complexity = 30
