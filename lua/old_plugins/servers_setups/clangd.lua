local lsp_conf = require("plugins.lsp_config")
local lspconfig = require("lspconfig")

lspconfig.clangd.setup {
    cmd = { "clangd" },
    on_attach = lsp_conf.on_attach,
    capabilities = lsp_conf.capabilities,
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")
}

