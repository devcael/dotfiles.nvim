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

local lsp_zero = require('lsp-zero')

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

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  snippet = {
    expand = function(args)
      require 'luasnip'.lsp_expand(args.body)
    end
  },
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
  },
  window = {
    completion = cmp.config.window.bordered({
      border = 'rounded'
    })
  },
  formatting = lsp_zero.cmp_format(),
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<enter>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})

vim.diagnostic.config({
  underline = false,
  virtual_text = false,
  virtual_lines = false,
  signs = false,
  update_in_insert = false,
})

require('lspconfig').clangd.setup({
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

require 'lspconfig'.lua_ls.setup {}

require('lspconfig').pyright.setup {
  settings = {
    python = {
      analysis = {
        errors = {},
      },
    },
  },
}
