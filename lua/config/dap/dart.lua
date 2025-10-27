local M = {}

function M.setup()
  local dap = require("dap")
  local utils = require("resources.utils")
  
  -- Configuração do adaptador Dart
  dap.adapters.dart = {
    type = "executable",
    command = "dart",
    args = {"debug_adapter"},
    options = {
      detached = false,
    }
  }
  
  -- Configuração do adaptador Flutter
  dap.adapters.flutter = {
    type = "executable", 
    command = "flutter",
    args = {"debug_adapter"},
    options = {
      detached = false,
    }
  }
  
  -- Configurações básicas para Dart
  dap.configurations.dart = {
    {
      type = "dart",
      request = "launch",
      name = "Launch Dart",
      dartSdkPath = function()
        local handle = io.popen("dart --version 2>&1")
        if handle then
          local result = handle:read("*a")
          handle:close()
          -- Extrair o caminho do Dart SDK se possível
          return nil -- Deixar o DAP detectar automaticamente
        end
        return nil
      end,
      program = function()
        return vim.fn.input("Caminho para main.dart: ", utils.find_flutter_main_file(), "file")
      end,
      cwd = function()
        return vim.fn.getcwd()
      end,
      args = {},
    },
    {
      type = "dart",
      request = "launch", 
      name = "Launch Dart (Current File)",
      program = function()
        return vim.fn.expand("%:p")
      end,
      cwd = function()
        return vim.fn.getcwd()
      end,
    },
    {
      type = "dart",
      request = "launch",
      name = "Launch Dart with Args",
      program = function()
        return vim.fn.input("Caminho para main.dart: ", utils.find_flutter_main_file(), "file")
      end,
      args = function()
        local args_string = vim.fn.input("Argumentos (separados por espaço): ")
        return vim.split(args_string, " ", { trimempty = true })
      end,
      cwd = function()
        return vim.fn.getcwd()
      end,
    }
  }
  
  -- Configurações avançadas para Flutter
  local flutter_configs = {}
  
  -- Configuração básica de Flutter
  table.insert(flutter_configs, {
    type = "flutter",
    request = "launch",
    name = "Launch Flutter",
    program = function()
      return utils.find_flutter_main_file()
    end,
    cwd = function()
      return vim.fn.getcwd()
    end,
    deviceId = function()
      local device = utils.select_flutter_device()
      return device and device.id or "chrome"
    end,
  })
  
  -- Configurações por flavor
  local flavors = utils.get_flutter_flavors()
  for _, flavor in ipairs(flavors) do
    table.insert(flutter_configs, {
      type = "flutter",
      request = "launch", 
      name = "Launch Flutter (" .. flavor .. ")",
      program = function()
        return utils.find_flutter_main_file()
      end,
      cwd = function()
        return vim.fn.getcwd()
      end,
      args = {"--flavor", flavor},
      env = {
        FLUTTER_FLAVOR = flavor
      },
      deviceId = function()
        local device = utils.select_flutter_device()
        return device and device.id or "chrome"
      end,
    })
  end
  
  -- Configuração para Web
  table.insert(flutter_configs, {
    type = "flutter",
    request = "launch",
    name = "Launch Flutter Web",
    program = function()
      return utils.find_flutter_main_file()
    end,
    cwd = function()
      return vim.fn.getcwd()
    end,
    deviceId = "chrome",
    args = {"--web-port", "3000"},
    env = {
      FLUTTER_WEB_PORT = "3000"
    }
  })
  
  -- Configuração para Debug Attach
  table.insert(flutter_configs, {
    type = "flutter",
    request = "attach",
    name = "Flutter Attach",
    deviceId = function()
      local device = utils.select_flutter_device()
      return device and device.id or "chrome"
    end,
  })
  
  dap.configurations.dart = vim.list_extend(dap.configurations.dart or {}, flutter_configs)
end

return M
