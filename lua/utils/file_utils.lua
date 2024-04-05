-- Função para ler todos os arquivos .lua em uma pasta
function load_lua_files(dir)
  for filename in vim.fs.list(dir) do
    print("Arquivo: " .. filename)
    if vim.fn.match(filename, '%.lua') == 1 then
      print("Path: " .. vim.fs.absolute(dir .. '/' .. filename))
    end
  end
end

return {
    load_lua_files = load_lua_files
}