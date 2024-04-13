local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require 'lspconfig'
local util = require 'lspconfig.util'

require 'lspconfig'.tsserver.setup({
  -- on_attach = on_attach,
  capabilities = capabilities,
  root_dir = vim.loop.cwd,
  init_options = {
    hostInfo = "neovim",
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/home/devcael/.local/share/nvm/v21.7.2/lib/node_modules/@vue/typescript-plugin",
        languages = { "vue" }
      },
    },
  },
  filetypes = {
    "javascript",
    "typescript",
    "vue"
  },
})



local tslib_path = "/home/devcael/.local/share/nvm/v21.7.2/lib/node_modules/typescript/lib"

require "lspconfig".volar.setup({
  -- on_attach = on_attach,
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
