local copilot = require('copilot')
copilot.setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
  },
  panel = {
    enabled = false,
  },
  server_opts_overrides = {
    settings = {
      advanced = {
        inlineSuggestCount = 3,
      },
    },
  },
  filetypes = {
    javascript = true,
    typescript = true,
    python = true,
    java = true,
    groovy = true,
    rust = true,
    lua = true,
    sh = true,
    nix = true,
    ['*'] = false,
  },
})
