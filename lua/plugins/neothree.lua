return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.keymap.set('n', '<A-1>', "<cmd>:Neotree left toggle<cr>", { silent = true });
      vim.keymap.set('n', '-', "<cmd>:Neotree toggle<cr>", { silent = true });
      vim.keymap.set('n', '<leader>nf', "<cmd>:Neotree left reveal<cr>", { silent = true });
      -- vim.keymap.set('n', '<leader>e', "<cmd>:Neotree focus<cr>", { silent = true });

      require("neo-tree").setup({
        window = {
          position = "current",
        }
      });
    end
  }
}
