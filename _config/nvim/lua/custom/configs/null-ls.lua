local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,

  -- JavaScript/TypeScript
  b.diagnostics.eslint,
  b.code_actions.eslint,
  b.formatting.prettier,

  -- LaTeX
  b.diagnostics.chktex,

  -- Python
  b.diagnostics.flake8,
  b.diagnostics.mypy,
}

null_ls.setup {
  debug = true,
  sources = sources,
}
