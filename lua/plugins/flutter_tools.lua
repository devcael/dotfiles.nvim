return {
  {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim',
    },
    config = function()

      local capabilities = require("config.lsp.commom").capabilities

      require('flutter-tools').setup({
        ui = {
          border = "rounded",
          notification_style = 'plugin'
        },
        decorations = {
          statusline = {
            app_version = false,
            device = true,
            project_config = false,
          }
        },
        debugger = {
          enabled = true,
          exception_breakpoints = {},
          evaluate_to_string_in_debug_views = true,
          register_configurations = function(paths)
            require("dap").configurations.dart = {
              require("dap").configurations.dart,
              {
                type = "dart",
                request = "launch",
                name = "Launch flutter",
                dartSdkPath = paths.dart_sdk,
                flutterSdkPath = paths.flutter_sdk,
                program = "${workspaceFolder}/lib/main.dart",
                cwd = "${workspaceFolder}",
              }
            }
          end,
        },
        flutter_path = nil, -- deixa detectar automaticamente
        flutter_lookup_cmd = nil,
        root_patterns = { ".git", "pubspec.yaml" },
        fvm = false, -- usar flutter version management
        widget_guides = {
          enabled = false,
        },
        closing_tags = {
          highlight = "ErrorMsg",
          prefix = "//",
          enabled = true
        },
        dev_log = {
          enabled = true,
          notify_errors = false,
          open_cmd = "tabedit",
        },
        dev_tools = {
          autostart = false,
          auto_open_browser = false,
        },
        outline = {
          open_cmd = "30vnew",
          auto_open = false
        },
        lsp = {
          color = {
            enabled = false,
            background = false,
            background_color = nil,
            foreground = false,
            virtual_text = true,
            virtual_text_str = "■",
          },
          on_attach = function(client, bufnr)
            -- Configurações específicas do LSP Flutter
            local bufopts = { noremap=true, silent=true, buffer=bufnr }

            local has_lsp_config, lsp_config = pcall(require, "config.lsp.commom")
            if has_lsp_config and lsp_config.on_attach then
               lsp_config.on_attach(client, bufnr)
            end

            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
          end,
          capabilities = capabilities,
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            analysisExcludedFolders = {
              vim.fn.expand("$HOME/AppData/Local/Pub/Cache"),
              vim.fn.expand("$HOME/.pub-cache"),
              vim.fn.expand("/opt/homebrew/"),
              vim.fn.expand("$HOME/tools/flutter/"),
            },
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
          }
        }
      })
      
      -- Comandos adicionais do Flutter Tools
      vim.keymap.set("n", "<leader>Fc", "<cmd>Telescope flutter commands<cr>", { desc = "Flutter: Commands" })
      vim.keymap.set("n", "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", { desc = "Flutter: Outline" })
      vim.keymap.set("n", "<leader>Fd", "<cmd>FlutterDevTools<cr>", { desc = "Flutter: Dev Tools" })
      vim.keymap.set("n", "<leader>Fl", "<cmd>FlutterDevToolsActivate<cr>", { desc = "Flutter: Dev Tools Log" })
      vim.keymap.set("n", "<leader>Fq", "<cmd>FlutterQuit<cr>", { desc = "Flutter: Quit" })
      vim.keymap.set("n", "<leader>Fs", "<cmd>FlutterSuper<cr>", { desc = "Flutter: Super" })
      vim.keymap.set("n", "<leader>Fr", "<cmd>FlutterReanalyze<cr>", { desc = "Flutter: Reanalyze" })
      vim.keymap.set("n", "<leader>FD", "<cmd>FlutterVisualDebug<cr>", { desc = "Flutter: Visual Debug" })
    end,
  }
}
