local wk = require('which-key')
local Util = require('user.util')

vim.g.mapleader = ' '
vim.o.timeout = true
vim.o.timeoutlen = 300

wk.setup({})

function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- better up/down
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

-- Resize window using <ctrl> <shift> hjkl keys
map('n', '<C-S-k>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
map('n', '<C-S-j>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
map('n', '<C-S-h>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
map('n', '<C-S-l>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Move Lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- Bufferline navigation
map('n', '<S-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })
map('n', '<S-l>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
map('n', '[b', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Prev buffer' })
map('n', ']b', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })

-- Clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
-- The direction of n and N depends on whether / or ? was used for searching forward or backward respectively.
-- This keymappings make n to always search forward and N backward
map('n', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('n', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

-- Add undo break-points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

-- save file
map({ 'n' }, '<C-S-s>', '<cmd>wa<cr><esc>', { desc = 'Save file' })

-- better indenting
map('x', '<', '<gv')
map('x', '>', '>gv')

-- AI complition / Snippets
-- local copilot = require('copilot.suggestion')
local luasnip = require('luasnip')
map({ 'i', 's' }, '<C-h>', function()
  if luasnip.choice_active() then
    luasnip.change_choice(-1)
  -- elseif copilot.is_visible() then
  --   copilot.prev()
  end
end, { desc = 'Previous suggestion / snippet' })
map({ 'i', 's' }, '<C-l>', function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  -- elseif copilot.is_visible() then
  --   copilot.next()
  end
end, { desc = 'Previous suggestion / snippet' })
map({ 'i', 's' }, '<Tab>', function()
  if luasnip.locally_jumpable(1) then
    luasnip.jump(1)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', true)
  end
end, { desc = 'Jump to the next snippet node' })

map({ 'i', 's' }, '<S-Tab>', function()
  if luasnip.locally_jumpable(-1) then
    luasnip.jump(-1)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<S-Tab>', true, true, true), 'n', true)
  end
end, { desc = 'Jump to previous snippet node' })

-- map('i', '<C-S-s>', require('copilot.suggestion').accept, { desc = 'Accept AI suggestion(full)' })
-- map('i', '<C-s>', require('copilot.suggestion').accept_line, { desc = 'Accept AI suggestion(line)' })

-- Telescope
map('n', '<leader>f', Util.telescope('files'), { desc = 'Open find picer' })
map('n', '<leader>F', Util.telescope('files', { cwd = false }), { desc = 'Open find picker at current working directory' })
map('n', '<leader>,', Util.telescope('oldfiles'), { desc = 'Open recent' })
map('n', '<leader>b', Util.telescope('buffers'), { desc = 'Open buffer picker' })
map('n', '<leader>j', Util.telescope('jumplist'), { desc = 'Open jumplist picker' })


map('n', '<leader>c', '<cmd>FindClass<cr>', { desc = 'Find class' })
map('n', '<leader>s', '<cmd>FindDocumentSymbol<cr>', { desc = 'Open symbol picker' })
map('n', '<leader>S', '<cmd>FindSymbol<cr>', { desc = 'Open workspace symbol picker' })
map('n', '<leader>d', '<cmd>Telescope diagnostics bufnr=0<cr>', { desc = 'Open diagnostic picker' })
map('n', '<leader>D', '<cmd>Telescope diagnostics<cr>', { desc = 'Open workspace diagnostic picker' })
map('n', '<leader>/', function()
  require('telescope.builtin').grep_string({
    search = vim.fn.input('Global Search > '),
    only_sort_text = true,
  })
end, { desc = 'Grep string' })
map('n', '<leader>a', vim.lsp.buf.code_action, { desc = 'Perform code action' })
map('n', '<leader>A', Util.telescope('commands'), { desc = 'Find command' })

-- Window
map('n', '<leader>ww', '<C-w>w', { desc = 'Go to next window' })
map('n', '<leader>wl', '<C-w>l', { desc = 'Go to left window' })
map('n', '<leader>wh', '<C-w>h', { desc = 'Go to right window' })
map('n', '<leader>wj', '<C-w>j', { desc = 'Go to window below' })
map('n', '<leader>wk', '<C-w>k', { desc = 'Go to window above' })
map('n', '<leader>wL', '<C-w>l', { desc = 'Swap with left window' })
map('n', '<leader>wH', '<C-w>h', { desc = 'Swap with right window' })
map('n', '<leader>wJ', '<C-w>j', { desc = 'Swap with window below' })
map('n', '<leader>wK', '<C-w>k', { desc = 'Swap with window above' })
map('n', '<leader>wc', '<C-w>c', { desc = 'Close window' })
map('n', '<leader>wo', '<C-w>o', { desc = 'Close windows except current' })
map('n', '<leader>wv', '<C-w>v', { desc = 'Split vertically' })
map('n', '<leader>ws', '<C-w>s', { desc = 'Split horizontally' })
map('n', '<leader>k', vim.lsp.buf.hover, { desc = 'Show documentation' })
map('n', '<leader>n', vim.cmd.enew, { desc = 'Create new buffer' })
map('n', '<leader>q', '<cmd>bd<cr>', { desc = 'Close buffer' })
map('n', '<leader>Q', '<cmd>bd!<cr>', { desc = 'Close buffer (force)' })
-- map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
-- map("n", "<leader>Q", "<cmd>q!<cr>", { desc = "Quit (force)" })

-- map("n", "<leader>c", "<cmd>Telescope commands<cr>", { desc = "Open commands picker" })
map('n', '<leader>e', '<cmd>Neotree toggle<cr>', { desc = 'Toggle File Explorer' })
-- map("n", "<leader>t", "<cmd>terminal<cr>", { desc = "Open terminal" })

-- TODO: can I make gd smart? go to definition if possible, otherwise go to declaration
map('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = 'Go to the definition' })
map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to the declaration' })
map('n', 'gI', require('telescope.builtin').lsp_implementations, { desc = 'Go to the implementation' })
map('n', 'gr', require('telescope.builtin').lsp_references, { desc = 'Go to the references' })
map('n', 'gy', require('telescope.builtin').lsp_type_definitions, { desc = 'Go to the type definitions' })
map('n', '=', vim.lsp.buf.format, { desc = 'Format file' })

map('n', 'H', '<cmd>bprev<cr>', { desc = 'Prev buffer' })
map('n', 'L', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', 'gT', '<cmd>bprev<cr>', { desc = 'Prev buffer' })
map('n', 'gt', '<cmd>bnext<cr>', { desc = 'Next buffer' })

-- Togglers
-- map('n', '<leader>up', '<cmd>ToggleAutopairs<cr>', { desc = 'Toggle autopairs' })

-- System clipboard with gp/gy
map('n', 'gp', '"+p', { desc = 'Paste from system clipboard' })
map('n', 'gP', '"+P', { desc = 'Paste before from system clipboard' })
map('x', 'gy', '"+y', { desc = 'Yank to system clipboard' })
map('n', 'gY', '"+Y', { desc = 'Yank to the end of line to system clipboard' })

-- I have " on the same key as w, but on different layer and I often type "q instead
vim.cmd([[ cnoreabbrev <expr> "q ((getcmdtype() is# ':' && getcmdline() is# '"q')?('wq'):('"q')) ]])
