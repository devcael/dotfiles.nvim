local M = {}

local function show_dev_menu()
  local utils = require("resources.utils")
  local is_flutter = utils.is_flutter_project()
  local is_java = vim.loop.fs_stat("pom.xml") or vim.loop.fs_stat("build.gradle") or vim.loop.fs_stat("build.gradle.kts")
  
  local options = {}
  
  if is_flutter then
    options = {
      "🚀 Executar Flutter",
      "🐛 Debug Flutter", 
      "📱 Selecionar Dispositivo Flutter",
      "🔥 Hot Reload",
      "♻️  Hot Restart",
      "🏗️  Build Flutter",
      "🧹 Flutter Clean",
      "📦 Flutter Pub Get",
      "🧪 Executar Testes Flutter",
      "📝 Criar launch.json Flutter",
      "🔧 Configurar Variáveis de Ambiente",
      "📊 Mostrar Status do Projeto"
    }
  elseif is_java then
    options = {
      "🚀 Executar Spring Boot",
      "🐛 Debug Spring Boot",
      "☕ Selecionar Java Version",
      "📝 Criar launch.json",
      "🔧 Configurar Variáveis de Ambiente",
      "📊 Mostrar Status do Projeto",
      "🧹 Limpar Cache Maven",
      "📦 Instalar Dependências"
    }
  else
    options = {
      "🔧 Configurar Variáveis de Ambiente",
      "📊 Mostrar Status do Projeto",
      "📝 Detectar Tipo de Projeto"
    }
  end
  
  vim.ui.select(options, {
    prompt = "🛠️  Ferramentas de Desenvolvimento:",
  }, function(choice, idx)
    if not choice then return end
    
    if is_flutter then
      M.handle_flutter_menu_choice(choice, idx)
    elseif is_java then
      M.handle_java_menu_choice(choice, idx)
    else
      M.handle_generic_menu_choice(choice, idx)
    end
  end)
end

function M.handle_flutter_menu_choice(choice, idx)
  if idx == 1 then
    require("config.dap.flutter-runner").run_flutter_interactive()
  elseif idx == 2 then
    M.flutter_debug()
  elseif idx == 3 then
    require("resources.utils").select_flutter_device()
  elseif idx == 4 then
    require("config.dap.flutter-runner").flutter_hot_reload()
  elseif idx == 5 then
    require("config.dap.flutter-runner").flutter_hot_restart()
  elseif idx == 6 then
    require("config.dap.flutter-runner").flutter_build()
  elseif idx == 7 then
    require("config.dap.flutter-runner").flutter_clean()
  elseif idx == 8 then
    require("config.dap.flutter-runner").flutter_pub_get()
  elseif idx == 9 then
    require("config.dap.flutter-runner").flutter_test()
  elseif idx == 10 then
    require("config.dap.flutter-runner").create_flutter_launch_json()
  elseif idx == 11 then
    M.configure_env_vars()
  elseif idx == 12 then
    M.show_project_status()
  end
end

function M.handle_java_menu_choice(choice, idx)
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
end

function M.handle_generic_menu_choice(choice, idx)
  if idx == 1 then
    M.configure_env_vars()
  elseif idx == 2 then
    M.show_project_status()
  elseif idx == 3 then
    M.detect_project_type()
  end
end

function M.configure_env_vars()
  local utils = require("resources.utils")
  local env_file = ".env"
  
  if vim.loop.fs_stat(env_file) then
    vim.cmd("edit " .. env_file)
  else
    local template
    
    if utils.is_flutter_project() then
      template = utils.create_flutter_env_template()
    else
      template = [[
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
    end
    
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
  }
  
  if utils.is_flutter_project() then
    table.insert(status, "📱 Tipo: Projeto Flutter")
    table.insert(status, "🎯 Dispositivo: " .. (cache_vars.selected_flutter_device and cache_vars.selected_flutter_device.name or "Não selecionado"))
    table.insert(status, "🏷️  Flavor: " .. (env_vars.FLUTTER_FLAVOR or "development"))
    table.insert(status, "🔌 Porta Web: " .. (env_vars.FLUTTER_WEB_PORT or "3000"))
    table.insert(status, "🐛 Porta Debug: " .. (env_vars.DART_DEBUG_PORT or "8181"))
  elseif vim.loop.fs_stat("pom.xml") or vim.loop.fs_stat("build.gradle") then
    table.insert(status, "☕ Tipo: Projeto Java")
    table.insert(status, "☕ Java Ativo: " .. (cache_vars.selected_java or "Padrão do sistema"))
    table.insert(status, "🏷️  Perfil Spring: " .. (env_vars.SPRING_PROFILES_ACTIVE or "dev"))
    table.insert(status, "🔌 Porta Server: " .. (env_vars.SERVER_PORT or "8080"))
    table.insert(status, "🐛 Porta Debug: " .. (env_vars.DEBUG_PORT or "5005"))
    table.insert(status, "💾 Banco de Dados: " .. (env_vars.DB_HOST or "localhost") .. ":" .. (env_vars.DB_PORT or "5432"))
  else
    table.insert(status, "❓ Tipo: Projeto genérico")
  end
  
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

function M.flutter_debug()
  local utils = require("resources.utils")
  if not utils.is_flutter_project() then
    vim.notify("Este não é um projeto Flutter!", vim.log.levels.ERROR)
    return
  end
  
  -- Iniciar Flutter em modo debug e depois conectar o debugger
  require("config.dap.flutter-runner").run_flutter_quick("debug")
  
  -- Aguardar um pouco e tentar conectar o debugger
  vim.defer_fn(function()
    local dap = require("dap")
    dap.run({
      type = "dart",
      request = "attach",
      name = "Flutter Debug Attach"
    })
  end, 3000) -- 3 segundos de delay
end

function M.detect_project_type()
  local utils = require("resources.utils")
  local project_info = {}
  
  if utils.is_flutter_project() then
    table.insert(project_info, "📱 Projeto Flutter detectado")
  end
  
  if utils.is_dart_project() then
    table.insert(project_info, "🎯 Projeto Dart detectado")
  end
  
  if vim.loop.fs_stat("pom.xml") then
    table.insert(project_info, "☕ Projeto Maven detectado")
  end
  
  if vim.loop.fs_stat("build.gradle") or vim.loop.fs_stat("build.gradle.kts") then
    table.insert(project_info, "🐘 Projeto Gradle detectado")
  end
  
  if vim.loop.fs_stat("package.json") then
    table.insert(project_info, "📦 Projeto Node.js detectado")
  end
  
  if vim.loop.fs_stat("Cargo.toml") then
    table.insert(project_info, "🦀 Projeto Rust detectado")
  end
  
  if vim.loop.fs_stat("go.mod") then
    table.insert(project_info, "🐹 Projeto Go detectado")
  end
  
  if #project_info == 0 then
    table.insert(project_info, "❓ Tipo de projeto não identificado")
  end
  
  vim.notify(table.concat(project_info, "\n"), vim.log.levels.INFO)
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
