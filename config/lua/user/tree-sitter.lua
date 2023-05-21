local treesitter = require('nvim-treesitter.configs')
treesitter.setup({
  auto_install = false,
  highlight = {
    enable = true,
  },
  indent = { enable = true },
  context_commentstring = { enable = true, enable_autocmd = false },
  -- incremental_selection = {
  --   enable = true,
  --   keymaps = {
  --     init_selection = "<C-space>",
  --     node_incremental = "<C-space>",
  --     scope_incremental = false,
  --     node_decremental = "<bs>",
  --   },
  -- },
})

vim.treesitter.language.register('hcl', 'terraform')
