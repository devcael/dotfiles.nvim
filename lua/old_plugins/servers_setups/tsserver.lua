local capabilities = require("cmp_nvim_lsp").default_capabilities()
local rs_util = require("resources.utils")
local util = require 'lspconfig.util'
local lsp_config = require 'plugins.lsp_config'

local nd_version = "v22.0.0"
local vuelib_path = rs_util.get_home_path() .. "/.local/share/nvm/" .. nd_version .. "/lib/node_modules/@vue/typescript-plugin"
local tslib_path = rs_util.get_home_path() .. "/.local/share/nvm/" .. nd_version .. "/lib/node_modules/typescript/lib"

require 'lspconfig'.ts_ls.setup({
  on_attach = lsp_config.on_attach,
  capabilities = capabilities,
  root_dir = vim.loop.cwd,
  init_options = {
    hostInfo = "neovim",
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vuelib_path,
        languages = { "vue" }
      },
    },
  },
  filetypes = {
    "javascript",
    "typescript",
    "vue",
    "jsx",
    "tsx"
  },
})




require "lspconfig".volar.setup({
  on_attach = lsp_config.on_attach,
  capabilities = capabilities,
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
  root_dir = util.root_pattern 'package.json',
  init_options = {
    typescript = {
      tsdk = tslib_path
      -- Alternative location if is  instaled as root
      -- tsdk = '/usr/local/lib/node_modules/typescript/lib'
    },
  }
})
