local Util = require('user.util')
local themes = require('telescope.themes')
local dropdown = themes.get_dropdown

vim.api.nvim_create_user_command(
  'FindClass',
  Util.telescope(
    'lsp_workspace_symbols',
    dropdown({
      previewer = true,
      symbols = {
        'Class',
        'Interface',
        'Enum',
        'Struct',
        'Trait',
      },
    })
  ),
  { bang = true }
)

vim.api.nvim_create_user_command(
  'FindSymbol',
  Util.telescope(
    'lsp_workspace_symbols',
    dropdown({
      previewer = true,
      symbols = {
        'Class',
        'Constant',
        'Constructor',
        'Enum',
        'Field',
        'Function',
        'Interface',
        'Method',
        'Module',
        'Property',
        'Struct',
        'Trait',
        'Variable',
      },
    })
  ),
  { bang = true }
)

vim.api.nvim_create_user_command(
  'FindDocumentSymbol',
  Util.telescope(
    'lsp_document_symbols',
    dropdown({
      previewer = true,
      symbols = {
        'Class',
        'Constant',
        'Constructor',
        'Enum',
        'Field',
        'Function',
        'Interface',
        'Method',
        'Module',
        'Property',
        'Struct',
        'Trait',
        'Variable',
      }
    })
  ),
  { bang = true }
)

vim.api.nvim_create_user_command('ToggleAutopairs', function()
  vim.b.minipairs_disable = not vim.b.minipairs_disable
end, { bang = true })
