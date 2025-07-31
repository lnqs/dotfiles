require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "pyright", "bashls", "ts_ls", "clangd" }

vim.lsp.config('cssls', {
  settings = {
    css = {
      lint = {
        unknownAtRules = 'ignore',
      },
    },
  },
})

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
