local M = {}

---Gets the path for a session file based on the directory.
---Session files are named based on the directory name and the current git branch
---to allow for different sessions per branch.
---@param dir string The project directory.
---@return string The full path to the session file.
function M.get_session_path(dir)
  local sessions_base_dir = vim.fn.stdpath("data") .. "/sessions/"

  if vim.fn.isdirectory(sessions_base_dir) == 0 then
    vim.fn.mkdir(sessions_base_dir, "p")
  end

  local dir_name = vim.fn.fnamemodify(dir, ":t")

  local branch_name = ""
  if vim.fn.isdirectory(dir .. "/.git") then
    local handle = io.popen("git -C " .. vim.fn.fnameescape(dir) .. " branch --show-current 2>/dev/null")
    if handle then
      branch_name = handle:read("*a"):gsub("%s+", "")
      handle:close()
    end
  end

  local safe_branch_name = branch_name:gsub("[\\/:]", "_")
  local final_filename = dir_name .. "%%" .. safe_branch_name .. ".vim"

  return sessions_base_dir .. final_filename
end

---Saves the current Neovim session for the current working directory.
---It avoids saving a session for the home directory.
---@param verbose boolean | nil If true, show notifications.
function M.save(verbose)
  local current_dir = vim.fn.getcwd()
  local home_dir = vim.fn.expand("~")

  if current_dir == home_dir then
    if verbose then
      vim.notify("Skipping session save for home directory.", vim.log.levels.INFO)
    end
    return
  end

  local session_path = M.get_session_path(current_dir)
  if verbose then
    vim.notify("Saving session: " .. vim.fn.fnamemodify(session_path, ":t"), vim.log.levels.INFO)
  end

  vim.cmd("mksession! " .. vim.fn.fnameescape(session_path))
end

---Loads a session for a given directory if a session file exists.
---@param dir string The directory to load the session for.
---@param verbose boolean | nil If true, show notifications.
function M.load(dir, verbose)
  local session_path = M.get_session_path(dir)

  if vim.fn.filereadable(session_path) == 1 then
    if verbose then
      vim.notify("Found existing session: " .. vim.fn.fnamemodify(session_path, ":t"), vim.log.levels.INFO)
    end

    vim.cmd("silent! source " .. vim.fn.fnameescape(session_path))
  else
    if verbose then
      vim.notify("No session found for this project. Starting fresh.", vim.log.levels.INFO)
    end
  end
end

return M
