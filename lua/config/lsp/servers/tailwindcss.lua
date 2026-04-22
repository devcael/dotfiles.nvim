local M = {}

M.filetypes = {
  "html",
  "css",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "vue",
}

M.settings = {
  tailwindCSS = {
    includeLanguages = {
      vue = "html",
    },
    experimental = {
      classRegex = {
        { "class[:]\\s*\"([^\"]*)" },
        { ":class[:]\\s*\"([^\"]*)" },
        { "class[:]\\s*'([^']*)" },
      },
    },
    validate = true,
  },
}

M.root_dir_pattern = { "tailwind.config.js", "tailwind.config.ts", "postcss.config.js", "package.json" }

return M
