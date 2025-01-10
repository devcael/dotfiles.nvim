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
    'ts_ls',
    'vimls',
    'volar',
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

function setupDartLs()
  local dartls = require("lspconfig").dartls
  dartls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
    filetypes = { "dart" },
    root_dir = util.root_pattern("pubspec.yaml", "analysis_options.yaml"),
    init_options = {
      closingLabels = true,
      flutterOutline = true,
      onlyAnalyzeProjectsWithOpenFiles = true,
      suggestFromUnimportedLibraries = false,
    },
  })
end

require("mason-lspconfig").setup_handlers {
  function(server_name)
    lspconfig[server_name].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      handlers = handlers,
    }

    setupDartLs()
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
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = util.root_pattern 'package.json',
      init_options = {
        hostInfo = "neovim",
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = require("config.lsp.servers.tsserver").get_vue_lib_path(),
            languages = { "vue" }
          },
        },
      },
      filetypes = {
        "javascript",
        "typescript",
        "vue",
        "jsx",
        "tsx",
        'typescript',
        'javascript',
        'javascriptreact',
        'typescriptreact'
      },
    })
  end,

  ["volar"] = function()
    lspconfig.volar.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { 'vue', 'json' },
      root_dir = util.root_pattern 'package.json',
      init_options = {
        typescript = {
          tsdk = require("config.lsp.servers.tsserver").get_tsdk()
        },
      }
    })
  end,
}
