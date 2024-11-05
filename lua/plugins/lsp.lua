return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    servers = {},
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    lazy = false,
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
  },
}

