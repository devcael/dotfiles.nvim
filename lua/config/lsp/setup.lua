local util = require("lspconfig.util")
local lspconfig = vim.lsp

local on_attach = require("config.lsp.commom").on_attach
local capabilities = require("config.lsp.commom").capabilities

local handlers = {
  ["textDocument/hover"] = vim.lsp.buf.hover({ border = 'rounded', silent = true }),
  ["textDocument/signatureHelp"] = vim.lsp.buf.signature_help({ border = "rounded" })
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

vim.lsp.config("vtsls", {
  cmd = { "vtsls", "--stdio" },
  capabilities = capabilities,
  on_attach = on_attach,
  handlers = handlers,
  -- root_dir = util.root_pattern("package.json"),
  root_markers = { "package.json", ".git" },
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
    cmd = { "lua-language-server" },
    capabilities = capabilities,
    filetypes = { "lua" },
    handlers = handlers,
    on_attach = on_attach,
    settings = require("config.lsp.servers.lua_ls").settings,
  }
)

vim.lsp.config("dartls", {
  cmd = { "flutter", "--stdio" },
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = handlers,
  filetypes = { "dart" },
  root_markers = { "pubspec.yaml", "analysis_options.yaml" },
  init_options = {
    closingLabels = true,
    flutterOutline = true,
    onlyAnalyzeProjectsWithOpenFiles = true,
    suggestFromUnimportedLibraries = false,
  },
})

vim.lsp.config("gopls", {
  capabilities = capabilities,
  handlers = handlers,
  on_attach = on_attach,
  settings = require("config.lsp.servers.gopls").settings,
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" }
  -- root_dir = util.root_pattern(),
})

local cssls = require("config.lsp.servers.cssls")

vim.lsp.config("cssls", {
  capabilities = capabilities,
  handlers = handlers,
  on_attach = on_attach,
  filetypes = cssls.filetypes,
  settings = cssls.settings,
})


local html = require("config.lsp.servers.html")
vim.lsp.config("html", {
  capabilities = capabilities,
  handlers = handlers,
  on_attach = on_attach,
  filetypes = html.filetypes,
  root_markers = { "package.json" },
  init_options = html.init_options
})

local tailwindcss = require("config.lsp.servers.tailwindcss")

vim.lsp.config("tailwindcss", {
  capabilities = capabilities,
  handlers = handlers,
  on_attach = on_attach,
  filetypes = tailwindcss.filetypes,
  settings = tailwindcss.settings,
  -- root_dir = util.root_pattern(unpack(tailwindcss.root_dir_pattern)),
  root_markers = { "package.json" },
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("dartls")
vim.lsp.enable("vtsls")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("gopls")

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
