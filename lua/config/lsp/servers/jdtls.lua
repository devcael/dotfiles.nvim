local utils = require("resources.utils")

local function get_referenced_jars(path)
  local jars = vim.split(vim.fn.glob(path), '\n', { trimempty = true })
  for i, jar in ipairs(jars) do
    -- Converte \ para / e adiciona o prefixo file:///
    jars[i] = 'file:///' .. jar:gsub('\\', '/')
  end
  return jars
end

local jars = get_referenced_jars('G:\\SISTEMAS\\LIB\\*.jar')

-- Função para obter versões disponíveis do Java
local function get_available_java_versions()
  local java_versions = {}
  local home_path = utils.get_home_path()
  
  -- SDKMAN paths
  local sdkman_java_path = home_path .. "/.sdkman/candidates/java"
  if vim.loop.fs_stat(sdkman_java_path) then
    local handle = vim.loop.fs_scandir(sdkman_java_path)
    if handle then
      local name = vim.loop.fs_scandir_next(handle)
      while name do
        if name ~= "current" then
          local java_bin = sdkman_java_path .. "/" .. name .. "/bin/java"
          if vim.fn.executable(java_bin) == 1 then
            table.insert(java_versions, {
              name = "SDKMAN - " .. name,
              path = java_bin,
              version = name
            })
          end
        end
        name = vim.loop.fs_scandir_next(handle)
      end
    end
  end
  
  -- Windows Program Files
  local windows_java_paths = {
    "C:/Program Files/Java",
    "C:/Program Files/Eclipse Adoptium"
  }
  
  for _, base_path in ipairs(windows_java_paths) do
    if vim.loop.fs_stat(base_path) then
      local handle = vim.loop.fs_scandir(base_path)
      if handle then
        local name = vim.loop.fs_scandir_next(handle)
        while name do
          local java_bin = base_path .. "/" .. name .. "/bin/java.exe"
          if vim.fn.executable(java_bin) == 1 then
            table.insert(java_versions, {
              name = "Windows - " .. name,
              path = java_bin,
              version = name
            })
          end
          name = vim.loop.fs_scandir_next(handle)
        end
      end
    end
  end
  
  -- Sistema padrão
  if vim.fn.executable("java") == 1 then
    table.insert(java_versions, {
      name = "Sistema Padrão",
      path = "java",
      version = "default"
    })
  end
  
  return java_versions
end

local function select_java_version()
  local versions = get_available_java_versions()
  if #versions == 0 then
    vim.notify("Nenhuma versão do Java encontrada!", vim.log.levels.ERROR)
    return "java"
  end
  
  local items = {}
  for i, version in ipairs(versions) do
    table.insert(items, string.format("%d. %s", i, version.name))
  end
  
  vim.ui.select(items, {
    prompt = "Selecione a versão do Java:",
  }, function(choice, idx)
    if choice and idx then
      cache_vars.selected_java = versions[idx].path
      vim.notify("Java selecionado: " .. versions[idx].name)
    end
  end)
  
  return cache_vars.selected_java or versions[1].path
end

local function find_java_path()
  if cache_vars.selected_java then
    return cache_vars.selected_java
  end
  
  local possible_paths = {
    utils.get_home_path() .. "/.sdkman/candidates/java/current/bin/java",
    utils.get_home_path() .. "/.sdkman/candidates/java/17.*/bin/java",
    
    -- os.getenv("JAVA_HOME_NVIM") and (os.getenv("JAVA_HOME_NVIM") .. "/bin/java"),
    -- os.getenv("JAVA_HOME") and (os.getenv("JAVA_HOME") .. "/bin/java"),
    
    "C:/Program Files/Java/jdk-22*/bin/java.exe",
    
    "java"
  }
  
  for _, path_pattern in ipairs(possible_paths) do
    if not path_pattern:find("*") then
      if vim.fn.executable(path_pattern) == 1 then
        print("Using Java from: " .. path_pattern)
        return path_pattern
      end
    else
      local expanded_path = vim.fn.glob(path_pattern)
      if expanded_path ~= "" and vim.fn.executable(expanded_path) == 1 then
        print("Using Java from: " .. expanded_path)
        return expanded_path
      end
    end
  end
  
  return select_java_version()
end

local java_path = find_java_path()

local java_cmds = vim.api.nvim_create_augroup("java_cmds", { clear = true })

local cache_vars = {}

local root_files = {
    ".git",
    "mvnw",
    "gradlew",
    "pom.xml",
    "build.gradle"
}

local features = {
    codelens = true,
    debugger = true,
}

local function get_mason_install_path(path)
  return vim.fn.expand("$MASON") .. "/packages" .. path
end

