local M = {}

function M.setup()
  local dap = require("dap")
  local utils = require("resources.utils")
  
  -- Configurações básicas
  dap.configurations.java = {
    {
      type = 'java',
      request = 'attach',
      name = "Debug (Attach) - Spring Boot Local",
      hostName = "127.0.0.1",
      port = 5005,
    },
    {
      type = 'java',
      request = 'attach',
      name = "Debug (Attach) - Porta Customizada",
      hostName = function()
        return vim.fn.input('Host: ', '127.0.0.1')
      end,
      port = function()
        return tonumber(vim.fn.input('Porta: ', '5005'))
      end,
    }
  }
  
  -- Adicionar configurações baseadas em perfis
  local profiles = utils.get_spring_profiles()
  for _, profile in ipairs(profiles) do
    local port = 5005
    if profile == "test" then port = 5006
    elseif profile == "prod" then port = 5007
    elseif profile == "local" then port = 5008 end
    
    table.insert(dap.configurations.java, {
      type = 'java',
      request = 'attach',
      name = "Debug Spring Boot (" .. profile .. ")",
      hostName = "127.0.0.1",
      port = port,
      projectName = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    })
  end
end

return M
