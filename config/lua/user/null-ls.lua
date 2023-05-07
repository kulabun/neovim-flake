local null_ls = require('null-ls')

null_ls.setup({
  root_dir = require('null-ls.utils').root_pattern('Makefile', '.git'),
  sources = {
    -- Lua
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.selene,

    -- Shell
    null_ls.builtins.formatting.shfmt,

    -- Python
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.diagnostics.ruff,

    -- Nix
    null_ls.builtins.formatting.alejandra,
    null_ls.builtins.diagnostics.statix,
    null_ls.builtins.code_actions.statix,

    -- JSON
    null_ls.builtins.diagnostics.jsonlint,

    -- YAML
    null_ls.builtins.diagnostics.yamllint,

    -- JavaScript, TypeScript, CSS, HTML, JSON, YAML, Markdown, graphql
    null_ls.builtins.formatting.prettier,
  },
})
