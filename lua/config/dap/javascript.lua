local M = {}

function M.setup()
  local dap = require("dap")

  dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
  }

  dap.adapters.chrome = {
    type = "executable",
    command = "node",
    args = { vim.fn.stdpath("data") .. "/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js" }
  }

  dap.configurations.javascript = {
    {
      name = "Launch Node",
      type = "node2",
      request = "launch",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
    },
    {
      name = "Attach to Node",
      type = "node2",
      request = "attach",
      processId = require('dap.utils').pick_process,
    },

  }

  dap.configurations.typescript = dap.configurations.javascript

  dap.configurations.vue = dap.configurations.javascript
end

return M
