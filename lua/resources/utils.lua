local M = {}

-- Cache global para variáveis do sistema
_G.cache_vars = _G.cache_vars or {}

-- Função para obter o caminho do diretório home do usuário
M.get_home_path = function()
  return os.getenv("HOME") or os.getenv("USERPROFILE")
end

-- Outras funções que dependem do Treesitter serão carregadas condicionalmente
local has_treesitter, ts_utils = pcall(require, "nvim-treesitter.ts_utils")

if has_treesitter then
  -- Funções que usam Treesitter
  function find_node_by_type(expr, type_name)
    while expr do
      if expr:type() == type_name then
          break
      end
      expr = expr:parent()
    end
    return expr
  end

  function find_child_by_type(expr, type_name)
    local id = 0
    local expr_child = expr:child(id)
    while expr_child do 
      if expr_child:type() == type_name then
        break
      end
      id = id + 1
      expr_child = expr:child(id)
    end

    return expr_child
  end

  function M.get_current_method_name()
    local current_node = ts_utils.get_node_at_cursor()
    if not current_node then return nil end

    local expr = find_node_by_type(current_node, 'method_declaration')
    if not expr then return nil end

    local child = find_child_by_type(expr, 'identifier')
    if not child then return nil end
    return vim.treesitter.query.get_node_text(child, 0)
  end

  -- Get Current Class Name
  function M.get_current_class_name()
    local current_node = ts_utils.get_node_at_cursor()
    if not current_node then return nil end

    local class_declaration = find_node_by_type(current_node, 'class_declaration')
    if not class_declaration then return nil end
    
    local child = find_child_by_type(class_declaration, 'identifier')
    if not child then return nil end
    return vim.treesitter.query.get_node_text(child, 0)
  end

  function M.get_current_package_name()
    local current_node = ts_utils.get_node_at_cursor()
    if not current_node then return nil end

    local program_expr = find_node_by_type(current_node, 'program')
    if not program_expr then return nil end
    local package_expr = find_child_by_type(program_expr, 'package_declaration')
    if not package_expr then return nil end

    local child = find_child_by_type(package_expr, 'scoped_identifier')
    if not child then return nil end
    return vim.treesitter.query.get_node_text(child, 0)
  end

  function M.get_current_full_class_name()
    local package = M.get_current_package_name()
    local class = M.get_current_class_name()
    return package .. '.' .. class
  end

  function M.get_current_full_method_name(delimiter)
    delimiter = delimiter or '.'
    local full_class_name = M.get_current_full_class_name()
    local method_name = M.get_current_method_name()
    return full_class_name .. delimiter .. method_name
  end
end

function M.os()
  local OSINFO = {}
  local uname = vim.loop.os_uname();
  OSINFO.OS = uname.sysname;
  OSINFO.IS_MAC = OSINFO.OS == 'Darwin'
  OSINFO.IS_LINUX = OSINFO.OS == 'Linux'
  OSINFO.IS_WINDOWS = OSINFO.OS:find 'Windows' and true or false
  OSINFO.IS_WSL = OSINFO.IS_LINUX and uname.release:find 'Microsoft' and true or false
  return OSINFO;
end

