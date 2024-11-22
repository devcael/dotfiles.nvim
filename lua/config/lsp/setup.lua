-- Setup installer & lsp configs
local mason_ok, mason = pcall(require, "mason")
local mason_lsp_ok, mason_lsp = pcall(require, "mason-lspconfig")

local util = require 'lspconfig.util'

if not mason_ok or not mason_lsp_ok then
  return
end

mason.setup({
  ui = {
    border = "rounded",
  },
})

mason_lsp.setup({
  ensure_installed = {
    'vimls',
    'volar',
    'gopls',
    'volar',
    "lua_ls",
    "html",
    "cssls",
    "clangd"
  },
  automatic_installation = true,
})

local lspconfig = require("lspconfig")

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    silent = true,
    border = true
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = true }),
}

local on_attach = require("config.lsp.commom").on_attach
local capabilities = require("config.lsp.commom").capabilities


require("mason-lspconfig").setup_handlers {
  function(server_name)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      handlers = handlers,
    }
  end,

  ["lua_ls"] = function()
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      handlers = handlers,
      on_attach = on_attach,
      settings = require("config.lsp.servers.lua_ls").settings,
    })
  end,

  ["ts_ls"] = function()
    lspconfig.ts_ls.setup({
      handlers = require("config.lsp.servers.tsserver").handlers,
      capabilities = capabilities,
      on_attach = require("config.lsp.servers.tsserver").on_attach,
      root_dir = vim.loop.cwd,
      init_options = {
        hostInfo = "neovim",
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = require("config.lsp.servers.tsserver").get_vue_lib_path,
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
  end,

  ["volar"] = function()
    lspconfig.volar.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
      root_dir = util.root_pattern 'package.json',
      init_options = {
        typescript = {
          tsdk = require("config.lsp.servers.tsserver").get_vue_lib_path
        },
      }
    })
  end,

}
