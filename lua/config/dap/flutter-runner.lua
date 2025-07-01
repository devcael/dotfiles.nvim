local utils = require("resources.utils")

local M = {}

local function get_flutter_runner(options)
  options = options or {}
  local mode = options.mode or "debug"
  local target = options.target or utils.find_flutter_main_file()
  local device_id = options.device_id or "chrome"
  local flavor = options.flavor or "development"
  local additional_args = options.additional_args or ""
  local port = options.port or "8080"
  
  local env_vars = utils.format_env_vars(utils.load_env_files()) .. " "
  
  local mode_param = ""
  if mode == "release" then
    mode_param = " --release "
  elseif mode == "profile" then
    mode_param = " --profile "
  else
    mode_param = " --debug "
  end
  
  local target_param = " -t " .. target .. " "
  local device_param = " -d " .. device_id .. " "
  local flavor_param = ""
  
  if flavor and flavor ~= "development" then
    flavor_param = " --flavor " .. flavor .. " "
  end
  
  local web_params = ""
  if device_id == "chrome" then
    web_params = " --web-port " .. port .. " --web-hostname localhost "
  end
  
  return env_vars .. "flutter run " .. mode_param .. target_param .. device_param .. flavor_param .. web_params .. additional_args
end

function M.run_flutter_interactive()
  if not utils.is_flutter_project() then
    vim.notify("Este não é um projeto Flutter!", vim.log.levels.ERROR)
    return
  end
  
  local devices = utils.get_flutter_devices()
  local flavors = utils.get_flutter_flavors()
  
  -- Selecionar dispositivo
  local device_items = {}
  for i, device in ipairs(devices) do
    local icon = device.emulator and "📱" or "🔗"
    local status = device.category == "web" and "🌐" or device.category == "mobile" and "📱" or "💻"
    table.insert(device_items, string.format("%d. %s %s %s", i, icon, status, device.name))
  end
  
  vim.ui.select(device_items, {
    prompt = "Selecione o dispositivo:",
  }, function(device_choice, device_idx)
    if not device_choice or not device_idx then return end
    
    -- Selecionar flavor
    vim.ui.select(flavors, {
      prompt = "Selecione o flavor:",
    }, function(flavor)
      if not flavor then return end
      
      -- Selecionar modo
      vim.ui.select({"Debug", "Release", "Profile"}, {
        prompt = "Modo de compilação:",
      }, function(mode_choice)
        if not mode_choice then return end
        
        local options = {
          mode = mode_choice:lower(),
          device_id = devices[device_idx].id,
          flavor = flavor
        }
        
        local cmd = get_flutter_runner(options)
        vim.notify("Executando: " .. cmd)
        vim.cmd('term ' .. cmd)
      end)
    end)
  end)
end

function M.run_flutter_quick(mode)
  if not utils.is_flutter_project() then
    vim.notify("Este não é um projeto Flutter!", vim.log.levels.ERROR)
    return
  end
  
  local env_vars = utils.load_env_files()
  local device_id = env_vars.FLUTTER_DEVICE_ID or cache_vars.selected_flutter_device and cache_vars.selected_flutter_device.id or "chrome"
  local flavor = env_vars.FLUTTER_FLAVOR or "development"
  
  local options = {
    mode = mode or "debug",
    device_id = device_id,
    flavor = flavor
  }
  
  local cmd = get_flutter_runner(options)
  vim.cmd('term ' .. cmd)
end

function M.flutter_hot_reload()
  -- Enviar comando hot reload para o terminal ativo
  local current_buf = vim.api.nvim_get_current_buf()
  local buf_type = vim.api.nvim_buf_get_option(current_buf, "buftype")
  
  if buf_type == "terminal" then
    vim.api.nvim_feedkeys("r", "n", false)
    vim.notify("Hot Reload enviado!")
  else
    vim.notify("Abra um terminal com Flutter running primeiro!", vim.log.levels.WARN)
  end
end

function M.flutter_hot_restart()
  -- Enviar comando hot restart para o terminal ativo
  local current_buf = vim.api.nvim_get_current_buf()
  local buf_type = vim.api.nvim_buf_get_option(current_buf, "buftype")
  
  if buf_type == "terminal" then
    vim.api.nvim_feedkeys("R", "n", false)
    vim.notify("Hot Restart enviado!")
  else
    vim.notify("Abra um terminal com Flutter running primeiro!", vim.log.levels.WARN)
  end
end

function M.flutter_build()
  if not utils.is_flutter_project() then
    vim.notify("Este não é um projeto Flutter!", vim.log.levels.ERROR)
    return
  end
  
  local build_targets = {
    "apk",
    "appbundle", 
    "ios",
    "web",
    "windows",
    "linux",
    "macos"
  }
  
  vim.ui.select(build_targets, {
    prompt = "Selecione o target de build:",
  }, function(target)
    if not target then return end
    
    vim.ui.select({"Debug", "Release", "Profile"}, {
      prompt = "Modo de build:",
    }, function(mode)
      if not mode then return end
      
      local mode_flag = mode == "Release" and "--release" or mode == "Profile" and "--profile" or "--debug"
      local cmd = "flutter build " .. target .. " " .. mode_flag
      
      vim.notify("Executando: " .. cmd)
      vim.cmd('term ' .. cmd)
    end)
  end)
end

