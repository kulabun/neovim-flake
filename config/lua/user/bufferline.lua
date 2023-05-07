local bufferline = require('bufferline')
local icons = require('user.config').icons

bufferline.setup({
  options = {
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(_, _, diag)
      local icons = icons.diagnostics
      local ret = (diag.error and icons.Error .. diag.error .. ' ' or '') .. (diag.warning and icons.Warn .. diag.warning or '')
      return vim.trim(ret)
    end,
    offsets = {
      {
        filetype = 'neo-tree',
        text = 'Neo-tree',
        highlight = 'Directory',
        text_align = 'left',
      },
    },
  },
})
