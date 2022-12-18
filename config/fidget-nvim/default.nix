{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) readFile;
in {
  packages = with pkgs.vimPlugins; [
    fidget-nvim
  ];
  config = readFile ./init.lua;
}
