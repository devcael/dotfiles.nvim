local M = {}

M.load_lua_files = function(dir)
  local arr = {}
  files = vim.fn.glob(dir .. '/*.lua', 0, 1)
  for i, file in ipairs(files) do
    arr[i] = file
  end
  return arr;
end

M.lua_dir = function()
  return vim.fn.stdpath('config') .. "/lua/"
end


M.exec_project_folder = function(dir)
  local files = M.load_lua_files(M.lua_dir() .. dir)
  for _, file in ipairs(files) do
    local cmd = "source " .. file
    vim.cmd(cmd)
  end
end

M.project_dir = function()
  return vim.fn.stdpath('config')
end

return M

