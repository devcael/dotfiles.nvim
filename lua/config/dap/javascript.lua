local M = {}

function M.setup()
  local dap = require("dap")
  
  local has_node = vim.fn.executable("node") == 1
  if not has_node then
    vim.notify("Node.js não encontrado! Instalação necessária para debug JS/TS", vim.log.levels.ERROR)
    return
  end
  
  dap.adapters.chrome = {
    type = "executable",
    command = "node",
    args = { vim.fn.stdpath("data") .. "/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js" }
  }
  
  for _, adapterType in ipairs({ "node", "msedge" }) do 
    local pwaType = "pwa-" .. adapterType

    dap.adapters[pwaType] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    dap.adapters[adapterType] = function(cb, config)
      local nativeAdapter = dap.adapters[pwaType]
      config.type = pwaType
      if type(nativeAdapter) == "function" then
        nativeAdapter(cb, config)
      else
        cb(nativeAdapter)
      end
    end
  end

  local enter_launch_url = function()
    local co = coroutine.running()
    return coroutine.create(function()
      vim.ui.input({ prompt = "Enter URL: ", default = "http://localhost:3000" }, function(url)
        if url ~= nil and url ~= "" then
          coroutine.resume(co, url)
        end
      end)
    end)
  end

  for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" }) do
    dap.configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file (Node.js)",
        program = "${file}",
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        protocol = "inspector", 
        console = "integratedTerminal",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach to Node Process",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
      {
        type = "chrome",
        request = "launch",
        name = "Launch Chrome para Vue/Vite",
        url = "http://localhost:5173",
        webRoot = "${workspaceFolder}",
        sourceMaps = true,
        userDataDir = "${workspaceFolder}/.vscode/chrome-debug-profile",
        sourceMapPathOverrides = {
          ["webpack:///./~/*"] = "${webRoot}/node_modules/*",
          ["webpack:///./*"] = "${webRoot}/*",
          ["webpack:///*"] = "*",
          ["*"] = "${webRoot}/*",
        },
      },
      {
        type = "chrome",
        request = "launch",
        name = "Launch Chrome (URL personalizada)",
        url = enter_launch_url,
        webRoot = "${workspaceFolder}",
        sourceMaps = true,
        userDataDir = "${workspaceFolder}/.vscode/chrome-debug-profile",
      },
      {
        type = "chrome",
        request = "launch",
        name = "Launch Chrome para React",
        url = "http://localhost:3000",
        webRoot = "${workspaceFolder}",
        sourceMaps = true,
        disableNetworkCache = true,
        userDataDir = "${workspaceFolder}/.vscode/chrome-debug-profile",
      }
    }
  end

  dap.configurations.vue = dap.configurations.javascript
end

return M
