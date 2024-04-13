local cmp = require('cmp')


cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered({ border = 'rounded' }),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
    ['<enter>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    })
})
