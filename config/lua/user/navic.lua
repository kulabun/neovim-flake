local navic = require('nvim-navic')
local icons = require('user.config').icons

-- vim.g.navic_silence = true

navic.setup({
  separator = ' ',
  highlight = true,
  depth_limit = 5,
  icons = icons.kinds,
})
