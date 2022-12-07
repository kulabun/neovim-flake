  -- char_highlight_list = {
require("indent_blankline").setup({
  use_treesitter = true,
  show_current_context = true,
  char = "";
  -- context_char = "│";
  context_char = "┆";
  -- context_char_blankline = ".",
  show_first_indent_level = false,
  show_trailing_blankline_indent = false,
  
  -- show_current_context_start = true,

  -- char = "",
  -- char_highlight_list = {
  --   "IndentGuidesOdd",
  --   "IndentGuidesEven",
  -- },
  -- space_char_highlight_list = {
  --   "IndentGuidesOdd",
  --   "IndentGuidesEven",
  -- },
  -- show_trailing_blankline_indent = true,
})
