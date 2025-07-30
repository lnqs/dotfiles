return {
  {
    name = "Format Buffer",
    cmd = function()
      local ok, conform = pcall(require, "conform")

      if ok then
        conform.format { lsp_fallback = true }
      else
        vim.lsp.buf.format()
      end
    end,
    rtxt = "<leader>fm",
  },

  {
    name = "Code Actions",
    cmd = vim.lsp.buf.code_action,
    rtxt = "<leader>ca",
  },

  { name = "separator" },

  {
    name = "Goto Definition",
    cmd = vim.lsp.buf.definition,
    rtxt = "gd",
  },

  {
    name = "Goto Declaration",
    cmd = vim.lsp.buf.declaration,
    rtxt = "gD",
  },

  {
    name = "Goto Implementation",
    cmd = vim.lsp.buf.implementation,
    rtxt = "gi",
  },

  { name = "separator" },

  {
    name = "Show signature help",
    cmd = vim.lsp.buf.signature_help,
    rtxt = "<leader>sh",
  },

  {
    name = "Add workspace folder",
    cmd = vim.lsp.buf.add_workspace_folder,
    rtxt = "<leader>wa",
  },

  {
    name = "Remove workspace folder",
    cmd = vim.lsp.buf.remove_workspace_folder,
    rtxt = "<leader>wr",
  },

  {
    name = "Show References",
    cmd = vim.lsp.buf.references,
    rtxt = "gr",
  },

  { name = "separator" },

  {
    name = "Format Buffer",
    cmd = function()
      local ok, conform = pcall(require, "conform")

      if ok then
        conform.format { lsp_fallback = true }
      else
        vim.lsp.buf.format()
      end
    end,
    rtxt = "<leader>fm",
  },

  {
    name = "Code Actions",
    cmd = vim.lsp.buf.code_action,
    rtxt = "<leader>ca",
  },

  { name = "separator" },

  {
    name = "  Open in terminal",
    hl = "ExRed",
    cmd = function()
      local old_buf = require("menu.state").old_data.buf
      local old_bufname = vim.api.nvim_buf_get_name(old_buf)
      local old_buf_dir = vim.fn.fnamemodify(old_bufname, ":h")

      local cmd = "cd " .. old_buf_dir

      -- base46_cache var is an indicator of nvui user!
      if vim.g.base46_cache then
        require("nvchad.term").new { cmd = cmd, pos = "sp" }
      else
        vim.cmd "enew"
        vim.fn.termopen { vim.o.shell, "-c", cmd .. " ; " .. vim.o.shell }
      end
    end,
  },
}
