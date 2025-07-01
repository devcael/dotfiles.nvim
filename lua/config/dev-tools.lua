local M = {}

local function show_dev_menu()
  local options = {
    "🚀 Executar Spring Boot",
    "🐛 Debug Spring Boot",
    "☕ Selecionar Java Version",
    "📝 Criar launch.json",
    "🔧 Configurar Variáveis de Ambiente",
    "📊 Mostrar Status do Projeto",
    "🧹 Limpar Cache Maven",
    "📦 Instalar Dependências"
  }
  
  vim.ui.select(options, {
    prompt = "🛠️  Ferramentas de Desenvolvimento:",
  }, function(choice, idx)
    if not choice then return end
    
    if idx == 1 then
      require("config.dap.spring-boot").run_spring_boot_interactive()
    elseif idx == 2 then
      require("config.dap.spring-boot").run_spring_boot_quick(true)
    elseif idx == 3 then
      local jdtls = require("config.lsp.servers.jdtls")
      if jdtls.select_java_version then
        jdtls.select_java_version()
      else
        vim.notify("Função select_java_version não encontrada", vim.log.levels.WARN)
      end
    elseif idx == 4 then
      require("config.dap.spring-boot").create_launch_json()
    elseif idx == 5 then
      M.configure_env_vars()
    elseif idx == 6 then
      M.show_project_status()
    elseif idx == 7 then
      M.clean_maven_cache()
    elseif idx == 8 then
      M.install_dependencies()
    end
  end)
end

function M.configure_env_vars()
  local env_file = ".env"
  if vim.loop.fs_stat(env_file) then
    vim.cmd("edit " .. env_file)
  else
    local template = [[
# Spring Boot Configuration
SPRING_PROFILES_ACTIVE=dev
SERVER_PORT=8080

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=myapp
DB_USERNAME=user
DB_PASSWORD=password

# Debug Configuration
DEBUG_PORT=5005

# Memory Settings
JAVA_OPTS=-Xmx512m -Xms256m

# Custom Variables
# API_KEY=your-api-key-here
# JWT_SECRET=your-jwt-secret-here
]]
    vim.fn.writefile(vim.split(template, "\n"), env_file)
    vim.cmd("edit " .. env_file)
    vim.notify("Criado template .env", vim.log.levels.INFO)
  end
end

function M.show_project_status()
  local utils = require("resources.utils")
  local env_vars = utils.load_env_files()
  
  local status = {
    "📊 Status do Projeto:",
    "",
    "📁 Diretório: " .. vim.fn.getcwd(),
    "☕ Java Ativo: " .. (cache_vars.selected_java or "Padrão do sistema"),
    "🏷️  Perfil Spring: " .. (env_vars.SPRING_PROFILES_ACTIVE or "dev"),
    "🔌 Porta Server: " .. (env_vars.SERVER_PORT or "8080"),
    "🐛 Porta Debug: " .. (env_vars.DEBUG_PORT or "5005"),
    "💾 Banco de Dados: " .. (env_vars.DB_HOST or "localhost") .. ":" .. (env_vars.DB_PORT or "5432"),
  }
  
  vim.notify(table.concat(status, "\n"), vim.log.levels.INFO)
end

function M.clean_maven_cache()
  vim.ui.select({"Sim", "Não"}, {
    prompt = "Limpar cache do Maven? (.m2/repository)",
  }, function(choice)
    if choice == "Sim" then
      vim.cmd("term mvn dependency:purge-local-repository")
    end
  end)
end

function M.install_dependencies()
  local options = {
    "mvn clean install",
    "mvn clean compile",
    "mvn dependency:resolve",
    "mvn clean install -DskipTests",
    "mvn clean package",
    "mvn clean test"
  }
  
  vim.ui.select(options, {
    prompt = "Selecione o comando Maven:",
  }, function(choice)
    if choice then
      vim.cmd("term " .. choice)
    end
  end)
end

function M.quick_debug_attach()
  local dap = require("dap")
  local env_vars = require("resources.utils").load_env_files()
  local port = tonumber(env_vars.DEBUG_PORT) or 5005
  
  dap.run({
    type = 'java',
    request = 'attach',
    name = "Quick Debug Attach",
    hostName = "127.0.0.1",
    port = port,
  })
end

function M.restart_spring_boot()
  -- Mata processos Java existentes relacionados ao Spring Boot
  vim.ui.select({"Sim", "Não"}, {
    prompt = "Reiniciar Spring Boot? (Isso irá matar processos Java ativos)",
  }, function(choice)
    if choice == "Sim" then
      -- No Windows, usar taskkill para matar processos Java
      if utils.os().IS_WINDOWS then
        vim.cmd("!taskkill /F /IM java.exe")
      else
        vim.cmd("!pkill -f 'spring-boot'")
      end
      
      -- Aguardar um pouco e iniciar novamente
      vim.defer_fn(function()
        require("config.dap.spring-boot").run_spring_boot_quick(false)
      end, 2000)
    end
  end)
end

-- Comandos úteis
vim.api.nvim_create_user_command("DevTools", show_dev_menu, { desc = "Abrir menu de ferramentas de desenvolvimento" })

vim.api.nvim_create_user_command("DevStatus", function()
  M.show_project_status()
end, { desc = "Mostrar status do projeto" })

vim.api.nvim_create_user_command("DevEnv", function()
  M.configure_env_vars()
end, { desc = "Configurar variáveis de ambiente" })

vim.api.nvim_create_user_command("DevDebugAttach", function()
  M.quick_debug_attach()
end, { desc = "Debug attach rápido" })

vim.api.nvim_create_user_command("DevRestart", function()
  M.restart_spring_boot()
end, { desc = "Reiniciar Spring Boot" })

-- Mapeamentos principais
vim.keymap.set("n", "<leader>dt", show_dev_menu, { desc = "Dev Tools: Menu principal" })
vim.keymap.set("n", "<leader>ds", M.show_project_status, { desc = "Dev Tools: Status do projeto" })
vim.keymap.set("n", "<leader>de", M.configure_env_vars, { desc = "Dev Tools: Configurar .env" })
vim.keymap.set("n", "<leader>da", M.quick_debug_attach, { desc = "Dev Tools: Debug attach rápido" })
vim.keymap.set("n", "<leader>dr", M.restart_spring_boot, { desc = "Dev Tools: Reiniciar Spring Boot" })

return M
