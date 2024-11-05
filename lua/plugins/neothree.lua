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
      vim.keymap.set('n', '<C-e>', "<cmd>:Neotree toggle<cr>", { silent = true });
      vim.keymap.set('n', '<leader>nf', "<cmd>:Neotree current<cr>", { silent = true });
      vim.keymap.set('n', '<leader>e', "<cmd>:Neotree focus<cr>", { silent = true });
    end
  }
}
