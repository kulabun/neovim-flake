{ pkgs
, lib
, ...
}:
let
  inherit (lib) readFile;
in
{
  packages = with pkgs.vimPlugins; [
    which-key-nvim
  ];
  config = readFile ./init.lua;
}
