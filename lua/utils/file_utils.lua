-- Função para ler todos os arquivos .lua em uma pasta
function load_lua_files(dir)
  local arr = {}
  files = vim.fn.glob(dir .. '/*.lua', 0, 1)
  for i, file in ipairs(files) do
    arr[i] = file
  end
  return arr;
end

function exec_project_folder(dir)
  local files = load_lua_files(lua_dir() .. dir)
  for _, file in ipairs(files) do
      local cmd = "source " .. file
      vim.cmd(cmd)
  end
end

function project_dir()
  return vim.fn.stdpath('config')
end

function lua_dir() 
  return vim.fn.stdpath('config') .. "/lua/"
end

return {
    load_lua_files = load_lua_files,
    project_dir = project_dir,
    lua_dir = lua_dir,
    exec_project_folder = exec_project_folder
}
