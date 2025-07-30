require "nvchad.options"

local o = vim.o

o.spelllang = "en,de"

vim.api.nvim_exec2("aunmenu PopUp.How-to\\ disable\\ mouse\naunmenu PopUp.-2-", {})
