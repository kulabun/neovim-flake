local neotree = require('neo-tree')

vim.g.neo_tree_remove_legacy_commands = 1

neotree.setup({
  filesystem = {
    bind_to_cwd = false,
    follow_current_file = true,
    use_libuv_file_watcher = true,
  },
  window = {
    mappings = {
      ['<space>'] = 'none',
    },
  },
  default_component_configs = {
    indent = {
      with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = '',
      expander_expanded = '',
      expander_highlight = 'NeoTreeExpander',
    },
  },
  close_if_last_window = true,
})

-- vim.api.nvim_create_autocmd("TermClose", {
--   pattern = "*lazygit",
--   callback = function()
--     if package.loaded["neo-tree.sources.git_status"] then
--       require("neo-tree.sources.git_status").refresh()
--     end
--   end,
-- })
