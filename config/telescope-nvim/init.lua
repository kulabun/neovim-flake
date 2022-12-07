local telescope = require("telescope")
local themes = require("telescope.themes")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    color_devicons = true,
    file_ignore_patterns = {
      'node_modules/.*',
      '.git/.*'
    },
    -- Default configuration for telescope goes here:
    -- config_key = value,
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim", -- add this value
    },
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key",
        ["<esc>"] = actions.close,
        ["<C-u>"] = false,
      },
    },
    layout_strategy = "horizontal",
    layout_config = {
      -- vertical = {
      --   prompt_position = "top",
      -- },
      -- horizontal = {
      --   prompt_position = "top",
      -- },
    },
  },
  pickers = {
    oldfiles = themes.get_dropdown({
      cwd_only = true,
      previewer = false;
    }),
    buffers = themes.get_dropdown({ 
      previewer = false; 
    }),
    find_files = themes.get_dropdown({
      cwd_only = true,
      previewer = false;
    }),
    file_browser = themes.get_dropdown({ }),
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    },
  },
})

telescope.load_extension("project")
telescope.load_extension("file_browser")
telescope.load_extension("manix")
telescope.load_extension("fzf")
