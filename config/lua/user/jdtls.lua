vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'java', 'groovy' },
  callback = function()
    local config = {
      cmd = { 'jdt-language-server', '-data', vim.fn.expand('~/.cache/jdtls-workspace') },
      root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
    }
    require('jdtls').start_or_attach(config)
  end,
})
