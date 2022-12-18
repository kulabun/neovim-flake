vim.g.neo_tree_remove_legacy_commands = 1

require("neo-tree").setup({
  close_if_last_window = true,
  enable_git_status = true,
  enable_diagnostics = true,
  sort_case_insensitive = false,
  buffers = {
    follow_current_file = true,
  },
  filesystem = {
    visible = true,
    follow_current_file = true,
    find_by_full_path_words = true,
    filtered_items = {
      hide_dotfiles = true,
      hide_gitignored = true,
      hide_by_name = {},
      hide_by_pattern = {},
      always_show = {
        ".envrc",
        ".gitignore",
      },
      never_show = {
        "node_modules",
        ".git",
        ".cache",
        ".DS_Store",
        ".vscode",
        ".idea",
        "target",
        "dist",
        "build",
        "vendor",
        "bin",
        "obj",
        "out",
      },
      never_show_by_pattern = {
        "*.class",
        "*.o",
      },
    },
  },
})
