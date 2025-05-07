return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'rcarriga/cmp-dap',
    },
    config = function()
      -- Carrega a configuração do DAP
      require("config.dap").setup()
    end
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
  }
}
