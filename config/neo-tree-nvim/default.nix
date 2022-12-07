{ pkgs
, lib
, ...
}:
let
  inherit (lib) readFile;
in
{
  packages = with pkgs.vimPlugins; [
    neo-tree-nvim
    plenary-nvim
    nui-nvim
    # nvim-web-devicons
  ];
  config = readFile ./init.lua;
}
