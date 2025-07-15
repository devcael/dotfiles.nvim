return {
  {
    "ray-x/go.nvim",
    dependencies = {  
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        goimports = 'gopls', 
        gofmt = 'gofumpt', 
        max_line_len = 120,
        tag_transform = false,
        test_dir = '',
        comment_placeholder = '   ',
        lsp_cfg = true, 
        lsp_gofumpt = true, 
        lsp_on_attach = true, 
        dap_debug = true,
        run_in_floaterm = false, 
        trouble = true,
        luasnip = true,
      })

      local go_config = {}
      
      local function load_project_config()
        local config_file = vim.fn.getcwd() .. "/.nvim-go.json"
        if vim.fn.filereadable(config_file) == 1 then
          local content = vim.fn.readfile(config_file)
          local ok, config = pcall(vim.json.decode, table.concat(content, "\n"))
          if ok then
            go_config = config
            return true
          end
        end
        return false
      end

      local function find_main_files()
        local main_files = {}
        local cmd = vim.fn.has('win32') == 1 and
          'powershell "Get-ChildItem -Recurse -Filter *.go | Select-String -Pattern \\"func main\\(\\)\\" | Select-Object -ExpandProperty Filename"' or
          "find . -name '*.go' -type f -exec grep -l 'func main()' {} \\; 2>/dev/null"
        
        local handle = io.popen(cmd)
        if handle then
          for line in handle:lines() do
            if line and line ~= "" then
              table.insert(main_files, line:gsub("^%./", ""))
            end
          end
          handle:close()
        end
        return main_files
      end

      local function run_project()
        load_project_config()
        
        if go_config.configurations and #go_config.configurations > 0 then
          local items = {}
          for _, config in ipairs(go_config.configurations) do
            table.insert(items, config.name .. " (" .. (config.program or ".") .. ")")
          end
          
          vim.ui.select(items, {
            prompt = "Selecione a configuração para executar:",
          }, function(choice, idx)
            if choice and idx then
              local selected_config = go_config.configurations[idx]
              local program = selected_config.program or "."
              local cmd = "go run " .. program

              if selected_config.args and #selected_config.args > 0 then
                cmd = cmd .. " " .. table.concat(selected_config.args, " ")
              end
              
              local env_vars = ""
              if selected_config.env then
                for key, value in pairs(selected_config.env) do
                  if vim.fn.has('win32') == 1 then
                    env_vars = env_vars .. "$env:" .. key .. "='" .. value .. "'; "
                  else
                    env_vars = env_vars .. "export " .. key .. "=" .. value .. " && "
                  end
                end
              end
              
              -- local full_cmd = env_vars .. cmd
              local full_cmd = cmd
              vim.cmd("split | terminal " ..full_cmd)
              print("Full cmd: " .. full_cmd)
            end
          end)
        else
          local main_files = find_main_files()
          if #main_files == 0 then
            vim.cmd("split | terminal go run .")
          elseif #main_files == 1 then
            local dir = vim.fn.fnamemodify(main_files[1], ":h")
            if dir == "." or dir == "" then
              vim.cmd("split | terminal go run .")
            else
              vim.cmd("split | terminal cd " .. dir .. " && go run .")
            end
          else
            local display_items = {}
            for _, file in ipairs(main_files) do
              table.insert(display_items, file)
            end
            
            vim.ui.select(display_items, {
              prompt = "Múltiplos arquivos main.go encontrados:",
            }, function(choice)
              if choice then
                local dir = vim.fn.fnamemodify(choice, ":h")
                if dir == "." or dir == "" then
                  vim.cmd("split | terminal go run .")
                else
                  vim.cmd("split | terminal cd " .. dir .. " && go run .")
                end
              end
            end)
          end
        end
      end

      local function create_sample_config()
        -- Tentar usar template personalizado primeiro
        local template_path = vim.fn.stdpath('config') .. '/lua/resources/go_config_template.json'
        local sample_config
        
        if vim.fn.filereadable(template_path) == 1 then
          local content = vim.fn.readfile(template_path)
          local ok, config = pcall(vim.json.decode, table.concat(content, "\n"))
          if ok then
            sample_config = config
          end
        end
        
        if not sample_config then
          sample_config = {
            configurations = {
              {
                name = "Main Application",
                type = "go",
                request = "launch",
                mode = "auto",
                program = ".",
                args = {},
                env = {},
                description = "Executa a aplicação principal na raiz do projeto"
              },
              {
                name = "API Server",
                type = "go",
                request = "launch",
                mode = "auto",
                program = "./cmd/api",
                args = {"--port", "8080"},
                env = {
                  ENV = "development",
                  PORT = "8080"
                },
                description = "Inicia o servidor API em modo desenvolvimento"
              },
              {
                name = "CLI Tool",
                type = "go",
                request = "launch",
                mode = "auto",
                program = "./cmd/cli",
                args = {"--help"},
                env = {},
                description = "Executa a ferramenta CLI com opção de ajuda"
              }
            }
          }
        end
        
        local config_file = vim.fn.getcwd() .. "/.nvim-go.json"
        
        if vim.fn.filereadable(config_file) == 1 then
          local response = vim.fn.confirm("Arquivo .nvim-go.json já existe. Sobrescrever?", "&Sim\n&Não", 2)
          if response ~= 1 then
            return
          end
        end
        
        local encoded = vim.fn.json_encode(sample_config)
        encoded = encoded:gsub('",', '",\n    ')
        encoded = encoded:gsub('{', '{\n    ')
        encoded = encoded:gsub('}', '\n  }')
        
        vim.fn.writefile(vim.split(encoded, "\n"), config_file)
        vim.notify("Arquivo de configuração criado: .nvim-go.json", vim.log.levels.INFO)
        vim.cmd("edit " .. config_file)
      end

      vim.api.nvim_create_user_command("GoRunProject", run_project, {})
      vim.api.nvim_create_user_command("GoCreateConfig", create_sample_config, {})
      
      vim.api.nvim_create_user_command("GoListConfigs", function()
        load_project_config()
        if go_config.configurations then
          for i, config in ipairs(go_config.configurations) do
            print(i .. ". " .. config.name .. " (" .. (config.program or ".") .. ")")
          end
        else
          print("Nenhuma configuração encontrada. Use :GoCreateConfig para criar uma.")
        end
      end, {})
      
      local function run_go_project()
        local config_path = vim.fn.getcwd() .. "/.nvim-go.json"
        
        if vim.fn.filereadable(config_path) == 1 then
          local file = io.open(config_path, "r")
          if not file then
            vim.notify("Erro ao ler arquivo de configuração", vim.log.levels.ERROR)
            return
          end
          
          local content = file:read("*all")
          file:close()
          
          local ok, config = pcall(vim.json.decode, content)
          if not ok or not config.configurations then
            vim.notify("Arquivo de configuração inválido", vim.log.levels.ERROR)
            return
          end
          
          if #config.configurations == 1 then
            run_configuration(config.configurations[1])
          else
            local items = {}
            for _, conf in ipairs(config.configurations) do
              table.insert(items, conf.name)
            end
            
            vim.ui.select(items, {
              prompt = "Selecione uma configuração:",
            }, function(choice)
              if choice then
                for _, conf in ipairs(config.configurations) do
                  if conf.name == choice then
                    run_configuration(conf)
                    break
                  end
                end
              end
            end)
          end
        else
          local main_files = {}
          
          if vim.fn.filereadable("main.go") == 1 then
            table.insert(main_files, { name = "main.go (raiz)", path = "." })
          end
          
          local cmd_dirs = vim.fn.glob("cmd/*", false, true)
          for _, dir in ipairs(cmd_dirs) do
            local main_path = dir .. "/main.go"
            if vim.fn.filereadable(main_path) == 1 then
              local dir_name = vim.fn.fnamemodify(dir, ":t")
              table.insert(main_files, { name = "cmd/" .. dir_name .. "/main.go", path = dir })
            end
          end
          
          if #main_files == 0 then
            run_simple_command("go run .")
          elseif #main_files == 1 then
            local config = {
              name = main_files[1].name,
              program = main_files[1].path
            }
            run_configuration(config)
          else
            local items = {}
            for _, file in ipairs(main_files) do
              table.insert(items, file.name)
            end
            
            vim.ui.select(items, {
              prompt = "Selecione qual main.go executar:",
            }, function(choice)
              if choice then
                for _, file in ipairs(main_files) do
                  if file.name == choice then
                    local config = {
                      name = file.name,
                      program = file.path
                    }
                    run_configuration(config)
                    break
                  end
                end
              end
            end)
          end
        end
      end

      local function run_configuration(config)
        local cmd = "go run"
        
        local program = config.program or "."
        if program:sub(1, 2) == "./" then
          program = program:sub(3) -- Remove "./"
        end
        
        if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
          program = program:gsub("/", "\\")
        end
        
        if program ~= "." and not (program:match("^[A-Za-z]:") or program:match("^\\\\")) then
          cmd = cmd .. " ./" .. program
        else
          cmd = cmd .. " " .. program
        end
        
        if config.args and #config.args > 0 then
          for _, arg in ipairs(config.args) do
            cmd = cmd .. " " .. vim.fn.shellescape(arg)
          end
        end
        
        local env_cmd = ""
        if config.env then
          for key, value in pairs(config.env) do
            if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
              env_cmd = env_cmd .. "set " .. key .. "=" .. value .. " && "
            else
              env_cmd = env_cmd .. key .. "=" .. value .. " "
            end
          end
        end
        
        local final_cmd = env_cmd .. cmd
        
        vim.notify("Executando: " .. final_cmd, vim.log.levels.INFO)
        
        vim.cmd("split")
        vim.cmd("terminal " .. final_cmd)
        vim.cmd("startinsert")
      end

      local function run_simple_command(cmd)
        vim.notify("Executando: " .. cmd, vim.log.levels.INFO)
        vim.cmd("split")
        vim.cmd("terminal " .. cmd)
        vim.cmd("startinsert")
      end
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()'
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
    end
  }
}
