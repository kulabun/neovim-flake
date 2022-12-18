{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) readFile;
in {
  packages = with pkgs.vimPlugins; [
    lualine-nvim
  ];
  config = readFile ./init.lua;
}
