return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      local action_state = require('telescope.actions.state')
      local actions = require('telescope.actions')

      local buffer_searcher
      buffer_searcher = function()
        builtin.buffers {
          sort_mru = true,
          ignore_current_buffer = true,
          show_all_buffers = false,
          attach_mappings = function(prompt_bufnr, map)
            local refresh_buffer_searcher = function()
              actions.close(prompt_bufnr)
              vim.schedule(buffer_searcher)
            end
            local delete_buf = function()
              local selection = action_state.get_selected_entry()
              vim.api.nvim_buf_delete(selection.bufnr, { force = true })
              refresh_buffer_searcher()
            end
            local delete_multiple_buf = function()
              local picker = action_state.get_current_picker(prompt_bufnr)
              local selection = picker:get_multi_selection()
              for _, entry in ipairs(selection) do
                vim.api.nvim_buf_delete(entry.bufnr, { force = true })
              end
              refresh_buffer_searcher()
            end
            map('n', 'dd', delete_buf)
            map('n', '<C-d>', delete_multiple_buf)
            map('i', '<C-d>', delete_multiple_buf)
            return true
          end
        }
      end

      local builtin = require('telescope.builtin')

      -- Navegação de Arquivos
      vim.keymap.set('n', 'gf', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      vim.keymap.set('n', '<leader><C-p>', builtin.git_files, {})
      vim.keymap.set('n', '<C-p>', buffer_searcher, {})

      -- Busca de Texto
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>ps', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end)

      -- Diagnósticos e Símbolos
      vim.keymap.set('n', '<leader>dd', builtin.diagnostics, { desc = '[D]iagnostics [D]o Projeto' })
      vim.keymap.set('n', '<leader>ws', builtin.lsp_dynamic_workspace_symbols, { desc = '[W]orkspace [S]ymbols' })

      vim.keymap.set('n', '<C-F12>', builtin.lsp_document_symbols, { desc = 'Document Symbols' })

      -- LSP e Navegação
      vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = 'Ir para Referências' })
      vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Retomar última busca' })

      -- Git
      vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Git Status' })

      require('telescope').setup {
        defaults = {
          layout_strategy = 'flex',
          layout_config = {
            horizontal = {
              preview_width = 0.5, -- Define que o preview ocupa 50% da largura
            },
            vertical = {
              preview_height = 0.5,
            },
            flex = {
              flip_columns = 120, -- Muda para vertical se a largura for menor que 120 colunas
            },
          },
        },
      }
    end
  }
}
