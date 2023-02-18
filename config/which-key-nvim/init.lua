local wk = require("which-key")

wk.setup({
  key_labels = {
    ["<space>"] = "SPC",
    ["<cr>"] = "RET",
    ["<tab>"] = "TAB",
  },
})

wk.register({
  ["<tab>"] = {
    name = "+Window Management",
    h = { "<cmd>wincmd h<cr>", "Select left window" },
    l = { "<cmd>wincmd l<cr>", "Select right window" },
    j = { "<cmd>wincmd j<cr>", "Select window below" },
    k = { "<cmd>wincmd k<cr>", "Select window above" },
    n = { "<cmd>bnext<cr>", "Next buffer" },
    p = { "<cmd>bprevious<cr>", "Previous buffer" },
  },
}, { mode = "n" })

-- In terminal it may be not simble to get Function keys work with modifiers
wk.register({
  ["<leader>."] = { vim.lsp.buf.code_action, "Show code actions" },
  ["<F1>"] = { "<cmd>bn help<cr>", "Show help" },
  ["<F2>"] = { vim.lsp.buf.rename, "Rename symbol" },
  ["<F12>"] = { vim.lsp.buf.definition, "Go to definition" },
  ["<C-S-i>"] = {
    function()
      vim.lsp.buf.format({ async = true })
    end,
    "Format document",
  },
})

local has_trouble, trouble = pcall(require, "trouble")
if has_trouble then
  local function show_diagnostics_panel()
    trouble.toggle({ mode = "workspace_diagnostics" })
  end

  wk.register({
    ["<C-S-m>"] = { show_diagnostics_panel, "Show code actions" },
  })
end

local has_telescope, telescope = pcall(require, "telescope")
if has_telescope then
  local dropdown = require("telescope.themes").get_dropdown
  local ivy = require("telescope.themes").get_ivy
  local builtin = require("telescope.builtin")

  local function telescope_help()
    local help_map = {
      nix = require("telescope-manix").search,
    }
    if help_map[vim.bo.filetype] ~= nil then
      help_map[vim.bo.filetype]()
    else
      vim.notify("No help for this filetype")
    end
  end

  local function telescope_buffers()
    builtin.buffers()
  end

  local function telescope_project_files()
    builtin.find_files()
  end

  local function telescope_project_grep()
    builtin.live_grep()
  end

  local function telescope_recent_files()
    builtin.oldfiles()
  end

  local function telescope_git_commits()
    builtin.git_commits()
  end

  local function telescope_git_branches()
    builtin.git_branches()
  end

  local function telescope_document_symbols()
    builtin.lsp_document_symbols({
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
    })
  end

  wk.register({
    ["<C-p>"] = { builtin.find_files, "Quick Open, Go to file.." },
    ["<C-S-o>"] = { telescope_document_symbols, "Quick Open, Go to file.." },
  }, { mode = "n" })

  wk.register({
    ["<cr>"] = {
      name = "+Telescope",
      p = { telescope_project_files, "Go to project file" },
      u = { telescope_buffers, "Go to buffer" },
      y = {
        name = "+Help Vim",
        c = { "<cmd>Telescope commands<cr>", "VIM Commands" },
        r = { "<cmd>Telescope reloader<cr>", "Relead VIM module" },
        o = { "<cmd>Telescope vim_options<cr>", "VIM Options" },
        t = { "<cmd>Telescope help_tags<cr>", "Help VIM tags" },
      },
      f = {
        name = "+File",
        a = { "<cmd>enew<cr>", "New File" },
        -- o = { fun.open_project_file, "Open File in Workspace" },
        -- e = { fun.recent_project_files, "Open Recent File" },
        -- p = { fun.recent_projects, "Open Workspace" },
        -- f = { fun.grep_in_project, "Find In Workspace(grep)" },
        -- s = { fun.symbol_in_project, "Find In Workspace" },
      },
      t = {
        name = "+Other",
        h = { telescope_help, "Show Language Specific Help" },
        t = { "<cmd>Telescope<cr>", "Telescope" },
      },
      -- ["<F1>"] = { "<cmd>Neotree toggle float<cr>", "Neotree toggle" },
      -- ["<F2>"] = { "<cmd>ToggleTerm<cr>", "Terminal toggle" },
      -- ["<F3>"] = { "<cmd>Telescope keymaps<cr>", "Telescope" },
      -- ["<F4>"] = { "<cmd>Telescope<cr>", "Telescope" },
    },
  }, { mode = "n" })
end

local has_neotree, neotree = pcall(require, "neo-tree")
if has_neotree then
  wk.register({
    ["<tab>"] = {
      f = { "<cmd>Neotree filesystem reveal left toggle<cr>", "Toggle files panel" },
      g = { "<cmd>Neotree git_status reveal left toggle<cr>", "Toggle git-status panel" },
      b = { "<cmd>Neotree buffers reveal left toggle<cr>", "Toggle buffers panel" },
    },
  }, { mode = "n" })
end
