local navic = require('navic')

vim.g.navic_silence = true

navic.setup({
  separator = ' ',
  highlight = true,
  depth_limit = 5,
  icons = icons.kinds,
})
