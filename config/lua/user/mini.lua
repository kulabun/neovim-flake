local ai = require('mini.ai')
ai.setup({
  n_lines = 500,
  custom_textobjects = {
    o = ai.gen_spec.treesitter({
      a = { '@block.outer', '@conditional.outer', '@loop.outer' },
      i = { '@block.inner', '@conditional.inner', '@loop.inner' },
    }, {}),
    f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
    c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
  },
})

local basics = require('mini.basics')
basics.setup({
  n_lines = 500,
  custom_textobjects = {
    o = ai.gen_spec.treesitter({
      a = { '@block.outer', '@conditional.outer', '@loop.outer' },
      i = { '@block.inner', '@conditional.inner', '@loop.inner' },
    }, {}),
    f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
    c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
  },
})

require('mini.basics').setup()
require('mini.comment').setup()
require('mini.cursorword').setup()
-- require('mini.pairs').setup()
require('mini.indentscope').setup({
  symbol = '│',
  options = { try_as_border = true },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble' },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

-- Nix comments
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'nix', 'terraform' },
  callback = function()
    vim.opt.commentstring = '# %s'
  end,
})
