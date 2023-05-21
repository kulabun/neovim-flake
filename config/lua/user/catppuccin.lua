local catppuccin = require('catppuccin')
catppuccin.setup({
  flavour = 'mocha',
  integrations = {
    navic = {
      enabled = true,
    },
  },
})

vim.cmd.colorscheme('catppuccin')
