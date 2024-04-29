local null = require("null-ls")

null.setup({
  filetypes = { "go" },
  generator = {
    fn = function(params)
      local diagnostics = {}
      for i, line in ipairs(params.content) do
        local col, end_col = line:find("really")
        if col and end_col then
          table.insert(diagnostics, {
            row = i,
            col = col,
            end_col = end_col + 1,
            source = "no-really",
            message = "Don't use 'really!'",
            severity = vim.diagnostic.severity.WARN,
          })
        end
      end
      return diagnostics
    end,
  },
  sources = {
    null.builtins.formatting.stylua,
    null.builtins.diagnostics.eslint,
    null.builtins.completion.spell,
    null.builtins.formatting.gofmt,
    null.builtins.formatting.goimports,
    null.builtins.formatting.tsserver
  },
})

