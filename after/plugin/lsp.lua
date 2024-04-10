require("neoconf").setup({})

local lsp_zero = require('lsp-zero')

local on_attach = require("config.lsp_config").on_attach
local capabilities = require("config.lsp_config").capabilities
local util = require "lspconfig/util"
local lspconfig = require("lspconfig")

vim.diagnostic.config({
  underline = false,
  virtual_text = false,
  virtual_lines = false,
  signs = false,
  update_in_insert = false,
})

require("nvim-lsp-installer").setup({
  automatic_installation = true,
  log_level = "error",
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
})

require('mason').setup({
})

require('mason-lspconfig').setup({
  ensure_installed = {
    'jdtls',
    'gopls',
    'clangd',
    "lua_ls",
    "eslint",
    "html",
    "jsonls",
    "tsserver",
    'volar',
    'rust_analyzer'
  },
  handlers = {
    lsp_zero.default_setup,
    jdtls = lsp_zero.noop,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  }
})

require("mason-lspconfig").setup_handlers({
  function (server_name)
    local server_config = {}
    if require("neoconf").get(server_name .. ".disable") then
      return
    end
    if server_name == 'volar' then
      server_config.filetypes = { "vue", "javascript", "typescript" }
    end
    lspconfig[server_name].setup(server_config)
  end
})

lspconfig.volar.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "vue", "javascript", "typescript" },
 })

lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"rust"},
  root_dir = util.root_pattern("Cargo.toml"),
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
      }
    }
  }
})

lspconfig.clangd.setup({
  cmd = {
    "clangd"
  },
  filetypes = {
    "c", "cpp", "objc", "objcpp", "cuda", "proto"
  },
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { 'utf-8', 'utf-16' },
  },
})

lspconfig.lua_ls.setup {}

lspconfig.pyright.setup {
  settings = {
    python = {
      analysis = {
        errors = {},
      },
    },
  },
}
