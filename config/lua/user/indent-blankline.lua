local indent_blankline = require('indent_blankline')
indent_blankline.setup({
  char = '│',
  filetype_exclude = { 'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble' },
  show_trailing_blankline_indent = false,
  show_current_context = false,
})
