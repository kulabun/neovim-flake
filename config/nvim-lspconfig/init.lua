local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<space>f", function()
    vim.lsp.buf.format({ async = true })
  end, bufopts)
end

-- ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
-- if ok then
--   local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- end

-- Haskell
require("lspconfig")["hls"].setup({
  on_attach = on_attach,
  filetypes = { "haskell", "lhaskell" },
})

-- Python 
require("lspconfig")["pyright"].setup({
  on_attach = on_attach,
  filetypes = { "python" },
})

-- Nix
require("lspconfig")["rnix"].setup({
  on_attach = on_attach,
  filetypes = { "nix" },
})

-- Lua
require("lspconfig")["sumneko_lua"].setup({
  on_attach = on_attach,
  filetypes = { "lua" },
})

-- JavaScript, TypeScript
require("lspconfig")["tsserver"].setup({
  on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
})
require("lspconfig")["eslint"].setup({
  on_attach = on_attach,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx" },
})

-- CSS
require("lspconfig")["cssls"].setup({
  on_attach = on_attach,
  filetypes = { "css", "scss" },
})

-- HTML
require("lspconfig")["html"].setup({
  on_attach = on_attach,
  filetypes = { "html" },
})

-- JSON
require("lspconfig")["jsonls"].setup({
  on_attach = on_attach,
  filetypes = { "json", "jsonc" },
})

-- Bash
require("lspconfig")["bashls"].setup({
  on_attach = on_attach,
  filetypes = { "bash", "sh", "zsh" },
})


-- Go
require("lspconfig")["gopls"].setup({
  on_attach = on_attach,
  filetypes = { "go" },
})

-- Rust
require("lspconfig")["rust_analyzer"].setup({
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {},
  },
  filetypes = { "rust" },
})
