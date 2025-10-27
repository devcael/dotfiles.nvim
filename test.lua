local paths = vim.split(vim.fn.glob('G:\\SISTEMAS\\LIB\\*.jar'), '\n')

for _, path in ipairs(paths) do
  print(path)
end
