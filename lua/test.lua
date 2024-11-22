local function run_command(cmd)
  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error     -- Código de saída do comando

  if exit_code == 0 then
    return result
  else
    return ""
  end
end

run_command("comando")