function M.flutter_clean()
  if not utils.is_flutter_project() then
    vim.notify("Este não é um projeto Flutter!", vim.log.levels.ERROR)
    return
  end
  
  vim.ui.select({"Sim", "Não"}, {
    prompt = "Limpar projeto Flutter? (flutter clean + pub get)",
  }, function(choice)
    if choice == "Sim" then
      vim.cmd("term flutter clean && flutter pub get")
    end
  end)
end

function M.flutter_pub_get()
  if not utils.is_dart_project() then
    vim.notify("Este não é um projeto Dart/Flutter!", vim.log.levels.ERROR)
    return
  end
  
  vim.cmd("term flutter pub get")
end

function M.flutter_pub_upgrade()
  if not utils.is_dart_project() then
    vim.notify("Este não é um projeto Dart/Flutter!", vim.log.levels.ERROR)
    return
  end
  
  vim.cmd("term flutter pub upgrade")
end

function M.flutter_test()
  if not utils.is_dart_project() then
    vim.notify("Este não é um projeto Dart/Flutter!", vim.log.levels.ERROR)
    return
  end
  
  local test_options = {
    "flutter test",
    "flutter test --coverage",
    "dart test",
    "flutter test integration_test/"
  }
  
  vim.ui.select(test_options, {
    prompt = "Selecione o tipo de teste:",
  }, function(choice)
    if choice then
      vim.cmd("term " .. choice)
    end
  end)
end

function M.create_flutter_launch_json()
  if not utils.is_flutter_project() then
    vim.notify("Este não é um projeto Flutter!", vim.log.levels.ERROR)
    return
  end
  
  local env_vars = utils.load_env_files()
  local devices = utils.get_flutter_devices()
  local flavors = utils.get_flutter_flavors()
  
  local launch_config = {
    version = "0.2.0",
    configurations = {}
  }
  
  -- Configuração básica
  table.insert(launch_config.configurations, {
    name = "Flutter: Launch",
    type = "dart",
    request = "launch",
    program = utils.find_flutter_main_file(),
    args = {},
    env = env_vars
  })
  
  -- Configurações por dispositivo
  for _, device in ipairs(devices) do
    table.insert(launch_config.configurations, {
      name = "Flutter: " .. device.name,
      type = "dart", 
      request = "launch",
      program = utils.find_flutter_main_file(),
      deviceId = device.id,
      args = {},
      env = env_vars
    })
  end
  
  -- Configurações por flavor
  for _, flavor in ipairs(flavors) do
    table.insert(launch_config.configurations, {
      name = "Flutter: " .. flavor,
      type = "dart",
      request = "launch", 
      program = utils.find_flutter_main_file(),
      args = {"--flavor", flavor},
      env = vim.tbl_extend("force", env_vars, {FLUTTER_FLAVOR = flavor})
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

-- Comandos úteis
vim.api.nvim_create_user_command("FlutterRun", function()
  M.run_flutter_interactive()
end, { desc = "Executar Flutter interativamente" })

vim.api.nvim_create_user_command("FlutterQuick", function()
  M.run_flutter_quick("debug")
end, { desc = "Executar Flutter rapidamente" })

vim.api.nvim_create_user_command("FlutterRelease", function()
  M.run_flutter_quick("release")
end, { desc = "Executar Flutter em modo release" })

vim.api.nvim_create_user_command("FlutterHotReload", function()
  M.flutter_hot_reload()
end, { desc = "Flutter Hot Reload" })

vim.api.nvim_create_user_command("FlutterHotRestart", function()
  M.flutter_hot_restart()
end, { desc = "Flutter Hot Restart" })

vim.api.nvim_create_user_command("FlutterBuild", function()
  M.flutter_build()
end, { desc = "Build Flutter" })

vim.api.nvim_create_user_command("FlutterClean", function()
  M.flutter_clean()
end, { desc = "Limpar projeto Flutter" })

vim.api.nvim_create_user_command("FlutterPubGet", function()
  M.flutter_pub_get()
end, { desc = "Flutter pub get" })

vim.api.nvim_create_user_command("FlutterTest", function()
  M.flutter_test()
end, { desc = "Executar testes Flutter" })

vim.api.nvim_create_user_command("FlutterLaunchJson", function()
  M.create_flutter_launch_json()
end, { desc = "Criar launch.json para Flutter" })

-- Mapeamentos
vim.keymap.set("n", "<F8>", M.run_flutter_interactive, { desc = "Flutter: Execução interativa" })
vim.keymap.set("n", "<C-F8>", function() M.run_flutter_quick("debug") end, { desc = "Flutter: Execução rápida" })
vim.keymap.set("n", "<leader>fr", M.flutter_hot_reload, { desc = "Flutter: Hot Reload" })
vim.keymap.set("n", "<leader>fR", M.flutter_hot_restart, { desc = "Flutter: Hot Restart" })
vim.keymap.set("n", "<leader>fb", M.flutter_build, { desc = "Flutter: Build" })
vim.keymap.set("n", "<leader>fc", M.flutter_clean, { desc = "Flutter: Clean" })
vim.keymap.set("n", "<leader>fp", M.flutter_pub_get, { desc = "Flutter: Pub get" })
vim.keymap.set("n", "<leader>ft", M.flutter_test, { desc = "Flutter: Test" })

return M
