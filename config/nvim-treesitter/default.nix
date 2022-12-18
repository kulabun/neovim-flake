{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) readFile;
in {
  packages = with pkgs.vimPlugins; [
    nvim-treesitter-textobjects
    nvim-treesitter-refactor
    nvim-treesitter-context
    nvim-ts-context-commentstring
    nvim-ts-autotag
    nvim-ts-rainbow # it'is buggy
    nvim-treesitter.withAllGrammars
  ];
  config = readFile ./init.lua;
}
