local M = {}

function M.setup()
  local dap = require("dap")
  local dapui = require("dapui")

  dapui.setup({
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = {
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    layouts = {
      {
        elements = {
          "scopes",
          "breakpoints",
          "stacks",
          "watches",
        },
        size = 40,
        position = "left",
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 10,
        position = "bottom",
      },
    },
    floating = {
      max_height = nil,
      max_width = nil,
      border = "single",
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    windows = { indent = 1 },
    render = {
      max_type_length = nil,
    },
  })

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  require("config.dap.javascript").setup()

  vim.keymap.set("n", "<F5>", function() dap.continue() end, { silent = true })
  vim.keymap.set("n", "<F10>", function() dap.step_over() end, { silent = true })
  vim.keymap.set("n", "<F11>", function() dap.step_into() end, { silent = true })
  vim.keymap.set("n", "<F12>", function() dap.step_out() end, { silent = true })
  vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { silent = true })
  vim.keymap.set("n", "<leader>dB", function()
    dap.set_breakpoint(vim.fn.input("Condição de breakpoint: "))
  end, { silent = true })
  vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, { silent = true })
  vim.keymap.set("n", "<leader>dl", function() dap.run_last() end, { silent = true })
  vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { silent = true })
end

return M
