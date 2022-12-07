if vim.fn.has("termguicolors") == 1 then
  vim.o.termguicolors = true
end

vim.g.indent_guides_auto_colors = 0 -- for indent-blankline.nvim
-- vim.g.sonokai_style = "espresso"
vim.g.sonokai_style = "shusia"
-- vim.g.sonokai_style = "default"
-- vim.g.sonokai_better_performance = 1 -- doesn't work on nix
-- vim.g.sonokai_transparent_background = 1

vim.cmd("colorscheme sonokai")
