local util = require("lspconfig.util")
local lspconfig = vim.lsp

local on_attach = require("config.lsp.commom").on_attach
local capabilities = require("config.lsp.commom").capabilities

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    silent = true,
    border = "rounded",
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

require("mason").setup({
  ui = { border = "rounded" },
})

require("mason-lspconfig").setup({
  automatic_enable = false,
})

vim.lsp.config("*", {
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = handlers,
  root_markers = { '.git' },
})

vim.lsp.config('vtsls', {
  capabilities = capabilities,
  on_attach = on_attach,
  handlers = handlers,
  root_dir = util.root_pattern("package.json"),
  filetypes = {
    "javascript",
    "typescript",
    "vue",
    "jsx",
    "tsx",
    "javascriptreact",
    "typescriptreact",
  },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = require("config.lsp.servers.tsserver").get_vue_plugin_path(),
            languages = { "vue" },
            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
          },
        },
      },
    },
  },
})

vim.lsp.config("lua_ls",
  {
    capabilities = capabilities,
    handlers = handlers,
    on_attach = on_attach,
    settings = require("config.lsp.servers.lua_ls").settings,
  }
)

vim.lsp.config("dartls", {
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = handlers,
  filetypes = { "dart" },
  root_dir = util.root_pattern("pubspec.yaml", "analysis_options.yaml"),
  init_options = {
    closingLabels = true,
    flutterOutline = true,
    onlyAnalyzeProjectsWithOpenFiles = true,
    suggestFromUnimportedLibraries = false,
  },
})

-- lspconfig.gopls.setup({
--   capabilities = capabilities,
--   handlers = handlers,
--   on_attach = on_attach,
--   settings = require("config.lsp.servers.gopls").settings,
--   filetypes = { "go", "gomod", "gowork", "gotmpl" },
--   root_dir = util.root_pattern("go.work", "go.mod", ".git"),
-- })
--
-- local cssls = require("config.lsp.servers.cssls")
-- lspconfig.cssls.setup({
--   capabilities = capabilities,
--   handlers = handlers,
--   on_attach = on_attach,
--   filetypes = cssls.filetypes,
--   settings = cssls.settings,
-- })
--
-- local html = require("config.lsp.servers.html")
-- lspconfig.html.setup({
--   capabilities = capabilities,
--   handlers = handlers,
--   on_attach = on_attach,
--   filetypes = html.filetypes,
--   init_options = html.init_options,
-- })
--
-- local tailwindcss = require("config.lsp.servers.tailwindcss")
-- lspconfig.tailwindcss.setup({
--   capabilities = capabilities,
--   handlers = handlers,
--   on_attach = on_attach,
--   filetypes = tailwindcss.filetypes,
--   settings = tailwindcss.settings,
--   root_dir = util.root_pattern(unpack(tailwindcss.root_dir_pattern)),
-- })
--

vim.lsp.enable("lua_ls")
vim.lsp.enable("dartls")

require("mason-registry").refresh(function()
  local debug_adapters = {
    -- "node-debug2-adapter",
    -- "chrome-debug-adapter",
    -- "delve",
  }
  for _, adapter in ipairs(debug_adapters) do
    local p = require("mason-registry").get_package(adapter)
    if not p:is_installed() then
      p:install()
    end
  end
end)
