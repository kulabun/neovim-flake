{
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib) readFile;
  inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
  copilot-lua = buildVimPluginFrom2Nix {
    pname = "copilot-lua";
    version = "master";
    src = inputs.plugin-copilot-lua;
    meta = {
      description = "Copilot plugin for Neovim in Lua";
      license = lib.licenses.mit;
    };
  };
  copilot-cmp = buildVimPluginFrom2Nix {
    pname = "copilot-cmp";
    version = "master";
    src = inputs.plugin-copilot-cmp;
    meta = {
      description = "Copilot cmp source for Neovim";
      license = lib.licenses.mit;
    };
  };
in {
  packages = with pkgs.vimPlugins; [
    nvim-cmp

    cmp-nvim-lsp
    cmp-buffer
    cmp-path
    cmp-nvim-lsp-signature-help
    lspkind-nvim
    luasnip
    cmp_luasnip
    friendly-snippets

    copilot-lua
    copilot-cmp

    # cmp-treesitter
    # cmp-nvim-lsp-signature-help
    cmp-cmdline
    cmp-cmdline-history
  ];
  config = readFile ./init.lua;
}
