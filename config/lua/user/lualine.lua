local lualine = require('lualine')
local icons = require('user.config').icons

function fg(name)
  ---@type {foreground?:number}?
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
  local fg = hl and hl.fg or hl.foreground
  return fg and { fg = string.format('#%06x', fg) }
end

lualine.setup({
  options = {
    theme = 'auto',
    globalstatus = true,
    disabled_filetypes = { statusline = { 'dashboard', 'alpha' } },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = {
      {
        'diagnostics',
        symbols = {
          error = icons.diagnostics.Error,
          warn = icons.diagnostics.Warn,
          info = icons.diagnostics.Info,
          hint = icons.diagnostics.Hint,
        },
      },
      { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
      { 'filename', path = 1, symbols = { modified = '  ', readonly = '', unnamed = '' } },
      -- stylua: ignore
      {
        function() return require("nvim-navic").get_location() end,
        cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
      },
    },
    lualine_x = {
      -- stylua: ignore
      -- {
      --   function() return require("noice").api.status.command.get() end,
      --   cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
      --   color = fg("Statement"),
      -- },
      {
        function()
          local icon = icons.kinds.Copilot
          local status = require("copilot.api").status.data
          return icon .. (status.message or "")
        end,
        cond = function()
          local ok, clients = pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
          return ok and #clients > 0
        end,
        color = function()
          local colors = {
            [""] = fg("Special"),
            ["Normal"] = fg("Special"),
            ["Warning"] = fg("DiagnosticError"),
            ["InProgress"] = fg("DiagnosticWarn"),
          }
          local status = require("copilot.api").status.data
          return colors[status.status] or colors[""]
        end,
      },
      -- stylua: ignore
      -- {
      --   function() return require("noice").api.status.mode.get() end,
      --   cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
      --   color = fg("Constant"),
      -- },
      -- stylua: ignore
      {
        function() return "  " .. require("dap").status() end,
        cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
        color = fg("Debug"),
      },
      {
        'diff',
        symbols = {
          added = icons.git.added,
          modified = icons.git.modified,
          removed = icons.git.removed,
        },
      },
    },
    lualine_y = {
      { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
      { 'location', padding = { left = 0, right = 1 } },
    },
    lualine_z = {
      function()
        return ' ' .. os.date('%R')
      end,
    },
  },
  extensions = { 'neo-tree', 'lazy' },
})