local function get_jdtls_paths()
    if cache_vars.paths then
        return cache_vars.paths
    end

    local path = {}

    path.data_dir = vim.fn.stdpath("cache") .. "/nvim-jdtls"

    local jdtls_install = get_mason_install_path("/jdtls")

    path.java_agent = jdtls_install .. "/lombok.jar"
    path.launcher_jar = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")

    if vim.fn.has("mac") == 1 then
        path.platform_config = jdtls_install .. "/config_mac"
    elseif vim.fn.has("unix") == 1 then
        path.platform_config = jdtls_install .. "/config_linux"
    elseif vim.fn.has("win32") == 1 then
        path.platform_config = jdtls_install .. "/config_win"
    end

    path.bundles = {}

    local java_test_path = get_mason_install_path("java-test")

    local java_test_bundle = vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n")

    if java_test_bundle[1] ~= "" then
        vim.list_extend(path.bundles, java_test_bundle)
    end

    local java_debug_path = get_mason_install_path("java-debug-adapter")

    local java_debug_bundle =
        vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")

    path.java_debug_bundle = java_debug_bundle;

    if java_debug_bundle[1] ~= "" then
        vim.list_extend(path.bundles, java_debug_bundle)
    end
    path.runtimes = {}

    cache_vars.paths = path

    return path
end

local function enable_codelens(bufnr)
    pcall(vim.lsp.codelens.refresh)
    vim.api.nvim_create_autocmd("BufWritePost", {
        buffer = bufnr,
        group = java_cmds,
        desc = "refresh codelens",
        callback = function()
            pcall(vim.lsp.codelens.refresh)
        end,
    })
end

local function enable_debugger(bufnr)
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
    require("jdtls.dap").setup_dap_main_class_configs()
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "<leader>df", "<cmd>lua require('jdtls').test_class()<cr>", opts)
    vim.keymap.set("n", "<leader>dn", "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)
end

local function on_attach(client, bufnr)
    if features.debugger then
        enable_debugger(bufnr)
    end

    if features.codelens then
        enable_codelens(bufnr)
    end

    -- https://github.com/mfussenegger/nvim-jdtls#usage
    local opts = { buffer = bufnr }

    -- Obter on_attach do lsp_config se disponível
    local has_lsp_config, lsp_config = pcall(require, "config.lsp.commom")
    if has_lsp_config and lsp_config.on_attach then
       lsp_config.on_attach(client, bufnr)
    end

    vim.keymap.set("n", "<C-A-o>", "<cmd>lua require('jdtls').organize_imports()<cr>", opts)
    vim.keymap.set("n", "crv", "<cmd>lua require('jdtls').extract_variable()<cr>", opts)
    vim.keymap.set("x", "crv", "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
    vim.keymap.set("n", "crc", "<cmd>lua require('jdtls').extract_constant()<cr>", opts)
    vim.keymap.set("x", "crc", "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
    vim.keymap.set("x", "crm", "<esc><Cmd>lua require('jdtls').extract_method(true)<cr>", opts)
end

local function jdtls_setup(event)
    local jdtls = require("jdtls")

    local path = get_jdtls_paths()
    local data_dir = path.data_dir .. "/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

    if cache_vars.capabilities == nil then
        jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

        local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
        cache_vars.capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            ok_cmp and cmp_lsp.default_capabilities() or {}
        )
    end

    local cmd = {
        java_path,
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-javaagent:" .. path.java_agent,
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        path.launcher_jar,
        "-configuration",
        path.platform_config,
        "-data",
        data_dir,
    }

    local lsp_settings = {
        java = {
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                updateBuildConfiguration = "interactive",
                runtimes = path.runtimes,
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            inlayHints = {
                parameterNames = {
                    enabled = "all",
                },
            },
            format = {
                enabled = true,
            },
        },
        signatureHelp = {
            enabled = true,
        },
        completion = {
            favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
            },
        },
        contentProvider = {
            preferred = "fernflower",
        },
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
        sources = {
            organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
            },
        },
        codeGeneration = {
            toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
        },
    }

    jdtls.start_or_attach({
        cmd = cmd,
        settings = lsp_settings,
        on_attach = on_attach,
        capabilities = cache_vars.capabilities,
        root_dir = jdtls.setup.find_root(root_files),
        flags = {
            allow_incremental_sync = true,
        },
        init_options = {
            bundles = path.bundles,
        },
    })
end

local function setup()
    jdtls_setup()
end

vim.api.nvim_create_user_command("SetupJava", setup, { nargs = "?" })

vim.api.nvim_create_autocmd("FileType", {
    group = java_cmds,
    pattern = { "java" },
    desc = "Setup jdtls",
    callback = jdtls_setup,
})
