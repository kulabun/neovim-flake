{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) readFile;
in {
  packages = with pkgs.vimPlugins; [
    indent-blankline-nvim
  ];
  config = readFile ./init.lua;
}
