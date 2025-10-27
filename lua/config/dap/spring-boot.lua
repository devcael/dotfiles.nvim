local utils = require("resources.utils")

local M = {}

local function get_available_java_versions()
  -- Reutilizar a função do jdtls.lua
  local jdtls = require("config.lsp.servers.jdtls")
  return jdtls.get_available_java_versions and jdtls.get_available_java_versions() or {}
end

local function get_spring_boot_runner(options)
  options = options or {}
  local profile = options.profile or "dev"
  local debug = options.debug or false
  local java_path = options.java_path or "java"
  local memory = options.memory or "512m"
  local additional_args = options.additional_args or ""
  
  local env_vars = utils.format_env_vars(utils.load_env_files()) .. " "

  local debug_param = ""
  if debug then
    debug_param = ' -Dspring-boot.run.jvmArguments="-Xmx' .. memory .. ' -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005" '
  else
    debug_param = ' -Dspring-boot.run.jvmArguments="-Xmx' .. memory .. '" '
  end
  
  local profile_param = ""
  if profile then
    profile_param = " -Dspring-boot.run.profiles=" .. profile .. " "
  end
  
  local java_home_param = ""
  if java_path ~= "java" then
    local java_home = java_path:gsub("/bin/java.*", "")
    java_home_param = "set JAVA_HOME=" .. java_home .. " && "
  end
  
  return java_home_param .. env_vars .. 'mvn spring-boot:run ' .. profile_param .. debug_param .. additional_args
end

function M.run_spring_boot_interactive()
  local profiles = utils.get_spring_profiles()
  local java_versions = get_available_java_versions()
  
  vim.ui.select(profiles, {
    prompt = "Selecione o perfil Spring:",
  }, function(profile)
    if not profile then return end
    
    local java_items = {}
    for i, version in ipairs(java_versions) do
      table.insert(java_items, string.format("%d. %s", i, version.name))
    end
    
    vim.ui.select(java_items, {
      prompt = "Selecione a versão do Java:",
    }, function(java_choice, java_idx)
      if not java_choice or not java_idx then return end
      
      vim.ui.select({"Normal", "Debug"}, {
        prompt = "Modo de execução:",
      }, function(mode)
        if not mode then return end
        
        local options = {
          profile = profile,
          debug = mode == "Debug",
          java_path = java_versions[java_idx].path
        }
        
        local cmd = get_spring_boot_runner(options)
        vim.notify("Executando: " .. cmd)
        vim.cmd('term ' .. cmd)
      end)
    end)
  end)
end

function M.run_spring_boot_quick(debug)
  local env_vars = utils.load_env_files()
  local profile = env_vars.SPRING_PROFILES_ACTIVE or "dev"
  
  local options = {
    profile = profile,
    debug = debug or false
  }
  
  local cmd = get_spring_boot_runner(options)
  vim.cmd('term ' .. cmd)
end

function M.create_launch_json()
  local env_vars = utils.load_env_files()
  local java_versions = get_available_java_versions()
  local main_class = utils.find_main_class()
  
  local launch_config = {
    version = "0.2.0",
    configurations = {}
  }
  
  table.insert(launch_config.configurations, {
    type = "java",
    name = "Debug (Attach) - Spring Boot",
    request = "attach",
    hostName = "localhost",
    port = 5005,
    projectName = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  })
  
  for _, version in ipairs(java_versions) do
    table.insert(launch_config.configurations, {
      type = "java",
      name = "Launch Spring Boot (" .. version.version .. ")",
      request = "launch",
      mainClass = main_class,
      projectName = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
      javaExec = version.path,
      env = env_vars,
      args = "-Dspring.profiles.active=dev"
    })
  end
  
  local vscode_dir = vim.fn.getcwd() .. "/.vscode"
  if vim.fn.isdirectory(vscode_dir) == 0 then
    vim.fn.mkdir(vscode_dir, "p")
  end
  
  local launch_file = vscode_dir .. "/launch.json"
  local file = io.open(launch_file, "w")
  if file then
    file:write(vim.json.encode(launch_config))
    file:close()
    vim.notify("Criado: " .. launch_file)
  end
end

vim.api.nvim_create_user_command("SpringBootRun", function()
  M.run_spring_boot_interactive()
end, { desc = "Executar Spring Boot interativamente" })

vim.api.nvim_create_user_command("SpringBootQuick", function()
  M.run_spring_boot_quick(false)
end, { desc = "Executar Spring Boot rapidamente" })

vim.api.nvim_create_user_command("SpringBootDebug", function()
  M.run_spring_boot_quick(true)
end, { desc = "Executar Spring Boot em modo debug" })

vim.api.nvim_create_user_command("SpringBootLaunchJson", function()
  M.create_launch_json()
end, { desc = "Criar launch.json para Spring Boot" })

vim.keymap.set("n", "<F9>", M.run_spring_boot_interactive, { desc = "Spring Boot: Execução interativa" })
vim.keymap.set("n", "<C-F9>", function() M.run_spring_boot_quick(false) end, { desc = "Spring Boot: Execução rápida" })
vim.keymap.set("n", "<C-F12>", function() M.run_spring_boot_quick(true) end, { desc = "Spring Boot: Debug rápido" })

return M

