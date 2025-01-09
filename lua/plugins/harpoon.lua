return {
  {
    'ThePrimeagen/harpoon',
    as = 'harpoon',
    commit = '0378a6c428a0bed6a2781d459d7943843f374bce',
    branch = 'harpoon2',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

      vim.keymap.set("n", "<C-m>", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<C-n>", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<C-b>", function() harpoon:list():select(3) end)

      vim.keymap.set("n", "<PageUp>", function() harpoon:list():next() end)
      vim.keymap.set("n", "<PageDown>", function() harpoon:list():prev() end)
    end,
  }
}
