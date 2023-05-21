local lspconfig = require('lspconfig')

local capabilities =
  vim.tbl_deep_extend('force', {}, vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())

local on_attach = function(client, buffer)
  if client.server_capabilities.documentSymbolProvider then
    require('nvim-navic').attach(client, buffer)
  end
end

lspconfig.pyright.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.bashls.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.nil_ls.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.denols.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.tailwindcss.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.cssls.setup({ capabilities = capabilities, on_attach = on_attach })

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

-- local servers = { "html", "cssls", "clangd", "pyright", "rust_analyzer", "jdtls", "gopls", "rnix", "bashls", "lua_ls", "denols", "jsonls" }

-- lspconfig.tsserver.setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
--   cmd = { "typescript-language-server", "--stdio", "--tsserver-path", "tsserver" },
--   filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
-- })
-- lspconfig.tsserver.setup {}
