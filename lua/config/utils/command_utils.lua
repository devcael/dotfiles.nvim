local M = {}

local function run(cmd)
  local result = vim.fn.system(cmd)
  local trimmed_result = result:gsub("%s+$", "")    -- Remove espaços em branco e quebras de linha no final
  local exit_code = vim.v.shell_error               -- Código de saída do comando

  if exit_code == 0 then
    return trimmed_result
  else
    return ""
  end
end

local function path_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat ~= nil
end

M.run = run
M.path_exists = path_exists

return M
