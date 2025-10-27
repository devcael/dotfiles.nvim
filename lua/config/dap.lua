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
          { id = "scopes", size = 0.5 },
        },
        size = 40,
        position = "left",
      },
      {
        elements = {
          { id = "repl", size = 0.5 },
          { id = "console", size = 0.5 },
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
    controls = {
      enabled = true,
      element = "repl",
      icons = {
        pause = "",
        play = "",
        step_into = "",
        step_over = "",
        step_out = "",
        step_back = "",
        run_last = "",
        terminate = "",
      },
    },
  })

  dap.listeners.after.event_initialized["dapui_config"] = function()
    for _, buf in pairs(vim.api.nvim_list_bufs()) do
      local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
      if filetype == "dapui_scopes" then
        return
      end
    end
    dapui.open({ layout = 1, elements = { "scopes" } })
  end
  
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  require("config.dap.javascript").setup()  
  require("config.dap.java").setup()
  require("config.dap.dart").setup()
  require("config.dap.spring-boot")
  require("config.dap.flutter-runner")
  require("config.dap.go")

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
  
  vim.keymap.set("n", "<leader>dss", function() dapui.float_element("scopes", { enter = true }) end, { desc = "Debug: Mostrar escopo de variáveis", silent = true })
  vim.keymap.set("n", "<leader>dsw", function() dapui.float_element("watches", { enter = true }) end, { desc = "Debug: Mostrar watches", silent = true })
  vim.keymap.set("n", "<leader>dsb", function() dapui.float_element("breakpoints", { enter = true }) end, { desc = "Debug: Mostrar breakpoints", silent = true })
  vim.keymap.set("n", "<leader>dst", function() dapui.float_element("stacks", { enter = true }) end, { desc = "Debug: Mostrar pilha de chamadas", silent = true })
  vim.keymap.set("n", "<leader>dsc", function() dapui.float_element("console", { enter = true }) end, { desc = "Debug: Mostrar console", silent = true })
  
  vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "Debug: Alternar UI completa", silent = true })
end

return M
