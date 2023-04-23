local telescope = require("telescope")
local themes = require("telescope.themes")
local actions = require("telescope.actions")
local previewers = require("telescope.previewers")


telescope.setup({
  defaults = {
    color_devicons = true,
    prompt_prefix="❯ ",
    file_ignore_patterns = {
      "node_modules/.*",
      ".git/.*",
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
      theme = "dropdown",
      cwd_only = true,
      previewer = false,
    }),
    buffers = {
      theme = "dropdown",
      previewer = false,
    },
    find_files = {
      theme = "dropdown",
      cwd_only = true,
      previewer = false,
    },
    live_grep = {
      cwd_only = true,
    },
    file_browser = {},
    git_commits = {
      previewer = previewers.new_termopen_previewer({
        get_command = function(entry)
            return { "git", "-c", "core.pager=delta", "-c", "delta.side-by-side=false", "diff", entry.value }
        end,
      })
    },
    lsp_document_symbols = themes.get_dropdown({
      symbols = {
        "Class",
        "Constant",
        "Constructor",
        "Enum",
        "Field",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Property",
        "Struct",
        "Variable",
      },
    }),
    lsp_workspace_symbols = themes.get_dropdown({
      symbols = {
        "Class",
        "Constant",
        "Constructor",
        "Enum",
        "Field",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Property",
        "Struct",
        "Variable",
      },
    }),
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
