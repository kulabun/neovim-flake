{
  pkgs,
  lib,
  inputs,
  ...
}: {
  plugins = {
    sonokai = import ./sonokai {inherit pkgs lib;};
    neo-tree-nvim = import ./neo-tree-nvim {inherit pkgs lib;};
    nvim-web-devicons = import ./nvim-web-devicons {inherit pkgs lib;};
    nvim-treesitter = import ./nvim-treesitter {inherit pkgs lib;};
    comment-nvim = import ./comment-nvim {inherit pkgs lib;};
    nvim-lspconfig = import ./nvim-lspconfig {inherit pkgs lib;};
    lualine-nvim = import ./lualine-nvim {inherit pkgs lib;};
    which-key-nvim = import ./which-key-nvim {inherit pkgs lib;};
    todo-comments-nvim = import ./todo-comments-nvim {inherit pkgs lib;};
    settings = import ./settings {inherit pkgs lib;};
    nvim-cmp = import ./nvim-cmp {inherit pkgs lib inputs;};
    telescope-nvim = import ./telescope-nvim {inherit pkgs lib;};
    indent-blankline-nvim = import ./indent-blankline-nvim {inherit pkgs lib;};
    bufferline-nvim = import ./bufferline-nvim {inherit pkgs lib;};
    nvim-scrollbar = import ./nvim-scrollbar {inherit pkgs lib;};
    project-nvim = import ./project-nvim {inherit pkgs lib;};
  };
}
