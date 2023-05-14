local telescope = require('telescope')

telescope.setup({
  pickers = {
    buffers = {
      theme = 'dropdown',
      previewer = false,
    },
    live_grep = {
      cwd_only = true,
    },
    lsp_document_symbols = {
      theme = 'dropdown',
      previewer = false,
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
    },
    lsp_workspace_symbols = {
      theme = 'dropdown',
      cwd_only = true,
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
    },
    git_commits = {
      previewer = require('telescope.previewers').new_termopen_previewer({
        get_command = function(entry)
          return {
            'git',
            '-c',
            'core.pager=delta',
            '-c',
            'delta.side-by-side=false',
            'diff',
            entry.value .. '^',
            entry.value,
          }
        end,
      }),
    },
  },
  defaults = {
    prompt_prefix = ' ',
    selection_caret = ' ',
    mappings = {
      i = {
        ['<C-f>'] = function(...)
          return require('telescope.actions').preview_scrolling_down(...)
        end,
        ['<C-b>'] = function(...)
          return require('telescope.actions').preview_scrolling_up(...)
        end,
      },
      n = {
        ['q'] = function(...)
          return require('telescope.actions').close(...)
        end,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
})
telescope.load_extension('fzf')
