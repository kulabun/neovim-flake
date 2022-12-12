require("copilot").setup({
  panel = {
    enabled = false,
  },
  suggestion = {
    enabled = false,
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    ["."] = false,
  },
})
require("copilot_cmp").setup()

local cmp = require("cmp")
local lspkind = require("lspkind")

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

require("luasnip.loaders.from_vscode").lazy_load()
local luasnip = require("luasnip")

vim.cmd("set completeopt=menu,menuone,noselect,noinsert")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  preselect = cmp.PreselectMode.None,
  formatting = {
    -- fields = { "kind", "abbr", "menu" },
    fields = { "abbr", "menu", "kind" },
    format = lspkind.cmp_format({
      mode = "symbol_text",
      preset = "codicons",
      maxwidth = 100, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = "..", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      symbol_map = {
        Copilot = "  ",

        Text = "  ",
        Method = "  ",
        Function = "  ",
        Constructor = "  ",
        Field = "  ",
        Variable = "  ",
        Class = "  ",
        Interface = "  ",
        Module = "  ",
        Property = "  ",
        Unit = "  ",
        Value = "  ",
        Enum = "  ",
        Keyword = "  ",
        Snippet = "  ",
        Color = "  ",
        File = "  ",
        Reference = "  ",
        Folder = "  ",
        EnumMember = "  ",
        Constant = "  ",
        Struct = "  ",
        Event = "  ",
        Operator = "  ",
        TypeParameter = "  ",
      },
    }),
    insert_text = require("copilot_cmp.format").remove_existing,
  },
  completion = {
    autocomplete = false,
    completeopt = "menu,menuone,noselect,noinsert",
  },
  sorting = {
    -- priority_weight = 2,
    comparators = {
      require("copilot_cmp.comparators").prioritize,
      require("copilot_cmp.comparators").score,

      cmp.config.compare.offset,
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
  mapping = {
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and cmp.get_selected_entry() then
        cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false, -- select first element if none are selected
        })()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-b>"] = vim.schedule_wrap(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  -- sources are broken in groups. buffer completions will not be even shown when lsp, snippets or path compleptions exists
  sources = cmp.config.sources(
    {
      { name = "copilot", priority = 25 }, -- github copilot
      { name = "nvim_lsp_signature_help", priority = 20 },
      { name = "nvim_lsp", priority = 20 }, -- lsp based completion
    },
    {
      { name = "luasnip", priority = 15 }, -- snippets
    },
    {
      { name = "path", priority = 10 }, -- path completion
    },
    {
      { name = "buffer", priority = 1 }, -- buffer based completion
    }),
  experimental = {
    ghost_text = true,
  },
})
--
-- -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline("/", {
--   completion = {
--     autocomplete = true,
--     completeopt = "menu,menuone,noselect,noinsert",
--   },
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = "buffer" },
--   },
-- })
--
-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(":", {
--   completion = {
--     autocomplete = true,
--     completeopt = "menu,menuone,noselect,noinsert",
--   },
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = "path" },
--   }, {
--     { name = "cmdline" },
--   }),
-- })

vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})

-- Taken from https://github.com/hrsh7th/nvim-cmp/issues/519
vim.api.nvim_create_autocmd(
  { "TextChangedI", "TextChangedP" },
  {
    callback = function()
      -- no completion in prompt
      local buftype = vim.api.nvim_buf_get_option(0, "buftype")
      if buftype == "prompt" then
        require('cmp').close()
        return
      end

      local line = vim.api.nvim_get_current_line()
      local cursor = vim.api.nvim_win_get_cursor(0)[2]

      local prev_symbol = string.sub(line, cursor, cursor)
      vim.notify("prev_symbol: '" .. prev_symbol .. "'")
      if cursor ~= 0 and (string.match(prev_symbol, '^[a-zA-Z0-9:%.]$') ~= nil) then
        vim.notify("completion triggered based of '" .. prev_symbol .. "'")
        require('cmp').complete()
      else
        vim.notify("close popup")
        require('cmp').close()
      end

      -- local current = string.sub(line, cursor, cursor + 1)
      -- if current == "." or current == "," or current == " " then
      --   require('cmp').close()
      -- end
      --
      -- if cursor == 0 then
      --   require('cmp').close()
      --   return
      -- end
      --
      -- local before_line = string.sub(line, 1, cursor + 1)
      -- local after_line = string.sub(line, cursor + 1, -1)
      -- -- skip completion popup if we are in empty line
      -- if not string.match(before_line, '^%s+$') then
      --   -- if the line is not empty, then show completion popup only if the cursor is in the end of line or right after space or dot
      --   if after_line == "" or string.match(before_line, " $") or string.match(before_line, "%.$") then
      --     require('cmp').complete()
      --   end
      -- end
    end,
    pattern = "*"
  })
