return {
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
          }
        },
        defaults = {
          mappings = {
            i = {
              ["jj"] = actions.close,
              ["<C-c>"] = actions.close,
            }
          }
        }
      }
      require("telescope").load_extension("ui-select")
    end,
  }
}
