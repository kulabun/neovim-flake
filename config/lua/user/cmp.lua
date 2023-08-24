local cmp = require('cmp')
local icons = require('user.config').icons
-- local copilot = require('copilot.suggestion')

local prioritize_snippet_on_exact_match = function(entry1, entry2)
  return entry1.exact and entry1.source.name == 'luasnip'
end

local function has_words_before()
  local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup({
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 'c' }),
    ['<C-p>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 'c' }),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-s>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm()
      -- elseif copilot.is_visible() then
      --   copilot.accept_line()
      else
        fallback()
      end
    end),
    ['<C-S-s>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm()
      -- elseif copilot.is_visible() then
      --   copilot.accept()
      else
        fallback()
      end
    end),
    -- ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    -- ['<S-CR>'] = cmp.mapping.confirm({
    --   behavior = cmp.ConfirmBehavior.Replace,
    --   select = true,
    -- }),
  },
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'nvim_lsp_signature_help' },
  }, {
    { name = 'buffer' },
  }),
  matching = {
    disallow_fuzzy_matching = true,
    disallow_partial_matching = true,
    disallow_prefix_unmatching = true,
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      prioritize_snippet_on_exact_match,

      -- Below is the default comparitor list and order for nvim-cmp
      cmp.config.compare.offset,
      -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  formatting = {
    format = function(_, item)
      local icons = icons.kinds
      if icons[item.kind] then
        item.kind = icons[item.kind] .. item.kind
        return item
      end
    end,
  },
  -- experimental = {
  --   ghost_text = {
  --     enabled = false,
  --     hl_group = "LspCodeLens",
  --   },
  -- },
})

-- cmp.event:on('menu_opened', function()
--   vim.b.copilot_suggestion_hidden = true
-- end)
--
-- cmp.event:on('menu_closed', function()
--   vim.b.copilot_suggestion_hidden = false
-- end)