function M.load_env_vars(filepath)
  local vars = {}
  local file = io.open(filepath, "r")
  if not file then return vars end

  for line in file:lines() do
    local key, value = line:match("^%s*([%w_]+)%s*=%s*([^\n\r]*)%s*$")
    if key and value then
      -- Remove aspas se existirem
      value = value:gsub([["]], ""):gsub([[\']], "")
      vars[key] = value
    end
  end

  file:close()
  return vars
end

function M.format_env_vars(env_table)
  local parts = {}
  for k, v in pairs(env_table) do
    table.insert(parts, string.format('%s="%s"', k, v))
  end
  return table.concat(parts, " ")
end

-- Novas funções para gerenciamento de .env
function M.load_env_files()
  local env_files = {".env", ".env.local", ".env.development", ".env.production"}
  local combined_vars = {}
  
  for _, file in ipairs(env_files) do
    if vim.loop.fs_stat(file) then
      local vars = M.load_env_vars(file)
      for k, v in pairs(vars) do
        combined_vars[k] = v
      end
      vim.notify("Carregado: " .. file, vim.log.levels.INFO)
    end
  end
  
  return combined_vars
end

function M.get_spring_profiles()
  local profiles = {"dev", "test", "prod", "local"}
  local env_vars = M.load_env_files()
  
  -- Adicionar perfil do .env se existir
  if env_vars.SPRING_PROFILES_ACTIVE then
    table.insert(profiles, 1, env_vars.SPRING_PROFILES_ACTIVE)
  end
  
  return profiles
end

function M.select_spring_profile()
  local profiles = M.get_spring_profiles()
  
  vim.ui.select(profiles, {
    prompt = "Selecione o perfil Spring:",
  }, function(choice)
    if choice then
      cache_vars.selected_profile = choice
      vim.notify("Perfil selecionado: " .. choice)
    end
  end)
  
  return cache_vars.selected_profile or "dev"
end

function M.find_main_class()
  -- Procura pela classe principal do Spring Boot
  local main_class_patterns = {
    ".*Application%.java$",
    ".*App%.java$", 
    ".*Main%.java$"
  }
  
  for _, pattern in ipairs(main_class_patterns) do
    local cmd = string.format('find . -name "%s" -type f', pattern:gsub("%.java$", ".java"))
    local handle = io.popen(cmd)
    if handle then
      local result = handle:read("*a")
      handle:close()
      if result and result ~= "" then
        local file_path = result:gsub("\n", "")
        -- Converter caminho para package.classe
        local package_class = file_path:gsub("^%./src/main/java/", ""):gsub("/", "."):gsub("%.java$", "")
        return package_class
      end
    end
  end
  
  return "com.example.Application" -- fallback
end

-- Funções específicas para Flutter/Dart
function M.is_flutter_project()
  return vim.loop.fs_stat("pubspec.yaml") ~= nil
end

function M.is_dart_project()
  return vim.loop.fs_stat("pubspec.yaml") ~= nil or vim.loop.fs_stat("analysis_options.yaml") ~= nil
end

function M.find_flutter_main_file()
  local main_files = {"lib/main.dart", "bin/main.dart", "web/main.dart"}
  
  for _, file in ipairs(main_files) do
    if vim.loop.fs_stat(file) then
      return file
    end
  end
  
  return "lib/main.dart" -- fallback
end

function M.get_flutter_devices()
  local devices = {}
  local handle = io.popen("flutter devices --machine 2>/dev/null")
  
  if handle then
    local result = handle:read("*a")
    handle:close()
    
    if result and result ~= "" then
      local success, parsed = pcall(vim.json.decode, result)
      if success and parsed then
        for _, device in ipairs(parsed) do
          table.insert(devices, {
            id = device.id,
            name = device.name,
            platform = device.platform,
            category = device.category,
            emulator = device.emulator or false
          })
        end
      end
    end
  end
  
  -- Fallback se não conseguir obter dispositivos
  if #devices == 0 then
    table.insert(devices, {
      id = "chrome",
      name = "Chrome",
      platform = "web-javascript",
      category = "web",
      emulator = false
    })
  end
  
  return devices
end

function M.select_flutter_device()
  local devices = M.get_flutter_devices()
  
  if #devices == 0 then
    vim.notify("Nenhum dispositivo Flutter encontrado!", vim.log.levels.ERROR)
    return nil
  end
  
  local items = {}
  for i, device in ipairs(devices) do
    local icon = device.emulator and "📱" or "🔗"
    local status = device.category == "web" and "🌐" or device.category == "mobile" and "📱" or "💻"
    table.insert(items, string.format("%d. %s %s %s (%s)", i, icon, status, device.name, device.platform))
  end
  
  vim.ui.select(items, {
    prompt = "Selecione o dispositivo Flutter:",
  }, function(choice, idx)
    if choice and idx then
      cache_vars.selected_flutter_device = devices[idx]
      vim.notify("Dispositivo selecionado: " .. devices[idx].name)
    end
  end)
  
  return cache_vars.selected_flutter_device
end

function M.get_flutter_flavors()
  local flavors = {"development", "staging", "production"}
  local env_vars = M.load_env_files()
  
  -- Adicionar flavor do .env se existir
  if env_vars.FLUTTER_FLAVOR then
    table.insert(flavors, 1, env_vars.FLUTTER_FLAVOR)
  end
  
  return flavors
end

function M.get_dart_entry_points()
  local entry_points = {}
  
  -- Procurar por arquivos main.dart
  local main_files = {
    "lib/main.dart",
    "bin/main.dart", 
    "web/main.dart",
    "test/main_test.dart"
  }
  
  for _, file in ipairs(main_files) do
    if vim.loop.fs_stat(file) then
      table.insert(entry_points, file)
    end
  end
  
  return entry_points
end

function M.create_flutter_env_template()
  return [[
# Flutter Configuration
FLUTTER_FLAVOR=development
FLUTTER_TARGET=lib/main.dart

# Build Configuration  
FLUTTER_BUILD_MODE=debug
FLUTTER_OBFUSCATE=false
FLUTTER_SPLIT_DEBUG_INFO=false

# Web Configuration
FLUTTER_WEB_PORT=3000
FLUTTER_WEB_HOSTNAME=localhost

# Android Configuration
ANDROID_DEVICE_ID=
ANDROID_SIGNING_KEY=

# iOS Configuration  
IOS_DEVICE_ID=
IOS_PROVISIONING_PROFILE=

# Debug Configuration
DART_DEBUG_PORT=8181
FLUTTER_DEBUG_PORT=8080

# Development Tools
FLUTTER_INSPECTOR_PORT=9100
]]
end

return M
