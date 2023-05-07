local luasnip = require('luasnip')
luasnip.setup({})

luasnip.config.setup({ store_selection_keys = '<Tab>' })
luasnip.env_namespace('USER', {
  vars = {
    NAME = 'Konstantin Labun',
    EMAIL = 'konstantin.labun@gmail.com',
    GITHUB = 'kulabun',
  },
})

require('luasnip.loaders.from_snipmate').lazy_load()
