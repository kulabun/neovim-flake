require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = false,
  },
  panel = {
    enabled = false,
    auto_refresh = false,
  },
  filetypes = {
    toml = false,
    json = false,
    yaml = false,
    text = false,
    plaintext = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    ["."] = false,
  },
  server_opts_overrides = {
    settings = {
      advanced = {
        inlineSuggestCount = 3,
      }
    },
  }
})
-- require("copilot_cmp").setup()
--

local cmp = require("cmp")
local lspkind = require("lspkind")
local copilot = require("copilot.suggestion")

local function is_prompt()
  return vim.api.nvim_buf_get_option(0, "buftype") == "prompt"
end

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local function is_text_unfinished()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local prev_symbol = string.sub(line, col, col)
  vim.notify("prev_symbol `" .. prev_symbol .."`")
  return col ~= 0 and string.match(prev_symbol, "^[a-zA-Z0-9:%.]$") ~= nil
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
    -- insert_text = require("copilot_cmp.format").remove_existing,
  },
  completion = {
    autocomplete = false,
    completeopt = "menu,menuone,noselect,noinsert",
  },
  sorting = {
    -- priority_weight = 2,
    comparators = {
      -- require("copilot_cmp.comparators").prioritize,
      -- require("copilot_cmp.comparators").score,
      --
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
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and cmp.get_selected_entry() then
        cmp.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false, -- select first element if none are selected
        })
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
      elseif has_words_before and copilot.is_visible() then
        copilot.accept()
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
  sources = cmp.config.sources({
    -- { name = "copilot", priority = 25 }, -- github copilot
    { name = "nvim_lsp_signature_help", priority = 20 },
    { name = "nvim_lsp", priority = 20 }, -- lsp based completion
  }, {
    { name = "luasnip", priority = 15 }, -- snippets
  }, {
    { name = "path", priority = 10 }, -- path completion
  }, {
    { name = "buffer", priority = 1 }, -- buffer based completion
  }),
  experimental = {
    ghost_text = false,
  },
})

vim.keymap.set("i", "<C-l>", function()
  if cmp.visible() then
    cmp.scroll_docs(4)
  elseif luasnip.choice_active() then
    ls.change_choice(1) 
  elseif copilot.is_visible() then
    copilot.next()
  end
end, {})
vim.keymap.set("i", "<C-h>", function()
  if cmp.visible() then
    cmp.scroll_docs(-4)
  elseif luasnip.choice_active() then
    ls.change_choice(-1) 
  elseif copilot.is_visible() then
    copilot.prev()
  end
end, {})

vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP" }, {
  callback = function()
    -- no completion in prompt
    if is_prompt() then
      cmp.close()
      return
    end

    if is_text_unfinished() then
      copilot.dismiss()
      cmp.complete()
    else
      cmp.close()
      if has_words_before() then
        copilot.next()
      else
        copilot.dismiss()
      end
    end
  end,
  pattern = "*",
})
