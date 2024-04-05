-- Função para ler todos os arquivos .lua em uma pasta
function load_lua_files(dir)
  local files = vim.fn.glob(dir .. '/*.lua', 0, 1)
  for _, file in ipairs(files) do
      print('Arquivo:', file)
  end
end

return {
    load_lua_files = load_lua_files
}
