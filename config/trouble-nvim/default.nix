{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) readFile;
in {
  packages = with pkgs.vimPlugins; [
    trouble-nvim
  ];
  config = readFile ./init.lua;
}
