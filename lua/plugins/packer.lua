vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'preservim/nerdtree'
  use { 'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons' }

  use 'nvim-lua/plenary.nvim' -- Common utilities
  use 'onsails/lspkind-nvim'  -- vscode-like pictograms
  use {
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'rcarriga/cmp-dap'
  }
  use { 'saadparwaiz1/cmp_luasnip' }
  use 'L3MON4D3/LuaSnip'
  use 'windwp/nvim-ts-autotag'
  use { 'numToStr/Comment.nvim',
    requires = {
      'JoosepAlviste/nvim-ts-context-commentstring'
    }
  }

  -- Packer
  use 'wbthomason/packer.nvim'

  -- Look And Feel

  use 'Rigellute/rigel'
  use 'ray-x/aurora'
  use 'adrian5/oceanic-next-vim'
  use({ 'rose-pine/neovim', as = 'rose-pine' })
  use {
    "folke/tokyonight.nvim",
  }

  use { 'catppuccin/nvim', as = 'catppuccin' }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.4'
  }

  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end
  }

  use 'mbbill/undotree'
  use 'ThePrimeagen/harpoon'

  -- Debugger
  use 'mfussenegger/nvim-dap'
  use { 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap' } }

  use {
    'williamboman/nvim-lsp-installer',
  }

  -- Terminal Settings
  use { 'akinsho/toggleterm.nvim', tag = '*', config = function()
    require('toggleterm').setup()
  end }

  -- Language Parser
  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

  -- Git Tools
  use 'tpope/vim-fugitive'
end)
